Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab2BTCMO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 21:12:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44545 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752032Ab2BTCMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 21:12:13 -0500
Date: Sun, 19 Feb 2012 18:12:00 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Fix and simplify debugfs support
Message-ID: <20120220021157.GF3194@opensource.wolfsonmicro.com>
References: <1329636505-13651-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vOmOzSkFvhd7u8Ms"
Content-Disposition: inline
In-Reply-To: <1329636505-13651-1-git-send-email-sboyd@codeaurora.org>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vOmOzSkFvhd7u8Ms
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 18, 2012 at 11:28:25PM -0800, Stephen Boyd wrote:
> If CONFIG_DEBUG_FS=y debugfs functions will never return an
> ERR_PTR. Instead they'll return NULL. The intent is to remove
> ifdefs in calling code.

> Instead of checking for an ERR_PTR check for NULL. This simplifies
> the code and also fixes an error check that would never have
> worked otherwise. While we're here modernize the code to use
> S_IRUGO instead of 0444.

This was actually a deliberate decision to make the code more robust
against change - the IS_ERR_OR_NULL doesn't make the code any bigger but
it means it's less likely to break in the face of changes.

> If we're willing to sacrifice a pointer per rdev we can remove the
> ifdefs and the compiler should be able to optimize away the dead
> code.

Personally I'd be happy to do that, the only reason I put the ifdefs in
there was that it appears to be idiomatic to do so but I'm not really a
big fan of it.  Then again I never build kernls without debugfs support
in them myself...

--vOmOzSkFvhd7u8Ms
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPQau8AAoJEBus8iNuMP3dhi0P/3JY0g49XNv5jMIjozOuS+EW
5/arf6ccoMF2W3wQi1EF2sahcFU90ahFFzKbiSsOdH4nbDMaq/d0DLV7rmXIGBxg
PNYPbTzmt7trUFJhKBWp8CKGlvRT1UlGMc0fUzeuyFkoVoQ3C/HXO5vogHbuJ60g
E1zTLBV82HBrDAM5vCH5yuLMU4kXECGoOwQmEkfRvOymQI5guKjaOc1LI17j3Me0
tXfL7s7xn3bmWjml/lJ1rCsUZRNY6VKztIzzLS6AaAOFYrjHLd4U9+EApypHITgv
abyhE7dFXWFA/JGI8d3KXBS+UbxtdVAMUIghVp3bIUeCU7BvpPkisLat0OXdyAqK
hcnwRFCL4izu/TZRw6cAsXpVGXRsJws0fyyc3iDPyWWuYzflkgVARGxqGgnpJi5P
+vAN9psMrIFncyPdjgX9m2hAkiW14/KEKZXi4NGcuhjL9+t8zDNz7YM0X+g02JIb
I+UWSnuS4ts1IYfgL+RI/FXiZ6Ri1B9xKk7LkekVxcPUKL+ojWTX5XjDwL0nrS4i
fG39DEELgyseCOSgmfuy/ezvXGlFeUANZSIOdVDJRD4zGzVUUWy3/yescbOhQYmJ
yejAv/xqAbeHHnnPoFbFRinP3rGdCn4KojZybOh+4UhVRzKK8OzN+PTqVJnXspg0
ybNgGF/RV+PvPWMbUf/M
=O40J
-----END PGP SIGNATURE-----

--vOmOzSkFvhd7u8Ms--
