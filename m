Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab2FMJaT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 05:30:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51970 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752033Ab2FMJaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 05:30:18 -0400
Date: Wed, 13 Jun 2012 17:30:16 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2] regulator: wm831x-ldo: Convert to
 devm_request_threaded_irq
Message-ID: <20120613093015.GF4545@opensource.wolfsonmicro.com>
References: <1339552767.26190.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2FkSFaIQeDFoAt0B"
Content-Disposition: inline
In-Reply-To: <1339552767.26190.1.camel@phoenix>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2FkSFaIQeDFoAt0B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 13, 2012 at 09:59:27AM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

No, this (and generally a large proportion of possible usages of
devm_request_threaded_irq()) is a bad idea - we need to ensure that the
interrupt cannot fire when we're not in a position to handle it which in
thi case means after the regulator is unregistered.  Since we're not
doing anything to explicitly quiesce the interrupt other than free it we
need to ensure that the free_irq() happens strictly before the regulator
is unregistered.

--2FkSFaIQeDFoAt0B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP2F2hAAoJEBus8iNuMP3d80MP/1N00G4QO2jQChjE/9N/i6G6
uYDqaFomRGipxLvBHZrPe2OoER4xCU7kvwRHkwx1KXSilU4JQQ5cNxd9kO0dWAzl
XJbrWREmDBUAJmWPD4Nbc5gs4GWBKShbrpkl0c5pJmnBLv+sJgrnbfCjCj3DbbZB
Hs/RuXV6+4ZGbPZSFDOskyOwu7R1XtXd4wegKHRhuyHlnfbBJBSvi/E9cQUdKWAQ
pyxbwV1FGsj+c3yIFues/cgzzrVkUKLXu4FocwLAFe2SCG8fC+rNTAqETS8G3Qr/
A9Q33B6R0oW5kUp1ZPPLikqBpepWLqfsoYGzsYlchlQ0nkE4YMgWh59e16SUdi5d
vFVgLGpxhSA2W8jYcNdFH5y1vuvE+nxtjQ1Erk/yac/KSqyjtL4n+i3OCnVl4x2l
Ve11UjJuYhx/WfbXLwOSDvj8d+Rt5d4uxK+QVAoQAhBBQUEYROGfRGTEmv6V6CLc
jPSOQ2Z3muTVU6vscubSQW3se8fd5VHJxhksfrdiesUUaOfURZLZlqZ0eMF5HhKi
LjtRZVk1eEpEy8toEiNu/fgATO0cTkow2Gp8PKBkJF226DNdjV3CqkQVPNQC1aZb
VuJL3DYxPfhgZVHOm3XpMNSai7w0+WtJOl/Ceu9YOyObc0retkzGXygIZybat6Vd
+Pe+5UUlPh6nRy1SKrVW
=Eze7
-----END PGP SIGNATURE-----

--2FkSFaIQeDFoAt0B--
