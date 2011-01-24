Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab1AXPFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 10:05:09 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39168 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943Ab1AXPFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 10:05:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:sender:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=DIg1j26imGexzJqp8/n/n4cUPxGihjyogXZtcIIJQ2EvuQaw9lr6WouoZguTnr4RO1
         WtFiiDhRbM73SH/+tY61nyDXZl9Vbx/UQ2ncayjE8fE1XJ7uzVYqT10jkNuo64tPcRd/
         KOXaXQWwQCFioJku21gTz2Y9Y0rZno96wQD5E=
Date: Mon, 24 Jan 2011 16:05:00 +0100
From: Tejun Heo <tj@kernel.org>
To: Jaya Kumar <jayakumar.lkml@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] fb_defio: don't use flush_scheduled_work()
Message-ID: <20110124150500.GI11404@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

flush_scheduled_work() scheduled for deprecation.  Sync cancel
info->deferred_work directly instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>
---
Resent because email address jayalk@intworks.biz from MAINTAINERS
failed.  Jaya, please update the MAINTAINERS entry.  Thank you.

 drivers/video/fb_defio.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: work/drivers/video/fb_defio.c
===================================================================
--- work.orig/drivers/video/fb_defio.c
+++ work/drivers/video/fb_defio.c
@@ -216,8 +216,7 @@ void fb_deferred_io_cleanup(struct fb_in
 	int i;
 
 	BUG_ON(!fbdefio);
-	cancel_delayed_work(&info->deferred_work);
-	flush_scheduled_work();
+	cancel_delayed_work_sync(&info->deferred_work);
 
 	/* clear out the mapping that we setup */
 	for (i = 0 ; i < info->fix.smem_len; i += PAGE_SIZE) {
