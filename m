Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375Ab0KUAkS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 19:40:18 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:54379 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab0KUAkR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 19:40:17 -0500
X-Spam-ASN: 
Date: Sun, 21 Nov 2010 03:40:08 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Joe Perches <joe@perches.com>
Cc: Rodolfo Giometti <giometti@enneenne.com>, linux-kernel@vger.kernel.org,
        "Nikita V. Youshchenko" <yoush@cs.msu.su>, linuxpps@ml.enneenne.com,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv4 10/17] pps: use BUG_ON for kernel API safety checks
Message-ID: <20101121034008.4fef543a@apollo.gnet>
In-Reply-To: <1290272501.27951.27.camel@Joe-Laptop>
References: <cover.1290087473.git.lasaine@lvk.cs.msu.su>
	<1a1ebcf97b2eb62548c34d2d8fc139c0703a9077.1290087480.git.lasaine@lvk.cs.msu.su>
	<20101120161351.GC13356@enneenne.com>
	<1290272501.27951.27.camel@Joe-Laptop>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/R8l74d7uXWogVJQhwFhvyXE"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/R8l74d7uXWogVJQhwFhvyXE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Sat, 20 Nov 2010 09:01:41 -0800
Joe Perches <joe@perches.com> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Sat, 2010-11-20 at 17:13 +0100, Rodolfo Giometti wrote:
> > On Thu, Nov 18, 2010 at 07:01:03PM +0300, Alexander Gordeev wrote:
> > > This way less overhead is involved when running production kernel.
> > > If you want to debug a pps client module please define DEBUG to enable
> > > the checks.
> > > Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>
> []
> > > diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
> > > @@ -179,10 +168,8 @@ void pps_event(struct pps_device *pps, struct pp=
s_event_time *ts, int event,
> > >  	int captured =3D 0;
> > >  	struct pps_ktime ts_real;
> > > =20
> > > -	if ((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) =3D=3D 0) {
> > > -		dev_err(pps->dev, "unknown event (%x)\n", event);
> > > -		return;
> > > -	}
> > > +	/* check event type */
> > > +	BUG_ON((event & (PPS_CAPTUREASSERT | PPS_CAPTURECLEAR)) =3D=3D 0);
> >=20
> > Ack.
> >=20
> > This is a correct usage of BUG_ON. :)
>=20
> I don't think that's true.
>=20
> /*
>  * Don't use BUG() or BUG_ON() unless there's really no way out; one
>  * example might be detecting data structure corruption in the middle
>  * of an operation that can't be backed out of.  If the (sub)system
>  * can somehow continue operating, perhaps with reduced functionality,
>  * it's probably not BUG-worthy.
>  *
>  * If you're tempted to BUG(), think again:  is completely giving up
>  * really the *only* solution?  There are usually better options, where
>  * users don't need to reboot ASAP and can mostly shut down cleanly.
>  */

Hmm, didn't check that before. What is more appropriate in this
situation?

--=20
  Alexander

--Sig_/R8l74d7uXWogVJQhwFhvyXE
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJM6GpoAAoJEElrwznyooJbuccH/RXjfot2PEbz3ag8qzdtDbzW
JUNVWJxbF5+u9o+/M/TXSa8eLguL7L2iXVLN7DVR63m0keQSvaNlPH16Rn9lbEy9
HK10g5Y4XxEJg8Flq3o5U8d6UncXDdeMwV+rT8S98BJ+cJAaiAs/qqmSDDj6HVQ8
Tf/06JnsPhO8rZrtw19BfZ68LVeOKbLxJN1r4Kkrq7/REv9N5L8hL02YqErfq0AQ
FTkcSZhYEEl/xo25B/Qp1A+snuE604XlCMpaIY+rc+RMjO2+bQBbvkVhLBeAg8PC
I6PtyXqe3ClzfqDVXYHbfXqMyH9w0N8UxpwD5OO5de6AQ0YPfFN6nOnl0dnN0Mc=
=oPBp
-----END PGP SIGNATURE-----

--Sig_/R8l74d7uXWogVJQhwFhvyXE--
