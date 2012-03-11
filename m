Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab2CKQi7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 12:38:59 -0400
Received: from mail.vyatta.com ([76.74.103.46]:43736 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab2CKQi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 12:38:58 -0400
Date: Sun, 11 Mar 2012 09:38:53 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] floppy: revert floppy disable halt warning
Message-ID: <20120311093853.04f049c2@s6510.linuxnetplumber.net>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the stupid floppy disable halt warning. It is meaningless since
the API is local to floppy driver.  Our boot scripts check for the
floppy drive, and this causes the warning to trigger every time. This
confuses support, breaks automated tests that look for backtraces on
boot,  and adds no value.  

The message is being displayed to the wrong audience, it looks like it
was intended as a compromise of a long discussion on LKML about
supporting older x86 hardware; but users don't know or understand what
it is saying.

If you want to change halt handling then just fix
the floppy driver, don't whine about it.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/drivers/block/floppy.c	2012-03-11 09:27:52.866459327 -0700
+++ b/drivers/block/floppy.c	2012-03-11 09:28:29.286579201 -0700
@@ -1037,7 +1037,6 @@ static void floppy_disable_hlt(void)
 {
 	unsigned long flags;
 
-	WARN_ONCE(1, "floppy_disable_hlt() scheduled for removal in 2012");
 	spin_lock_irqsave(&floppy_hlt_lock, flags);
 	if (!hlt_disabled) {
 		hlt_disabled = 1;
