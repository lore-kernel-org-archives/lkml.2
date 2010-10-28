Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759167Ab0J1Pcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 11:32:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:63317 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932582Ab0J1PcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 11:32:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=p7+eDd58vWgoADgPBtY1ZUY0EeZQrgr/QsXGJhwHKQXcME699saBD8hWU+vrOmithj
         nXai30CIta+q9rO9IgpckmBP9D4AieJCpFx0ED9eRM8v5ovO8UsMI/lDsiRHRKqcB4wK
         b8YmpKIYUUv5J+DkYVjhnIocXV1UoTzNl5nPg=
From: Michal Nazarewicz <mina86@mina86.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>
Subject: [PATCHv2 5/7] USB: gadget: f_mass_storage: remove needless complete()
Date: Thu, 28 Oct 2010 17:31:22 +0200
Message-Id: <b760fc04ef78cbcb8d04fab164d993d194aa6646.1288256118.git.mina86@mina86.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <bfcc3341c937589451942f87d944659faf6c9e3c.1288256118.git.mina86@mina86.com>
References: <bfcc3341c937589451942f87d944659faf6c9e3c.1288256118.git.mina86@mina86.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit removes call to the complete() function done in
fsg_unbind() which was never needed there but was a leftover
form file_storage.c.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
---
 drivers/usb/gadget/f_mass_storage.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/f_mass_storage.c b/drivers/usb/gadget/f_mass_storage.c
index c71f69f..365f1b3 100644
--- a/drivers/usb/gadget/f_mass_storage.c
+++ b/drivers/usb/gadget/f_mass_storage.c
@@ -2657,7 +2657,7 @@ static int fsg_main_thread(void *common_)
 		up_write(&common->filesem);
 	}
 
-	/* Let the unbind and cleanup routines know the thread has exited */
+	/* Let fsg_unbind() know the thread has exited */
 	complete_and_exit(&common->thread_notifier, 0);
 }
 
@@ -2906,9 +2906,6 @@ static void fsg_common_release(struct kref *ref)
 	if (common->state != FSG_STATE_TERMINATED) {
 		raise_exception(common, FSG_STATE_EXIT);
 		wait_for_completion(&common->thread_notifier);
-
-		/* The cleanup routine waits for this completion also */
-		complete(&common->thread_notifier);
 	}
 
 	if (likely(common->luns)) {
-- 
1.7.1

