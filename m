Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932192Ab1CIDl3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 22:41:29 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46249 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932117Ab1CIDl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 22:41:27 -0500
Date: Wed, 9 Mar 2011 14:41:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>
Subject: linux-next: manual merge of the drm tree with Linus' tree
Message-Id: <20110309144123.bb46f902.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Today's linux-next merge of the drm tree got a conflict in
drivers/gpu/drm/nouveau/nouveau_mem.c between commit
ef1b287169cd3d1e428c8ed8222e0bbf733d5dbb ("drm/nouveau: fix regression
causing ttm to not be able to evict vram") from Linus' tree and commit
8f7286f8e4e80f7b868ba3d117ae900f0d207cbe ("drm/nv50: support for
compression") from the drm tree.

Just context changes.  I fixed it up (see below) and can carry the fix as
necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/gpu/drm/nouveau/nouveau_mem.c
index b0fb9bd,63b9040..0000000
--- a/drivers/gpu/drm/nouveau/nouveau_mem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_mem.c
@@@ -724,11 -740,9 +740,11 @@@ nouveau_vram_manager_new(struct ttm_mem
  
  	ret = vram->get(dev, mem->num_pages << PAGE_SHIFT,
  			mem->page_alignment << PAGE_SHIFT, size_nc,
- 			(nvbo->tile_flags >> 8) & 0xff, &node);
+ 			(nvbo->tile_flags >> 8) & 0x3ff, &node);
 -	if (ret)
 -		return ret;
 +	if (ret) {
 +		mem->mm_node = NULL;
 +		return (ret == -ENOSPC) ? 0 : ret;
 +	}
  
  	node->page_shift = 12;
  	if (nvbo->vma.node)
