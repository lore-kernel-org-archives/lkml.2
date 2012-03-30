Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936052Ab2C3VZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:25:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966269Ab2C3VWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:22:55 -0400
Message-Id: <20120330194849.018491364@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Steffen Persvold <sp@numascale.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: [ 116/175] iommu/amd: Fix section warning for prealloc_protection_domains
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steffen Persvold <sp@numascale.com>

commit cebd5fa4d3046d5b43ce1836a0120612822a7fb0 upstream.

Fix the following section warning in drivers/iommu/amd_iommu.c :

WARNING: vmlinux.o(.text+0x526e77): Section mismatch in reference from the function prealloc_protection_domains() to the function .init.text:alloc_passthrough_domain()
The function prealloc_protection_domains() references
the function __init alloc_passthrough_domain().
This is often because prealloc_protection_domains lacks a __init
annotation or the annotation of alloc_passthrough_domain is wrong.

Signed-off-by: Steffen Persvold <sp@numascale.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/amd_iommu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -2804,7 +2804,7 @@ static int amd_iommu_dma_supported(struc
  * we don't need to preallocate the protection domains anymore.
  * For now we have to.
  */
-static void prealloc_protection_domains(void)
+static void __init prealloc_protection_domains(void)
 {
 	struct iommu_dev_data *dev_data;
 	struct dma_ops_domain *dma_dom;


