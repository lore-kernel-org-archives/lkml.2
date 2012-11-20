Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab2KTSMJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 13:12:09 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:35143 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab2KTSMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 13:12:07 -0500
X-Authority-Analysis: v=2.0 cv=GZOVbHrL c=1 sm=0 a=QKCpt3RAcCy1PgeoOVilzg==:17 a=2oGSFm5vdZwA:10 a=wom5GMh1gUkA:10 a=pTRqrO9sSn4A:10 a=649elMfuWG0A:10 a=svWV0_fRAAAA:8 a=erfvF8y-hRwA:10 a=Ydt4blHB-P6nXVy4_0cA:9 a=CjuIK1q_8ugA:10 a=HwHvl2IHzvvasiQn5MYA:9 a=QKCpt3RAcCy1PgeoOVilzg==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 24.73.230.86
Date: Tue, 20 Nov 2012 13:12:03 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Ming Lei <tom.leiming@gmail.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] [firmware_class] Fix compile with no builtin firmware
Message-ID: <20121120181203.GA7922@shaftnet.org>
References: <1353422714-18327-1-git-send-email-pizza@shaftnet.org>
 <CACVXFVM=+Gus1_6U82G6_mszoRNsqb24Y+F7UPPLPBgzQasaew@mail.gmail.com>
 <20121120161011.GD18015@shaftnet.org>
 <20121120163309.GB4990@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wac7ysb48OaltWcw"
Content-Disposition: inline
In-Reply-To: <20121120163309.GB4990@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wac7ysb48OaltWcw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 20, 2012 at 08:33:09AM -0800, Greg KH wrote:
> > The corresponding .config is attached.  Note that it is for a uClinux=
=20
> > 3.3.0-uc0 kernel.
>=20
> Lots of things have changed in the firmware code since 3.3.0, can you
> retest this on the 3.7-rc6 tree?

Not easily; My employer is contracted to do some driver porting and=20
we're stuck with the kernel the client provided.  However, the patch is=20
still relevant for upstream, because the underlying problem still=20
exists:
=20
 * The #ifdef wraps code that pertains solely to built-in firmware, (ie=20
   CONFIG_FIRMWARE_IN_KERNEL) and has an #else path for when it's disabled.
 * There is no point in a CONFIG_FW_LOADER test inside firmware_class.c=20
   when the file isn't even compiled unless CONFIG_FW_LOADER is defined.

Perhaps the compile problem is solved in newer kernels (by always=20
generating an empty builtin firmware list?) but the #ifdef is still=20
incorrect.

> Also, when sending patches, please cc: the proper maintainers (the
> scripts/get_maintainers.pl tool can help you with that.)

Ooops, sorry.  I'll double-check that next time.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--wac7ysb48OaltWcw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFQq8fzPuLgii2759ARAs1nAJ9/Ovxir0f89ANXEETM3vmhNoZ/eACdF2ue
tnW6yUqUNONSuYfYOn5sfwc=
=UDfB
-----END PGP SIGNATURE-----

--wac7ysb48OaltWcw--
