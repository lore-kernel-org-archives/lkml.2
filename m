Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989Ab2HXCVN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 22:21:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55768 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932906Ab2HXCUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 22:20:10 -0400
Date: Fri, 24 Aug 2012 12:20:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Ben Widawsky <ben@bwidawsk.net>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20120824122007.462686709d2a7fdb8126b375@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__24_Aug_2012_12_20_07_+1000_ov+a63Fe4iUmIcja"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Aug_2012_12_20_07_+1000_ov+a63Fe4iUmIcja
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/i915/i915_gem.c between commit b6c7488df68a
("drm/i915/contexts: fix list corruption") from Linus' tree and commit
69c2fc891343 ("drm/i915: Remove the per-ring write list") from the drm
tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/i915/i915_gem.c
index 489e2b1,0514593..0000000
--- a/drivers/gpu/drm/i915/i915_gem.c
+++ b/drivers/gpu/drm/i915/i915_gem.c
@@@ -2369,13 -2277,9 +2277,9 @@@ int i915_gpu_idle(struct drm_device *de
  		if (ret)
  			return ret;
 =20
 -		ret =3D i915_switch_context(ring, NULL, DEFAULT_CONTEXT_ID);
 +		ret =3D i915_ring_idle(ring);
  		if (ret)
  			return ret;
-=20
- 		/* Is the device fubar? */
- 		if (WARN_ON(!list_empty(&ring->gpu_write_list)))
- 			return -EBUSY;
  	}
 =20
  	return 0;

--Signature=_Fri__24_Aug_2012_12_20_07_+1000_ov+a63Fe4iUmIcja
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQNuTXAAoJEECxmPOUX5FEMSwQAJfsHlfq9LPf5CpqkZH2m+CI
zQPBjcSCDm3vT/mK11bYVCjBZzuW/r8znf+RQ8cCKf9nVKQ93ZYQr12ngyvsPo7+
Bwgr2+Nv3X8UE3+m2BZulrdedx4z5ZN+TM2K1X6tt17MV4MAd52gZFPFoo3P1tvG
mhcpYggx7SyE1Z9KZizc1eU4OFNALcKJnGlBYQWEpMubzWMJahEFPdMbMGtQ5Ibg
J4U80Gk1l8XlxuIE0Nwy1sOgs/yukBIFvZnJbLgLT7YqiIXbDM/XiLDAyOor1Ff0
+8aViB5S3bgvUSpLRcXYHohbTazqLFcOFQPDjXLP6uko8TzsWPJyr/AxfMb7gFsJ
PrKobiCr39v6qzQ3kU6LFjF9pmaojE2qf6ddsM3vH03P4aO3wTMvnKf7gjBNXF2y
+gWyDr/hhYd5xrvJy7UDlV+4B89QY2EBK5oTaVxVuOETroBGW5BGV1/GDxvsDFW/
sUJmcCCJzobIn6Z7GepUQPe8UFUBEptv3OcsRK5CZ5dL82xcjfAgTKk5WERbBRmG
/IwrrCaAoY8wegWLZ/i83Yqtq7D+MCdxIPl1OzeDQvzKcqmq/MHHT/CRM14hVv/L
Nv+AVFAgB57m5m5/9Oz5069EvbN78W0SH1gY1jFCBXe38qDNpIB+HpXrqV7Cu5SY
0D50MLj4/hc9MZAiGBLd
=b46U
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Aug_2012_12_20_07_+1000_ov+a63Fe4iUmIcja--
