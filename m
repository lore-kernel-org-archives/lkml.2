Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab1EDQx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:53:29 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50685 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab1EDQx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:53:28 -0400
Date: Wed, 4 May 2011 09:53:10 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -next] sound: fix lola build
Message-Id: <20110504095310.465fae53.randy.dunlap@oracle.com>
In-Reply-To: <20110504144759.802483cc.sfr@canb.auug.org.au>
References: <20110504144759.802483cc.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090203.4DC18482.00AE:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

sound/pci/lola/Makefile was trying to build lola modules even
when PCI and SND_LOLA were not enabled, causing build errors:

ERROR: "snd_pcm_hw_constraint_step" [sound/pci/lola/snd-lola.ko] undefined!
ERROR: "snd_pcm_period_elapsed" [sound/pci/lola/snd-lola.ko] undefined!
ERROR: "snd_dma_alloc_pages" [sound/pci/lola/snd-lola.ko] undefined!
ERROR: "snd_pcm_hw_constraint_integer" [sound/pci/lola/snd-lola.ko] undefined!
ERROR: "snd_pcm_sgbuf_ops_page" [sound/pci/lola/snd-lola.ko] undefined!
ERROR: "snd_pcm_set_ops" [sound/pci/lola/snd-lola.ko] undefined!
ERROR: "snd_pcm_lib_free_pages" [sound/pci/lola/snd-lola.ko] undefined!
ERROR: "snd_pcm_lib_ioctl" [sound/pci/lola/snd-lola.ko] undefined!
ERROR: "snd_pcm_lib_malloc_pages" [sound/pci/lola/snd-lola.ko] undefined!
ERROR: "snd_pcm_sgbuf_get_chunk_size" [sound/pci/lola/snd-lola.ko] undefined!
ERROR: "snd_dma_free_pages" [sound/pci/lola/snd-lola.ko] undefined!
ERROR: "snd_pcm_lib_preallocate_pages_for_all" [sound/pci/lola/snd-lola.ko] undefined!
ERROR: "snd_pcm_new" [sound/pci/lola/snd-lola.ko] undefined!

Fix the Makefile to build only when CONFIG_SND_LOLA is enabled.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 sound/pci/lola/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20110504.orig/sound/pci/lola/Makefile
+++ linux-next-20110504/sound/pci/lola/Makefile
@@ -1,3 +1,4 @@
 snd-lola-y := lola.o lola_pcm.o lola_clock.o lola_mixer.o
 snd-lola-$(CONFIG_SND_DEBUG) += lola_proc.o
-obj-m = snd-lola.o
+
+obj-$(CONFIG_SND_LOLA) += snd-lola.o
