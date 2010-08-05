Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759048Ab0HET34 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 15:29:56 -0400
Received: from mail1.microsoft.com ([131.107.115.212]:18155 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932107Ab0HET3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 15:29:47 -0400
From: Hank Janssen <hjanssen@microsoft.com>
To: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'devel@driverdev.osuosl.org'" <devel@driverdev.osuosl.org>,
        "'virtualization@lists.osdl.org'" <virtualization@lists.osdl.org>
CC: "'gregkh@suse.de'" <gregkh@suse.de>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [PATCH 1/5] staging: hv: Fixed bounce kmap problem by using correct
 index
Thread-Topic: [PATCH 1/5] staging: hv: Fixed bounce kmap problem by using
 correct index
Thread-Index: Acs00pgoD64hHMxYTeeK8EUNasjiLg==
Date: Thu, 5 Aug 2010 19:29:44 +0000
Message-ID: <8AFC7968D54FB448A30D8F38F259C56223FEC87F@TK5EX14MBXC114.redmond.corp.microsoft.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hank Janssen <hjanssen@microsoft.com> 

Fixed bounce offset kmap problem by using correct index.
The symptom of the problem is that in some NAS appliances this problem
represents Itself by a unresponsive VM under a load with many clients writing
small files.

Signed-off-by:Hank Janssen <hjanssen@microsoft.com>
Signed-off-by:Haiyang Zhang <haiyangz@microsoft.com>
Cc: stable <stable@kernel.org>
---
 drivers/staging/hv/storvsc_drv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/hv/storvsc_drv.c b/drivers/staging/hv/storvsc_drv.c
index 075b61b..3b9ccb0 100644
--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -495,7 +495,7 @@ static unsigned int copy_to_bounce_buffer(struct scatterlist *orig_sgl,
 
 		/* ASSERT(orig_sgl[i].offset + orig_sgl[i].length <= PAGE_SIZE); */
 
-		if (j == 0)
+		if (bounce_addr == 0)
 			bounce_addr = (unsigned long)kmap_atomic(sg_page((&bounce_sgl[j])), KM_IRQ0);
 
 		while (srclen) {
@@ -556,7 +556,7 @@ static unsigned int copy_from_bounce_buffer(struct scatterlist *orig_sgl,
 		destlen = orig_sgl[i].length;
 		/* ASSERT(orig_sgl[i].offset + orig_sgl[i].length <= PAGE_SIZE); */
 
-		if (j == 0)
+		if (bounce_addr == 0)
 			bounce_addr = (unsigned long)kmap_atomic(sg_page((&bounce_sgl[j])), KM_IRQ0);
 
 		while (destlen) {
--
1.6.0.2


