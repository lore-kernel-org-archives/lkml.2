Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab2DRKtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 06:49:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44625 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751200Ab2DRKtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 06:49:01 -0400
Date: Wed, 18 Apr 2012 11:48:58 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@ti.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] clk: Provide dummy clk_unregister()
Message-ID: <20120418104857.GI3021@opensource.wolfsonmicro.com>
References: <1334736433-3402-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120418095435.GX24211@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VkVuOCYP9O7H3CXI"
Content-Disposition: inline
In-Reply-To: <20120418095435.GX24211@n2100.arm.linux.org.uk>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VkVuOCYP9O7H3CXI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 18, 2012 at 10:54:35AM +0100, Russell King - ARM Linux wrote:

> Don't make unregister calls return values.  Think about this situation
> for a moment:

> 	You call an unregister function in a drivers ->remove function.
> 	The unregister function fails.  However, the reason the ->remove
> 	function is being called is because the module is being removed.
> 	You can't stop the module being removed once the process has
> 	started.  What do you do with this error?

> To put it another way, if an unregister function fails, you're buggered.

I absolutely agree, I think this is a stupid pattern for us to have
(generally the return values just get ignored...) but sadly it appears
to be the pattern that we have return values but ignore them probably
because the driver model does this.

--VkVuOCYP9O7H3CXI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPjpwSAAoJEBus8iNuMP3dwbMP/A+GI+z3mAPzGhVrlbFVCdj2
7kG3v93qIQJUU4ViMnqHCt2JtLg7LHVacRosLGURB5XdF/Jqsnti3XgojfgZq2xF
A8+lfW8iRwNfHiKZ5ZuSVXEIkv34fdCvFTgDjEdAqe68uMMXSUPpVGEFLdhjDuSk
0EGDkRoiWp0FEH1e4oE5GJH7QcESAhQpCToWEsuzJKWAP1obC1rbsR1Z4VeN7s4u
GtBxkVIh/ak94F19241xdODq97bqOzzRcpL0XnkIIQNo5QJBPvi5QsnFyi3NY1Ti
bSQn9uSHCmgaPUE4XBi1orsbcmQ96ymvpDG8UVLJ3ApGyGdb3pc/NQgMAaAnRQ8e
B8oi1jb2RT73JvtC3tTIQrK3xWKhVDkb65YZrLiIIBnRJdDkPSRRSP+He173EN9T
ci2sx/rDWep2LZ+yNxhI3o2q1ckmgdXcvDgBBw2AiCt+scQUOD9Wi+0CTMAc4svU
2JoyDuR0Eevi06zIF1SUBJoocHv4NQ342BT4uFxoM5NFm18ehgXyegtPQRhMWnHP
KHQcvk5lNpiCUxAM+bYQjTEI9WX7EBEGDIkbKTRLdiiWBx54Fm25wvJoO5GU/igK
qnfMbANw3G5yjnCvIrFFHeT1i1d4ghhq01w/z8w3tqnDD9uFrzF4x2xm45o/FZuV
6dS5uLmGFjUrCHfy3hN6
=WHnc
-----END PGP SIGNATURE-----

--VkVuOCYP9O7H3CXI--
