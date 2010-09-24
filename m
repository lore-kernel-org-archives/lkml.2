Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756742Ab0IXQts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:49:48 -0400
Received: from kroah.org ([198.145.64.141]:38428 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932731Ab0IXQ2i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:28:38 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:26:19 2010
Message-Id: <20100924162619.298865689@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:24:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: [51/80] drm/nv50: initialize ramht_refs list for faked 0 channel
In-Reply-To: <20100924162706.GA7381@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Marcin Slusarz <marcin.slusarz@gmail.com>

commit 615661f3948a066fd22a36fe8ea0c528b75ee373 upstream.

We need it for PFIFO_INTR_CACHE_ERROR interrupt handling,
because nouveau_fifo_swmthd looks for matching gpuobj in
ramht_refs list.
It fixes kernel panic in nouveau_gpuobj_ref_find.

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/nouveau/nv50_instmem.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/nouveau/nv50_instmem.c
+++ b/drivers/gpu/drm/nouveau/nv50_instmem.c
@@ -141,6 +141,8 @@ nv50_instmem_init(struct drm_device *dev
 	chan->file_priv = (struct drm_file *)-2;
 	dev_priv->fifos[0] = dev_priv->fifos[127] = chan;
 
+	INIT_LIST_HEAD(&chan->ramht_refs);
+
 	/* Channel's PRAMIN object + heap */
 	ret = nouveau_gpuobj_new_fake(dev, 0, c_offset, c_size, 0,
 							NULL, &chan->ramin);


