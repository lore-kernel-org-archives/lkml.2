Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673Ab0KEDIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:08:50 -0400
Received: from mail.perches.com ([173.55.12.10]:4086 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753608Ab0KEDIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:08:46 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 15/49] drivers/media: Use vzalloc
Date: Thu,  4 Nov 2010 20:07:39 -0700
Message-Id: <7a20349981a13968f186ffe92705abfa3cff7df0.1288925424.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/media/dvb/ngene/ngene-core.c  |    3 +--
 drivers/media/video/mx3_camera.c      |    3 +--
 drivers/media/video/pwc/pwc-if.c      |    3 +--
 drivers/media/video/videobuf-dma-sg.c |    3 +--
 4 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/media/dvb/ngene/ngene-core.c b/drivers/media/dvb/ngene/ngene-core.c
index 4caeb16..1abc3a0 100644
--- a/drivers/media/dvb/ngene/ngene-core.c
+++ b/drivers/media/dvb/ngene/ngene-core.c
@@ -1537,12 +1537,11 @@ int __devinit ngene_probe(struct pci_dev *pci_dev,
 	if (pci_enable_device(pci_dev) < 0)
 		return -ENODEV;
 
-	dev = vmalloc(sizeof(struct ngene));
+	dev = vzalloc(sizeof(struct ngene));
 	if (dev == NULL) {
 		stat = -ENOMEM;
 		goto fail0;
 	}
-	memset(dev, 0, sizeof(struct ngene));
 
 	dev->pci_dev = pci_dev;
 	dev->card_info = (struct ngene_info *)id->driver_data;
diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
index 29c5fc3..321c3e5 100644
--- a/drivers/media/video/mx3_camera.c
+++ b/drivers/media/video/mx3_camera.c
@@ -1182,13 +1182,12 @@ static int __devinit mx3_camera_probe(struct platform_device *pdev)
 		goto egetres;
 	}
 
-	mx3_cam = vmalloc(sizeof(*mx3_cam));
+	mx3_cam = vzalloc(sizeof(*mx3_cam));
 	if (!mx3_cam) {
 		dev_err(&pdev->dev, "Could not allocate mx3 camera object\n");
 		err = -ENOMEM;
 		goto ealloc;
 	}
-	memset(mx3_cam, 0, sizeof(*mx3_cam));
 
 	mx3_cam->clk = clk_get(&pdev->dev, NULL);
 	if (IS_ERR(mx3_cam->clk)) {
diff --git a/drivers/media/video/pwc/pwc-if.c b/drivers/media/video/pwc/pwc-if.c
index e62beb4..fc5f02e 100644
--- a/drivers/media/video/pwc/pwc-if.c
+++ b/drivers/media/video/pwc/pwc-if.c
@@ -288,14 +288,13 @@ static int pwc_allocate_buffers(struct pwc_device *pdev)
 	/* create frame buffers, and make circular ring */
 	for (i = 0; i < default_fbufs; i++) {
 		if (pdev->fbuf[i].data == NULL) {
-			kbuf = vmalloc(PWC_FRAME_SIZE); /* need vmalloc since frame buffer > 128K */
+			kbuf = vzalloc(PWC_FRAME_SIZE); /* need vmalloc since frame buffer > 128K */
 			if (kbuf == NULL) {
 				PWC_ERROR("Failed to allocate frame buffer %d.\n", i);
 				return -ENOMEM;
 			}
 			PWC_DEBUG_MEMORY("Allocated frame buffer %d at %p.\n", i, kbuf);
 			pdev->fbuf[i].data = kbuf;
-			memset(kbuf, 0, PWC_FRAME_SIZE);
 		}
 	}
 
diff --git a/drivers/media/video/videobuf-dma-sg.c b/drivers/media/video/videobuf-dma-sg.c
index 20f227e..ab684e8 100644
--- a/drivers/media/video/videobuf-dma-sg.c
+++ b/drivers/media/video/videobuf-dma-sg.c
@@ -69,10 +69,9 @@ static struct scatterlist *videobuf_vmalloc_to_sg(unsigned char *virt,
 	struct page *pg;
 	int i;
 
-	sglist = vmalloc(nr_pages * sizeof(*sglist));
+	sglist = vzalloc(nr_pages * sizeof(*sglist));
 	if (NULL == sglist)
 		return NULL;
-	memset(sglist, 0, nr_pages * sizeof(*sglist));
 	sg_init_table(sglist, nr_pages);
 	for (i = 0; i < nr_pages; i++, virt += PAGE_SIZE) {
 		pg = vmalloc_to_page(virt);
-- 
1.7.3.1.g432b3.dirty

