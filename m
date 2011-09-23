Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab1IWRvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 13:51:16 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:39463 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab1IWRvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 13:51:14 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Manjunath GKondaiah <manjunath.gkondaiah@linaro.org>,
        linux-kernel@vger.kernel.org, Dilan Lee <dilee@nvidia.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH v3] drivercore: Add driver probe deferral mechanism
In-Reply-To: Your message of "Thu, 22 Sep 2011 15:19:01 MDT."
             <CACxGe6vAQ+_SKc-zH434bdd3akM5S1jB0N7+AFEjgZfX1uNrZQ@mail.gmail.com>
From: Valdis.Kletnieks@vt.edu
References: <20110922184614.25419.84606.stgit@ponder> <20110922212909.49966cf4@lxorguk.ukuu.org.uk>
            <CACxGe6vAQ+_SKc-zH434bdd3akM5S1jB0N7+AFEjgZfX1uNrZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1316800223_4577P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Fri, 23 Sep 2011 13:50:23 -0400
Message-ID: <7790.1316800223@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=steiner.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020206.4E7CC6E1.00D6,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1316800223_4577P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Thu, 22 Sep 2011 15:19:01 MDT, Grant Likely said:
> On Thu, Sep 22, 2011 at 2:29 PM, Alan Cox <alan=40lxorguk.ukuu.org.uk> =
wrote:
> > Definitely what is needed for some of the x86 SoC stuff and would let=
 us
> > rip out some of the special case magic for the SCU discovery.
> >
> > First thing that strikes me is driver_bound kicks the processing queu=
e
> > again. That seems odd - surely this isn't needed because any driver t=
hat
> > does initialise this time and may allow something else to get going w=
ill
> > queue the kick itself. Thus this seems to just add overhead.
> >
> > It all looks a bit O(N=B2) if we don't expect the drivers that might
> > trigger something else binding to just say 'hey I'm one of the
> > troublemakers'
>=20
> The way I read it, absolute worst case is when every device but one
> depends on another device.  In that case I believe it will be
> O(Nlog(N)).  (Every device gets probed on the first pass, but only the
> last one gets probed.  Then it goes through N-1 devices to the result
> of only 1 more device getting probed, then N-2, etc.).=20

That is indeed O(N**2) not Nlog(N).  The total number of probes is (N+1)(=
N)/2
To get it to O(Nlog(N)), you'd have to probe N devices the first pass, N/=
2 devices
on the second pass, N/4 on the third, and so on.


--==_Exmh_1316800223_4577P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFOfMbfcC3lWbTT17ARAvHPAKCjO9UPW25w2Vx+0hFs0jUQK3T87QCdFr81
xTuPM4IAvAXeCJX7xt6rbv0=
=3pAq
-----END PGP SIGNATURE-----

--==_Exmh_1316800223_4577P--

