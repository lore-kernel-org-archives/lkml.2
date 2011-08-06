Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab1HFL04 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 07:26:56 -0400
Received: from www17.your-server.de ([213.133.104.17]:34627 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755898Ab1HFL0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 07:26:52 -0400
Subject: [PATCH] ALSA: asihpi - use kzalloc()
From: Thomas Meyer <thomas@m3y3r.de>
To: Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Date: Sat, 06 Aug 2011 13:26:20 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1312629983.5589.129.camel@localhost.localdomain>
Mime-Version: 1.0
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thomas Meyer <thomas@m3y3r.de>


 Use kzalloc rather than kmalloc followed by memset with 0

 This considers some simple cases that are common and easy to validate
 Note in particular that there are no ...s in the rule, so all of the
 matched code has to be contiguous

 The semantic patch that makes this output is available
 in scripts/coccinelle/api/alloc/kzalloc-simple.cocci.

 More information about semantic patching is available at
 http://coccinelle.lip6.fr/

Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/sound/pci/asihpi/hpicmn.c b/sound/pci/asihpi/hpicmn.c
--- a/sound/pci/asihpi/hpicmn.c 2011-07-26 00:46:12.970154018 +0200
+++ b/sound/pci/asihpi/hpicmn.c 2011-08-01 20:42:34.859285236 +0200
@@ -631,13 +631,12 @@ struct hpi_control_cache *hpi_alloc_cont
 	if (!p_cache)
 		return NULL;
 
-	p_cache->p_info =
-		kmalloc(sizeof(*p_cache->p_info) * control_count, GFP_KERNEL);
+	p_cache->p_info = kzalloc(sizeof(*p_cache->p_info) * control_count,
+				  GFP_KERNEL);
 	if (!p_cache->p_info) {
 		kfree(p_cache);
 		return NULL;
 	}
-	memset(p_cache->p_info, 0, sizeof(*p_cache->p_info) * control_count);
 	p_cache->cache_size_in_bytes = size_in_bytes;
 	p_cache->control_count = control_count;
 	p_cache->p_cache = p_dsp_control_buffer;



