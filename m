Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab2KUOBP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 09:01:15 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:36025 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab2KUOBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 09:01:14 -0500
X-Authority-Analysis: v=2.0 cv=OOOlLFmB c=1 sm=0 a=QKCpt3RAcCy1PgeoOVilzg==:17 a=2oGSFm5vdZwA:10 a=wom5GMh1gUkA:10 a=pTRqrO9sSn4A:10 a=649elMfuWG0A:10 a=svWV0_fRAAAA:8 a=erfvF8y-hRwA:10 a=B3vXKxRM_QVQcc3wN1gA:9 a=CjuIK1q_8ugA:10 a=nvSzoFeKqj5LNWBiyb8A:9 a=QKCpt3RAcCy1PgeoOVilzg==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 24.73.230.86
Date: Wed, 21 Nov 2012 09:01:10 -0500
From: Solomon Peachy <pizza@shaftnet.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] [firmware_class] Fix compile with no builtin firmware
Message-ID: <20121121140109.GA7549@shaftnet.org>
References: <1353422714-18327-1-git-send-email-pizza@shaftnet.org>
 <CACVXFVM=+Gus1_6U82G6_mszoRNsqb24Y+F7UPPLPBgzQasaew@mail.gmail.com>
 <20121120161011.GD18015@shaftnet.org>
 <20121120163309.GB4990@kroah.com>
 <20121120181203.GA7922@shaftnet.org>
 <20121121093528.4fe11c26@tom-ThinkPad-T410>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <20121121093528.4fe11c26@tom-ThinkPad-T410>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 21, 2012 at 09:35:28AM +0800, Ming Lei wrote:
> Solomon, I can't duplicate the build failure with your .config on 3.7-rc5=
-next.

Okay, so it's since been fixed. =20

> >  * The #ifdef wraps code that pertains solely to built-in firmware, (ie=
=20
> >    CONFIG_FIRMWARE_IN_KERNEL) and has an #else path for when it's disab=
led.
> >  * There is no point in a CONFIG_FW_LOADER test inside firmware_class.c=
=20
> >    when the file isn't even compiled unless CONFIG_FW_LOADER is defined.
>=20
> Enabling CONFIG_EXTRA_FIRMWARE still can make one firmware built in kernel
> even though CONFIG_FIRMWARE_IN_KERNEL isn't defined, so your patch will b=
reak
> this case.

So... isn't the logical solution here to make CONFIG_EXTRA_FIRMARE=20
depend on (or enable) CONFIG_FIRMWARE_IN_KERNEL?  After all, the two are=20
apparently related.

I can update my patch to include this, and rewrite the commit message so=20
it's relevant to modern kernels, or I can just drop this and forget the=20
whole affair.

 - Solomon
--=20
Solomon Peachy        		       pizza at shaftnet dot org	=20
Melbourne, FL                          ^^ (mail/jabber/gtalk) ^^
Quidquid latine dictum sit, altum viditur.

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iD8DBQFQrN6lPuLgii2759ARApe3AJ9cJl4paeobB0MFhbonhHzmJbFn0gCgmqtM
ywQ0QErlcOiG5VXyceulkwU=
=57HQ
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
