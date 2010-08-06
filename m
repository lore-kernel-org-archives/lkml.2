Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965772Ab0HFTyA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 15:54:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:40042 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965730Ab0HFTxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 15:53:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=NDoiXqPAVxkmKi9JxubptZNec65jFzoTyqfnwChiixz8uPspWzgj15q6/IeIWkewed
         xWA8jd60L2x1eBW4jOy5LQVFmtvI0+NoW3gzpP4QEzAcCE143yMNQmxXno9Cd4yb2mb9
         /25batHcgaekiUGvSUhvAAZ7Z/I2GPemSlZJA=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Ben Hutchings <ben@decadent.org.uk>, Joe Perches <joe@perches.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 16/18] staging: sep: call disable_pci_device() if pci_probe() failed
Date: Fri,  6 Aug 2010 23:53:16 +0400
Message-Id: <1281124399-13929-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver should call disable_pci_device() if it returns from pci_probe()
with error.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/sep/sep_driver.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/sep/sep_driver.c b/drivers/staging/sep/sep_driver.c
index ecbde34..d456729 100644
--- a/drivers/staging/sep/sep_driver.c
+++ b/drivers/staging/sep/sep_driver.c
@@ -2614,6 +2614,7 @@ end_function_deallocate_sep_shared_area:
 	sep_unmap_and_free_shared_area(sep, size);
 end_function_error:
 	sep_dev = NULL;
+	pci_disable_device(pdev);
 end_function:
 	return error;
 }
-- 
1.7.0.4

