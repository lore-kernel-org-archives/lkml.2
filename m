Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab2DEJ57 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 05:57:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35176 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753113Ab2DEJ56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 05:57:58 -0400
Date: Thu, 5 Apr 2012 10:57:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: Silence uninitialized variable warning for
 wm8994-core
Message-ID: <20120405095754.GF3129@opensource.wolfsonmicro.com>
References: <1333597752.10597.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UBnjLfzoMQYIXCvq"
Content-Disposition: inline
In-Reply-To: <1333597752.10597.1.camel@phoenix>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UBnjLfzoMQYIXCvq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 05, 2012 at 11:49:12AM +0800, Axel Lin wrote:

> -	int ret, i, patch_regs;
> +	int ret, i, patch_regs = 0;

This just unconditionally squashes any possible warnings from this which
isn't great.  If we're going to work around flow analysis bugs like this
it's better to do it by doing something like adding an assignment in the
paths that GCC isn't figuring out than by just squashing everything.

--UBnjLfzoMQYIXCvq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfWybAAoJEBus8iNuMP3dF8oP/Rk4c4TxuX9L4HQGUgD8NyTa
adNi+/VXNnHR640Mz4FQ4rrzPZMm4+y3qLk1YqsQqVD/rs+qeKbL+C0m+HbMTIxs
Nvb76Q6m4zbTSpYp5D9cSAE9wsQm7VMPIQMfEsmfcQG7YVINoVWa3VgmJB9Af8qT
4OZhVyd0oDxg9Td4SThQRcZAYaT5n2xEBCP9dFmojyKzRp/gQIbVgqmbdEmhuv5U
/KBTO7kGfXw6clzITyl1bGYompYItpx415GJGONfn/OH+evbSEuHSJDh1PUUKsxg
ly3K86/wSxv7+84cR7jRIvU9SY2oEGSWOV8vKidVrWMtFoZhemWuBwwGMO7nsqQA
MOSa7KQMDBvnN77+DxbrI0PIwzgfzjLiCLQysnLg9z0bx3JqS37Iew9n/+lmczkM
J/r5ImjNWvwJelFuJlhwnFh/JX+89TluN55xtF7pQ+53Rn/JwaZ92cCDnaB4VU3g
Bd+mJCgj/I0b32rq0aa65RhQYodwu0nGTD+z828phC1+78M3N9DZSDgf+0S/4eEq
jYhgyd6Xaxk8gvo4aAFVRB5XXXcBrexG30vRb0iXnteGzHiX0WSsmH7q44NtDKdF
svaTEULwyXtlL6FsLv+a/XnAzq11QDgdUu/gx9Hu66+wG5miheLKoB8YpGXeKcOZ
maC3jQtXjfsWmAM4TCPQ
=n27z
-----END PGP SIGNATURE-----

--UBnjLfzoMQYIXCvq--
