Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab2BGLno (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 06:43:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35824 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755379Ab2BGLnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 06:43:43 -0500
Date: Tue, 7 Feb 2012 11:43:41 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>, grant@secretlab.ca
Cc: lrg@ti.com, linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V1] regulator: fixed: Support for open-drain gpio
Message-ID: <20120207114341.GJ3332@opensource.wolfsonmicro.com>
References: <1328611596-13279-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Re2uCLPLNzqOLVJA"
Content-Disposition: inline
In-Reply-To: <1328611596-13279-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Re2uCLPLNzqOLVJA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 07, 2012 at 04:16:36PM +0530, Laxman Dewangan wrote:

> To make the pin to high/low for enabling/disabling the switches,
> the pins will have the pull-up connected and the high/low can be
> set using following methods:
> LOW: gpio_direction_output(gpio, 0) ... this drives the signal
> 	and overrides the pullup.
> HIGH: gpio_direction_input(gpio) ... this turns off the output,
> 	so the pullup (or some other device) controls the signal.

Thinking about this further this is potentially going to apply to any
GPIO output - perhaps we should push the implementation down into
gpiolib so we just specify a flag when requesting the GPIO and then
gpiolib does the pull low/high Z thing for us.  That would be much less
effort in individual drivers, we'd just need to be able to set the flag
and could potentially directly use any hardware open drain output
support (some GPIO controllers will do all this in hardware) if the
driver API were extended.  Grant, does that sound reasonable?

--Re2uCLPLNzqOLVJA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPMQ5lAAoJEBus8iNuMP3dhlsP/iDg5BwGat8c0tPgVrtanVCt
672UQPFcdUBl+mkCkmNbWvD3S+yqZOosIxMEzp1/UMKeicsnTD6lrj+b4EenoU5Z
J0lkixRlpEZJWKd2RBo1AcoCyvdhYwICPmH9wJS6z+WPE7T2CqNbcoaRj0+p81sE
zsPlnw+VxgKkCEaWA1wtpyNv05sLFvzfajI1QQbn0MCz9Ap0ZoNcZCDXLbDlrQou
EYNAe2xFNBZFiUSn/pPIomIfUJMO9KjqMTyXYMcOp+oth38nK7y6mbgUStOpcs3e
z4uTqrbey38SnFO4QZaINOcAahwkz6DEIN9PkURAOYWDB0hEIl/REo09moN++5sn
WNKdouDBbW14N5dWjMBCPKou5DHmLjwvy5GZURDL4Yw0y0n7MM6mxHlLP508+NQO
Dnuo9qWtS444z5RXvqvJRxgBVe5MwTlo6mboAEIxg2zn8aYq36DN5eFGAWRINpsT
YfDs5DcoczjSZH5so8pfTq8K7NQaW8vc7YEXJ36OmHGbeOYhiqgcG1nDyiNug1dw
3OQehci3jBCVHwvj37ydUSaATYdhsqMwQxgxdPG9AZDXHCcb0s3FQDwywvB+maQl
3pG26aybSJ1DVmer67ei3X4hS/FbT7vMaE75x2jQzTFRu+PVDe/tRig2hkQPPphJ
TdcsU9T3w/ndrs/yiVqc
=eakE
-----END PGP SIGNATURE-----

--Re2uCLPLNzqOLVJA--
