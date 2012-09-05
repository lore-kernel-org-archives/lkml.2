Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab2IEHAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 03:00:18 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:61712 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957Ab2IEHAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 03:00:16 -0400
MIME-Version: 1.0
Date: Wed, 5 Sep 2012 15:00:15 +0800
Message-ID: <CAPgLHd8KyjsepcaW4zffjQG4ma4sdzmTa6wafwWh55La7qWzMQ@mail.gmail.com>
Subject: [PATCH] ALSA: use list_move_tail instead of list_del/list_add_tail
From: Wei Yongjun <weiyj.lk@gmail.com>
To: perex@perex.cz, tiwai@suse.de
Cc: yongjun_wei@trendmicro.com.cn, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Using list_move_tail() instead of list_del() + list_add_tail().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 sound/pci/emu10k1/memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/emu10k1/memory.c b/sound/pci/emu10k1/memory.c
index 0a43662..1dce0a39 100644
--- a/sound/pci/emu10k1/memory.c
+++ b/sound/pci/emu10k1/memory.c
@@ -263,8 +263,8 @@ int snd_emu10k1_memblk_map(struct snd_emu10k1 *emu, struct snd_emu10k1_memblk *b
 	spin_lock_irqsave(&emu->memblk_lock, flags);
 	if (blk->mapped_page >= 0) {
 		/* update order link */
-		list_del(&blk->mapped_order_link);
-		list_add_tail(&blk->mapped_order_link, &emu->mapped_order_link_head);
+		list_move_tail(&blk->mapped_order_link,
+			       &emu->mapped_order_link_head);
 		spin_unlock_irqrestore(&emu->memblk_lock, flags);
 		return 0;
 	}


