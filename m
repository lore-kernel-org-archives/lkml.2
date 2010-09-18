Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab0IRTBv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:01:51 -0400
Received: from kroah.org ([198.145.64.141]:51132 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab0IRTBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:16 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:53 2010
Message-Id: <20100918185953.836249689@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:57:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: [012/123] staging: hv: Fixed bounce kmap problem by using correct index
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=staging-hv-fixed-bounce-kmap-problem-by-using-correct-index.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hank Janssen <hjanssen@microsoft.com>

commit 0c47a70a9a8a6d1ec37a53d2f9cb82f8b8ef8aa2 upstream.

Fixed bounce offset kmap problem by using correct index.
The symptom of the problem is that in some NAS appliances this problem
represents Itself by a unresponsive VM under a load with many clients writing
small files.

Signed-off-by:Hank Janssen <hjanssen@microsoft.com>
Signed-off-by:Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/hv/storvsc_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/hv/storvsc_drv.c
+++ b/drivers/staging/hv/storvsc_drv.c
@@ -532,7 +532,7 @@ static unsigned int copy_to_bounce_buffe
 
 		ASSERT(orig_sgl[i].offset + orig_sgl[i].length <= PAGE_SIZE);
 
-		if (j == 0)
+		if (bounce_addr == 0)
 			bounce_addr = (unsigned long)kmap_atomic(sg_page((&bounce_sgl[j])), KM_IRQ0);
 
 		while (srclen) {
@@ -593,7 +593,7 @@ static unsigned int copy_from_bounce_buf
 		destlen = orig_sgl[i].length;
 		ASSERT(orig_sgl[i].offset + orig_sgl[i].length <= PAGE_SIZE);
 
-		if (j == 0)
+		if (bounce_addr == 0)
 			bounce_addr = (unsigned long)kmap_atomic(sg_page((&bounce_sgl[j])), KM_IRQ0);
 
 		while (destlen) {


