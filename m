Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab0KLLPe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 06:15:34 -0500
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:44975 "EHLO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108Ab0KLLP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 06:15:29 -0500
Subject: [PATCH 13/17] staging/vme_user: remove __iomem marking from kern_buf
	and derivates
To: Greg KH <greg@kroah.com>
From: Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        "Emilio G. Cota" <cota@braap.org>, LKML <linux-kernel@vger.kernel.org>,
        Bill Pemberton <wfp5p@virginia.edu>
Date: Fri, 12 Nov 2010 11:15:27 +0000
Message-ID: <20101112111527.11631.27483.stgit@ES-BJ21R4J>
In-Reply-To: <20101112111359.11631.84086.stgit@ES-BJ21R4J>
References: <20101112111359.11631.84086.stgit@ES-BJ21R4J>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

kern_buf is not iomem; it comes from kmalloc and is directly
dereferenced.

Signed-off-by: Emilio G. Cota <cota@braap.org>
Acked-by: Martyn Welch <martyn.welch@ge.com>
---

 drivers/staging/vme/devices/vme_user.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)


diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 7c61adc..5d3a39b 100644
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
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
