Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab2EWXQr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 19:16:47 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54370 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751734Ab2EWXQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 19:16:46 -0400
Date: Thu, 24 May 2012 00:16:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH 1/2] regmap: allow busses to request formatting with
 specific endianness
Message-ID: <20120523231641.GA5361@opensource.wolfsonmicro.com>
References: <1337812434-7609-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MGYHOYXEY6WxJCY8"
Content-Disposition: inline
In-Reply-To: <1337812434-7609-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MGYHOYXEY6WxJCY8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 23, 2012 at 04:33:53PM -0600, Stephen Warren wrote:

> I'm not 100% sure if this is the approach you had in mind. However, anything
> more all-encompassing would require separating the concepts of endianness and

I wouldn't do this on the bus in the first instance, I'd do it on the
device - it's pretty much orthogonal to the bus what the device wants
and it's perfectly plausible that a device on another bus might've made
unusual endiannness choices.  Otherwise it's pretty much what I was
thinking of.

For MMIO I'd expect that a large proportion of devices on platform buses
would pick native endianness.

> serialization that are coupled together in functions like
> regmap_format_4_12_write, and I'm not sure how that would work conceptually.

Anything using format_write() can be ignored, it's already lost large
chunks of functionality just from that.  Non-integer byte sizes cause
issues.

--MGYHOYXEY6WxJCY8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPvW/TAAoJEBus8iNuMP3dPmcP/AqvWoceK//vXtziHEfuC2ud
xFTRyDedIICNi97h6lvBGrfDxcJIbIT3LxworLV35Ufaf8KpXw+vTTGLRov9/DBn
efuJ/xcjYrvP74z1IWeF0ioOVQojcnrpw48pooYvmyi07kGRR74/4kpkEJUcbNl1
CmHcBh0WoAK1DuU9XTcGZC0SO12fvHY7hEzHk98nT4HPYLjIEzWlAZ+QXlUWsYxI
ggmQ8xqdzKtWbOWqBuvcmp/jGcwAXjLNkqoBgCp1HcEw/SGj5ctpTXVCIR1RGNbL
6HvDRs9w3aiDMiCWmVL8IF+m9LuhBGw5tU0XD0bOtR9fAfTJFNO352eeyVqHpGkO
Gwc31YKS3Ydp/wWRyf1+FkTREB8d7weTnp8kDnSf7BieAC/ubNFlnFL4rXa9fK8k
iReft77utULfA0MFclg1Y/lqa/EUpF12d5WWj/DPzppCQ0j95GbzPLI5GF9Icd4c
NbVpdnCelKltBpgvaK86itt8TpQ9qVhykIiBAjDUQsvUpL1lr71uKOZAiZG/Q5p/
ufhOT+26BdpsZxddFPmUCD9UFmJCpl/JZkSqE53CX1W1MEiMrjrQPdTY0INYxhih
zpPHrBVn/C7iV4+flUCP1SMB4A1Q0RjIfqfdfH1JpLgSAPfOwiXCYHRh3z0QB8xw
ogTplIXwvBBTVZPfa1SV
=c2+y
-----END PGP SIGNATURE-----

--MGYHOYXEY6WxJCY8--
