Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479Ab0EMT6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 15:58:46 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50674 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756473Ab0EMT6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 15:58:44 -0400
Date: Thu, 13 May 2010 21:58:37 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 1/20] sound/pci/asihpi: Use kzalloc
Message-ID: <Pine.LNX.4.64.1005132157400.6282@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kzalloc rather than the combination of kmalloc and memset.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,size,flags;
statement S;
@@

-x = kmalloc(size,flags);
+x = kzalloc(size,flags);
 if (x == NULL) S
-memset(x, 0, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 sound/pci/asihpi/hpi6000.c |    3 +--
 sound/pci/asihpi/hpi6205.c |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

diff -u -p a/sound/pci/asihpi/hpi6000.c b/sound/pci/asihpi/hpi6000.c
--- a/sound/pci/asihpi/hpi6000.c
+++ b/sound/pci/asihpi/hpi6000.c
@@ -448,14 +448,13 @@ static void subsys_create_adapter(struct
 	if (phm->u.s.resource.r.pci->device_id != HPI_PCI_DEV_ID_PCI2040)
 		return;
 
-	ao.priv = kmalloc(sizeof(struct hpi_hw_obj), GFP_KERNEL);
+	ao.priv = kzalloc(sizeof(struct hpi_hw_obj), GFP_KERNEL);
 	if (!ao.priv) {
 		HPI_DEBUG_LOG(ERROR, "cant get mem for adapter object\n");
 		phr->error = HPI_ERROR_MEMORY_ALLOC;
 		return;
 	}
 
-	memset(ao.priv, 0, sizeof(struct hpi_hw_obj));
 	/* create the adapter object based on the resource information */
 	/*? memcpy(&ao.Pci,&phm->u.s.Resource.r.Pci,sizeof(ao.Pci)); */
 	ao.pci = *phm->u.s.resource.r.pci;
diff -u -p a/sound/pci/asihpi/hpi6205.c b/sound/pci/asihpi/hpi6205.c
--- a/sound/pci/asihpi/hpi6205.c
+++ b/sound/pci/asihpi/hpi6205.c
@@ -482,13 +482,12 @@ static void subsys_create_adapter(struct
 	if (phm->u.s.resource.r.pci->device_id != HPI_PCI_DEV_ID_DSP6205)
 		return;
 
-	ao.priv = kmalloc(sizeof(struct hpi_hw_obj), GFP_KERNEL);
+	ao.priv = kzalloc(sizeof(struct hpi_hw_obj), GFP_KERNEL);
 	if (!ao.priv) {
 		HPI_DEBUG_LOG(ERROR, "cant get mem for adapter object\n");
 		phr->error = HPI_ERROR_MEMORY_ALLOC;
 		return;
 	}
-	memset(ao.priv, 0, sizeof(struct hpi_hw_obj));
 
 	ao.pci = *phm->u.s.resource.r.pci;
 	err = create_adapter_obj(&ao, &os_error_code);
