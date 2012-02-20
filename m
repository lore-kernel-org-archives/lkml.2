Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab2BTU6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 15:58:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35467 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753329Ab2BTU6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 15:58:03 -0500
Date: Mon, 20 Feb 2012 12:57:57 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Fix and simplify debugfs support
Message-ID: <20120220205756.GA3052@opensource.wolfsonmicro.com>
References: <1329636505-13651-1-git-send-email-sboyd@codeaurora.org>
 <20120220021157.GF3194@opensource.wolfsonmicro.com>
 <4F41FA60.7090503@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RnlQjJ0d97Da+TV1"
Content-Disposition: inline
In-Reply-To: <4F41FA60.7090503@codeaurora.org>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RnlQjJ0d97Da+TV1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Feb 19, 2012 at 11:46:40PM -0800, Stephen Boyd wrote:
> On 2/19/2012 6:12 PM, Mark Brown wrote:

> >This was actually a deliberate decision to make the code more robust
> >against change - the IS_ERR_OR_NULL doesn't make the code any bigger but
> >it means it's less likely to break in the face of changes.

> More robust? The debugfs code in the regulator core looks confused
> on what the return value is. Sometimes it's IS_ERR, sometimes it's
> NULL, sometimes it's both. Might as well clean it up to be
> consistent and proper.

Well, the intention when I originally wrote it was to always check for
all possible error codes.  Looking at the code in mainline it's pretty
consistent, the class wide check and the per rdev checks are both open
coded IS_ERR_OR_NULL() and the per supply stuff uses the helper.  The
only case where we do a plain IS_ERR() is when we warn about not being
able to create supply_map and the consistent thing there would just be
to ignore the error since it's what we do for all the other individual
files.

This thing with returning NULL instead of an actual ERR_PTR() is pretty
unhelpful really, especially for something like debugfs where the caller
shouldn't care much if it works or not.

--RnlQjJ0d97Da+TV1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPQrPJAAoJEBus8iNuMP3dOrIP/2K0cVItI3H5Vx0LoaG3H7Vb
Z46zABaStXJsk5MY76k1bfjZRn3YooRx9uimvLAGDqcLnb5j4SLGh2RU8PSpr/XG
yoQmwNeFsMceVclcvdRlWjkqppTA4hPnVbwGXpUfbZYrUC+ammOByOXrmQZXBUtr
vOTD6Ps7e8DhYLOa1AYdP2KhCrBmGyik77mMnjtQqmMhclpVy7K0ptsV/f4y01B2
5A444fN5bqAhJZY8dGF4EuR/DwOsROIcTZ7pLTqIXLmF8p185HJLPdcZt1DGDLgy
B0Z8oiItof1tvwcc0hL+L7i0ItFlFr7xDOcr6BAfODN3xiVMIxzJXCxLOsHHMej9
xijclpyW8Qibga2AtTnGICcIjMg37i/glrHd3xmvd87QpPuYKsWkxhJk9Esybuef
CpY381+tF0+AX2jtwL5xunFxspRYF0dAKAG2Fz5+x7+9O368XWI+QTGQsz/McYez
GT3tb78GXq9ycP7Efsf5BxEAJxEaiSvXXAfmRoTDRm1K0BC0gyEYntgFDU2Oal7c
y5m3FUjGie2dSv05ycZXy72t6FsoS0LyU/7sx3gabEicuOXv1hLW0vUrQPPsv0wQ
+JWulsmsiCoJm3SQqAZPmbjLEnhmMSPL8jCXMzD+NXKmYK38LDAHanhC9CrzOg+T
nRQAulk0PCVdOjb785n2
=kPTv
-----END PGP SIGNATURE-----

--RnlQjJ0d97Da+TV1--
