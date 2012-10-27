Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759481Ab2J0Vht (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 17:37:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52443 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758120Ab2J0Vhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 17:37:48 -0400
Date: Sat, 27 Oct 2012 22:37:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpiolib: Don't return -EPROBE_DEFER to sysfs, or for
 invalid gpios
Message-ID: <20121027213744.GF4564@opensource.wolfsonmicro.com>
References: <1351162983-27723-1-git-send-email-mathias.nyman@linux.intel.com>
 <CACRpkdYPbs34Ob+MN9tjevXPTwGnEYsyJG0LMjCqsfxP=S_FJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GV0iVqYguTV4Q9ER"
Content-Disposition: inline
In-Reply-To: <CACRpkdYPbs34Ob+MN9tjevXPTwGnEYsyJG0LMjCqsfxP=S_FJA@mail.gmail.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GV0iVqYguTV4Q9ER
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 26, 2012 at 09:26:33AM +0200, Linus Walleij wrote:
> On Thu, Oct 25, 2012 at 1:03 PM, Mathias Nyman

> > gpios requested with invalid numbers, or gpios requested from userspace via sysfs
> > should not try to be deferred on failure.

> Very good catch. I applied this to my fixes branch and also
> put the stable tag on this thing, it goes way back to the introduction
> of deffered probe.

> Mark: OK with this?

The invalid numbers thing I'm a bit meh on.  It came up before and I
personally wasn't sure if the issue wasn't with gpio_is_valid() only
checking for "this number could possibly ever be a GPIO" and not doing
any checking against the GPIOs that have actually been registered.  If
it's the former then ideally at some point in the future we'll remove
the big table and gpio_is_valid() will always be true.

--GV0iVqYguTV4Q9ER
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQjFQgAAoJELSic+t+oim9YaQP/jxa/Pij3+KcWJ7IiiWXu35G
ZUUzHKIdvOavvNZaWTOSJB3TVfItvu8c+Fdj//3jtj2Zliwu4RLedpeOJTM7siKH
j20Nk/1AJ68/Sa7V4I5CRjDD7ZFKyGEGfteW4Hh/Ot6z9IiCkXPkxtyAGTEk6tK4
gOaTNIeL98yB9UedRGHVZ6YJS/BRHpLdNpvqOFis+3KDwCugAlnVxlfnTdyzNxnU
JjNytfBF7E9t9n/VVC7vPI5mCAy3tI7CYjtvUI34+KmHAbR/KfyJdMznxDrdGFuR
rBLK8bMoBRLUhZ/udxk/8HDXkBRHvhsmSPdO8zwQdQmQiGX0LgBrEg4badE9IBEI
GCIhBONi7TOUibkVFHUzsL+yCT+jn9PT3C1FdjT2aJdBJPlqyKgrBU1oUZedKxem
Fv5rC1P/2Xmqvx/uKAgDWP2Au9t9VaMfQo88t8JIvMEYhTddfdEncADgk4BgoxPl
mZqkYFTu35Kthiwy/zqc5j8KeuArt1jgXMIR/tfZgLkwVUhWbKnfSUf61VE21XeN
Kyk5MQJ1eFN5llbQ8qM0MwAaM8Z/15cH/7waOkWFf4NEAn54mYQyeI7no6NbxpoF
Ds5HOv8jvS2k+xTS+EMUrBhZxprdAn7KWRdtlguciU5d+iFLLms8FIr/5XIIZKYt
gIrfUBLMPb7xpwJYxPS2
=20Kx
-----END PGP SIGNATURE-----

--GV0iVqYguTV4Q9ER--
