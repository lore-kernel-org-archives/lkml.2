Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab2LUPsX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 10:48:23 -0500
Received: from mailserver5.natinst.com ([130.164.80.5]:44389 "EHLO
	spamkiller05.natinst.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447Ab2LUPsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 10:48:15 -0500
Date: Fri, 21 Dec 2012 09:48:32 -0600
From: Josh Cartwright <josh.cartwright@ni.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Soren Brinkmann <sorenb@xilinx.com>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 4/4] clk: zynq: Use of_init_clk_data()
Message-ID: <20121221154832.GM1005@beefymiracle.amer.corp.natinst.com>
References: <1355778135-32458-1-git-send-email-sboyd@codeaurora.org>
 <1355778135-32458-5-git-send-email-sboyd@codeaurora.org>
 <b11edd0b-27ff-48b3-9f2a-1e7ab293cc34@CO9EHSMHS019.ehs.local>
 <50D223DD.8070208@codeaurora.org>
 <20121219205330.GE1005@beefymiracle.amer.corp.natinst.com>
 <296b6ceb-f248-4add-9b4e-bceddcc1613c@CO1EHSMHS028.ehs.local>
MIME-Version: 1.0
In-Reply-To: <296b6ceb-f248-4add-9b4e-bceddcc1613c@CO1EHSMHS028.ehs.local>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-MIMETrack: Itemize by SMTP Server on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 12/21/2012 09:48:10 AM,
	Serialize by Router on MailServ58-US/AUS/H/NIC(Release 8.5.3FP2 HF169|September
 14, 2012) at 12/21/2012 09:48:10 AM,
	Serialize complete at 12/21/2012 09:48:10 AM
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NQTVMVnDVuULnIzU"
Content-Disposition: inline
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-21_06:2012-12-21,2012-12-21,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NQTVMVnDVuULnIzU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Dec 21, 2012 at 03:28:10PM +0000, Michal Simek wrote:
>=20
>=20
> > -----Original Message-----
> > From: Josh Cartwright [mailto:josh.cartwright@ni.com]
> > Sent: Wednesday, December 19, 2012 9:54 PM
> > To: Stephen Boyd; Michal Simek
> > Cc: Soren Brinkmann; Mike Turquette; linux-kernel@vger.kernel.org; linu=
x-arm-
> > kernel@lists.infradead.org
> > Subject: Re: [PATCH 4/4] clk: zynq: Use of_init_clk_data()
> >=20
> > On Wed, Dec 19, 2012 at 12:30:21PM -0800, Stephen Boyd wrote:
> > > On 12/19/12 11:22, Soren Brinkmann wrote:
> > [..]
> > > >
> > > > A probably unique thing I do is, I set the status of uart0 to
> > > > disabled. This way I can reuse my rootfs which does not run getty on
> > > > ttyPS1. And this worked fine before.
> > > >
> > >
> > > Thanks for testing. It seems that clocks are failing to register.
> > > Please try this patch.
> > >
> > > --->8-----
> > >
> > > diff --git a/drivers/tty/serial/xilinx_uartps.c
> > > b/drivers/tty/serial/xilinx_uartps.c
> > > index 2be22a2..2734715 100644
> > > --- a/drivers/tty/serial/xilinx_uartps.c
> > > +++ b/drivers/tty/serial/xilinx_uartps.c
> > > @@ -948,9 +948,9 @@ static int xuartps_probe(struct platform_device *=
pdev)
> > >         struct clk *clk;
> > >
> > >         clk =3D of_clk_get(pdev->dev.of_node, 0);
> > > -       if (!clk) {
> > > -               dev_err(&pdev->dev, "no clock specified\n");
> > > -               return -ENODEV;
> > > +       if (IS_ERR(clk)) {
> > > +               dev_err(&pdev->dev, "failed to get clock\n");
> > > +               return PTR_ERR(clk);
> > >         }
> > >
> > >         rc =3D clk_prepare_enable(clk);
> >=20
> > Yes, indeed.
> >=20
> > As a side note, this is introduced in my patch "serial: xilinx_uartps:
> > get clock rate info from dts", which is in xilinx/arm-next (and thus in=
 linux-next),
> > but as far as I can tell, didn't ever make it into the arm-soc tree.
> >=20
> > Michal, did you have plans for pushing this through arm-soc?
>=20
> I have had this patch in my devel branch for a while.=20
> It is in arm-next tree right now and I will provide path to mainline.

Will you be rolling in Stephen's suggestions, or should he/I cook up a
patch on top with the fix in place?

It probably makes sense to pull the quoted fix above directly into the
patch before it hits mainline, and we can change the use of of_clk_get
as a patch on top.  Thoughts?

Thanks,

  Josh

--NQTVMVnDVuULnIzU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ1ITQAAoJEEef0niEbw+lQG4QAJrkZPWPV2ZZoE0tch0ugtrb
D5whO0eaa0DrOpv9OJdB4OA6sSTpRX/J7jIzUvPr2Nf9G0cYxztS+HW0RKcapZQk
kvLSwtthqdb+oIx2Qw7xGfkeZ4zOH7FG3A+onqdmFLdHRrV2kzkkyB7dB/ZGaGot
NYX5c9S2COSPhOCS61SUxcaX7MUid1glGlFmNIul1NyF5fca2veAZ41MhUGRwruU
vbJOGd03vjjCmfebKJ2jtpEEzU3aUqbB0P7DT6IqrOgmvQJHcMom4ARR6gM0u0aO
j3qCSKeAcq3uPzZh2ydd/3hSMmqkmZwtmq4eRQuOCrc3iLjeysjPLexr3VqTLY6F
d9wOB8LfYmJt5rF+lmVlbcmsPVFlYqG9zrcgHMzL9nS8/aV0KFLdkLmTmevU5CdO
LNAeu69Ajsa87UQhYudOGykLJ1nB3mW46etDvjt/ZS683jt02vGaP+nOp081+fAi
dwOfdXo8+7iCFZMBDkWdqJQoifAIMNGNnq1ZmEG6cXdOa8Q5qR31gTD7rDfSVLmm
e2bsI7iMud0iQTGPwl5wv1IajeRBsPuKk2pwjDo27PfGoBkCV+2Nyg4H1tjUFfeO
NP6GfN+liz2bsym+1Gg3WlKpP/wLVkbyBQz0jf33lFNvlH+2xd9ocjDwM3kjrPD3
OJTZ5+qH4FD5skImbHtO
=BqXy
-----END PGP SIGNATURE-----

--NQTVMVnDVuULnIzU--
