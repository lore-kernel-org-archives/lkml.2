Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab1B1Gqj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 01:46:39 -0500
Received: from mga14.intel.com ([143.182.124.37]:55485 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab1B1Gqi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 01:46:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,238,1297065600"; 
   d="asc'?scan'208";a="394898176"
Date: Mon, 28 Feb 2011 14:46:35 +0800
From: Zhenyu Wang <zhenyuw@linux.intel.com>
To: Chris Wilson <chris@chris-wilson.co.uk>, Jan Niehusmann <jan@gondor.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [Intel-gfx] [PATCH] intel-gtt: fix memory corruption with
 GM965 and >4GB RAM
Message-ID: <20110228064635.GE428@zhen-devel.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Jan Niehusmann <jan@gondor.com>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <20110223233022.GA3439@x61s.reliablesolutions.de>
 <20110225123056.GA3759@x61s.reliablesolutions.de>
 <b9dded$i2gkhr@orsmga002.jf.intel.com>
 <20110225211646.GA6837@x61s.reliablesolutions.de>
 <b9dded$i2hik6@orsmga002.jf.intel.com>
 <20110225230527.GC3601@viiv.ffwll.ch>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="svZFHVx8/dhPCe52"
Content-Disposition: inline
In-Reply-To: <20110225230527.GC3601@viiv.ffwll.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--svZFHVx8/dhPCe52
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2011.02.26 00:05:27 +0100, Daniel Vetter wrote:
> On Fri, Feb 25, 2011 at 10:18:16PM +0000, Chris Wilson wrote:
> > So, I'm happy to use your patch to workaround the known erratum. I just
> > wish I had an explanation as to what is actually causing the corruption.
> > What I want to make sure is that we don't paper over a real bug by
> > thinking it is yet another silicon issue.
>=20
> Actually, on style points I prefer your patch: The hw status page is
> allocated with drm_pci_alloc which calls dma_alloc_coherent, so setting
> the coherent mask is sufficient. The dma mask set in the gtt is
> essentially useless, because we call get_user_pages on everything anyway
> (in gem - iirc agp uses it). I just think it's confusing to limit the
> general dma mask and continue to happily map pages above 4G.
>=20

Think about IOMMU engine, we need to set dma_mask properly for
returned dma mapping address be limited in max range that can be
handled in GTT entry.=20

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--svZFHVx8/dhPCe52
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAk1rRMsACgkQsQQaM014GCexWwCeL63mjQQy1r4szm2NHRQGCYk6
xWMAnRnQcMfvd0RaoaD5m4xpJgjqrpQq
=1YEA
-----END PGP SIGNATURE-----

--svZFHVx8/dhPCe52--
