Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab0JVHMn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 03:12:43 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:50815 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab0JVHMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 03:12:42 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Greg KH <greg@kroah.com>
Cc: Martyn Welch <martyn.welch@ge.com>, LKML <linux-kernel@vger.kernel.org>,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>
Subject: [PATCH 15/30] staging/vme_user: remove __iomem marking from kern_buf and derivates
Date: Fri, 22 Oct 2010 02:36:37 -0400
Message-Id: <1287729412-24356-16-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1287729412-24356-1-git-send-email-cota@braap.org>
References: <1287729412-24356-1-git-send-email-cota@braap.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

kern_buf is not iomem; it comes from kmalloc and is directly
dereferenced.

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/staging/vme/devices/vme_user.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index e7669a4..ead30d2 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -92,7 +92,7 @@ static unsigned int bus_num;
  * Structure to handle image related parameters.
  */
 typedef struct {
-	void __iomem *kern_buf;	/* Buffer address in kernel space */
+	void *kern_buf;	/* Buffer address in kernel space */
 	dma_addr_t pci_buf;	/* Buffer address in PCI address space */
 	unsigned long long size_buf;	/* Buffer size */
 	struct semaphore sem;	/* Semaphore for locking image */
@@ -277,7 +277,7 @@ static ssize_t resource_from_user(unsigned int minor, const char *buf,
 static ssize_t buffer_to_user(unsigned int minor, char __user *buf,
 	size_t count, loff_t *ppos)
 {
-	void __iomem *image_ptr;
+	void *image_ptr;
 	ssize_t retval;
 
 	image_ptr = image[minor].kern_buf + *ppos;
@@ -296,7 +296,7 @@ static ssize_t buffer_to_user(unsigned int minor, char __user *buf,
 static ssize_t buffer_from_user(unsigned int minor, const char *buf,
 	size_t count, loff_t *ppos)
 {
-	void __iomem *image_ptr;
+	void *image_ptr;
 	size_t retval;
 
 	image_ptr = image[minor].kern_buf + *ppos;
-- 
1.7.1

