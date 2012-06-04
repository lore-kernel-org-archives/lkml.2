Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759631Ab2FDK1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 06:27:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42048 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751894Ab2FDK1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 06:27:50 -0400
Date: Mon, 4 Jun 2012 11:27:48 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sagar Dharia <sdharia@codeaurora.org>
Cc: davidb@codeaurora.org, bryanh@codeaurora.org, kheitke@codeaurora.org,
        gclemson@audience.com, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, rob@landley.net,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, ohad@wizery.com,
        gregkh@linuxfoundation.org, linus.walleij@linaro.org,
        rusty@rustcorp.com.au, joerg.roedel@amd.com, trenn@suse.de,
        ak@linux.intel.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] slimbus: Linux driver framework for SLIMbus.
Message-ID: <20120604102747.GC7538@opensource.wolfsonmicro.com>
References: <1338340310-4473-1-git-send-email-sdharia@codeaurora.org>
 <20120601001617.GA16311@plastictigers.com>
 <74993ac9d11db0db7080c0864daef397.squirrel@www.codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ncSAzJYg3Aa9+CRW"
Content-Disposition: inline
In-Reply-To: <74993ac9d11db0db7080c0864daef397.squirrel@www.codeaurora.org>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ncSAzJYg3Aa9+CRW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 04, 2012 at 03:21:06AM -0700, Sagar Dharia wrote:

> > b) Similarly to (a) the driver may be probed before the device has
> > been given a logical address (LA). This makes sense in the case of
> > driver that turns on the device (say via gpio) once the bus has
> > booted. However, the driver then needs to sit and poll
> > slim_get_logical_addr() until the logical address.

> This is not the case anymore.
> While taking care of the comments for RFC, I have introduced a completion
> that will be signalled when LA is given to the device. The driver can wait
> on that completion (wait_enum) instead of polling.

This would mean that the thread the probe is happening in will be
blocked until the LA is assigned.  That sounds like it might cause
problems, either slowing things down or worst case causing a deadlock.

--ncSAzJYg3Aa9+CRW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPzI2dAAoJEBus8iNuMP3dFKUP/jOFQ2VjmHjXbBkJmUfa3hwk
7k/+V2BIvTOK78RXl1IGEnu0obEsZk4pczN4mjhUorVWDEyE5Us4sle2wu9eW51R
9UP+XxN1h1U8jc+mHoQNAcTpgadsyFDNd+QRREcJy+Hix7P8ng7J/FEnqc/HqTiF
F8BvwWjQXtENSGM7K3Jknf0V2n3mEm3oqVhy53S1yEMGWovL8xWs1QGTJOoCQsxT
SRHcLHLd35G+RixDZ8PvX6y1xqwmuFyxJUanZkBF3eBN0dvuks5j0CFNyMPYGiDx
APZIbA1Ge7FEbouiefMwghJMl4oGMLXdNRAiDoCXBtoc+oIF6HgKLHCjbBcKScNY
C1liovqzXi0npUrGgevs+I7T2YzWzAvadLnAMwc7cOUTYxyEtEmvNYJj4hTKOqda
bPgorI/c1R626g+Td6kRMyeME540evzyb+R4T4M/OurdRmOoCIKy9AZWjCf7sv+J
2/l3eEOBRGEZcYcAhHanOeebsQ11GLx2fruif1rReiW9zoorWR8QOk45T9x/q/Yz
AUiclJrvVSm9U3uRd7VlvIlB4Zu5pHKFz2zAIdb7i4Y8KgtxbjEpL2iQLGoxf6Mg
1AFb7NyMnwADRlRUhbVphTWeIPYG+OOB9X35GyK1IewCPdUeQUhpp5FHDSA+jHaT
oh2IXB5b/c5zk09i1VQ/
=FUhz
-----END PGP SIGNATURE-----

--ncSAzJYg3Aa9+CRW--
