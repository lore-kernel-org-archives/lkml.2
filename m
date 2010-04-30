Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475Ab0D3TNA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:13:00 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:22832 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510Ab0D3Q6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:58:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=emrwgUjmPZRzNqFhVmiyLPyO5jvymNB9LyEn9mK2u3YPT0c58nQfextOyapx+gz4W6
         GdI4GoLt8KmAxIt0z1+IsRqWYM2jzovTwZ5e5xLe7jEecekSaN8JoVoYh/rVXaZxa7JD
         K5r1kfrNXVgVI0T3Htw/Xeq3aiR1AANQ04K54=
Date: Fri, 30 Apr 2010 13:07:09 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Wolfram Sang <w.sang@pengutronix.de>, linux-i2c@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: i2c-i801 retries on lost arbitration (resent: no gpg)
Message-ID: <20100430100709.GD3553@swordfish.minsk.epam.com>
References: <20100430094412.GC3553@swordfish.minsk.epam.com>
 <20100430114822.1a5e0cf9@hyperion.delvare>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PuGuTyElPB9bOcsM"
Content-Disposition: inline
In-Reply-To: <20100430114822.1a5e0cf9@hyperion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PuGuTyElPB9bOcsM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (04/30/10 11:48), Jean Delvare wrote:
> Hi Sergey,
>=20
>=20
> > Both i2c spec and ICH7 datasheet requires to restart transaction in
> > case of lost arbitration.
> >=20
> > "No information is lost during the arbitration process. A master that
> > loses the arbitration can generate clock pulses until the end of the
> > byte in which it loses the arbitration and must restart its transaction
> > when the bus is idle."
> >        =20
> > Please see the following patch. Is it correct?
>=20
> No, it's not. As you wrote above, this is not specific to the Intel ICH
> but a general I2C issue. As such it must be handled in i2c-core and not
> by individual drivers. And as a matter of fact, it is already handled.
> Look at functions i2c_transfer and i2c_smbus_xfer in i2c-core.c, see
> the comments "Retry automatically on arbitration loss", the code is
> already there. It's just a matter of bus drivers properly setting
> adapter->retries (which i2c-i801.c does already.)
>=20
Thanks.

> So I don't know which kernel you're using, but with the latest upstream
> kernel, things should work just fine already.
>=20

OK. Thanks a lot.


	Sergey

=09

--PuGuTyElPB9bOcsM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkvaq80ACgkQfKHnntdSXjSDfwP+OpAlzT7Ze0a9uxTb8YQlpEno
YKSK6agneTDAcvRp14lQ/Z7fIp8OXOjeacZ9aiCLcG8HqXSzBssDU6g6Th90B6HT
l392L6UgKh/Ipa0sDM1dozoj7TQwOfzCEqwB8p3YhrtdG1SAknaexm0TkBpqR0BE
p6jXt936g1C9I1RgoyE=
=vLWa
-----END PGP SIGNATURE-----

--PuGuTyElPB9bOcsM--
