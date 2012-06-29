Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755809Ab2F2BZL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 21:25:11 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54776 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754608Ab2F2BZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 21:25:10 -0400
Date: Fri, 29 Jun 2012 02:25:08 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] regulator: fixed: support deferred probe for DT GPIOs
Message-ID: <20120629012507.GL28922@opensource.wolfsonmicro.com>
References: <1340922692-24092-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tv2SIFopg1r47n4a"
Content-Disposition: inline
In-Reply-To: <1340922692-24092-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tv2SIFopg1r47n4a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 28, 2012 at 04:31:32PM -0600, Stephen Warren wrote:

>  static struct fixed_voltage_config *
> -of_get_fixed_voltage_config(struct device *dev)
> +of_get_fixed_voltage_config(struct device *dev, bool *defer_probe)

This is pretty contorted, we should just be able to pass the return
value back more directly and of course ideally gpiolib would be doing
the -EPROBE_DEFER for us anyway (I did send a patch for this, Grant
didn't apply it due to a mostly unrelated issue in the current probe
deferral implementation).  Or just defer if we don't get a config passed
back or something.

--tv2SIFopg1r47n4a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP7QPsAAoJEBus8iNuMP3d6i8P/iRVL1B4U4Y+THpKhtgdcEA5
+UI7tJkfdurMTVQLoz5VF18/JiIeBTf9GQgffqZXnzQKD+i/ukWDUmZwCI6+Fqpl
XRT5kdHnE7d6dQbLME2wOrKTFdimnLHizzeHofYW1uTopBhZzojqBRsWAIXD4q+P
F//Em2Fq9NHLFlexp3Z2a0nqgWLmpWmmQyVW/xy/v6lrINS27kM49NENvTkA1nxS
yOALoSCSnEPfNv8WHV5fBVnFRdIqiI7KdfL4GDtazKUR+QcqFVJTG7/zrZm6uZKF
NS5fVktEtAhqMLCdBP1bLyRAGIMPz7X4e1mnBOF7OrALgLQXuln4YazRNoSaNPdm
ovQd8KoeaHsSgfmtrhOkAeqosBGWZGv9P97EG1j0TSUOWEKHYGWVoWcA/wOfx9iQ
bC36ZMEbw3hSULOZ0e3C8KqjVdDzpDTBYh9xzqa5RRKz9K3vA/cu/fDormgx5UVT
7F2wQ7+dn4e5tp+2GGj7L1dcKHuGfAD2uiK8kww84tDVCr1cp16gDuPOUCCSu8pa
rrzjOlh+CpszkTpFqu/KtRSKdLHlHw6jWvT6feNjE5jxVdUX2YvOI7+dWNYFSql8
/hNURDq/Fu3nKgNX/+IkpdjJRBZztuc3fZblqh+gpbTBW8ogtOJsQsxv0TaLuACQ
V3naP0P23TCvSjdfRdtz
=Wn0q
-----END PGP SIGNATURE-----

--tv2SIFopg1r47n4a--
