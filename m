Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab1GKOih (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 10:38:37 -0400
Received: from anchor-post-1.mail.demon.net ([195.173.77.132]:51237 "EHLO
	anchor-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754868Ab1GKOig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 10:38:36 -0400
Subject: lib: reorder prop_local_percpu to remove 64 bit alignment padding
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jens Axboe <jaxboe@fusionio.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Date: Mon, 11 Jul 2011 15:38:34 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1310395114.3058.16.camel@castor.rsk>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder prop_local_percpu to remove 8 bytes of alignment padding in 64
bit builds, and therefore shrink backing_dev_info & request_queue by 8
bytes.
    
    
Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

---
patch against v3.0-rc6
compiled & tested on x86_64

I'm not entirely sure which tree this should go through but as it
indirectly removes padding from request_queue I guessed Jens tree?

get_maintainers doesn't know either, it thinks I should send it to
myself :) 


regards
Richard

diff --git a/include/linux/proportions.h b/include/linux/proportions.h
index cf793bb..9168cb0 100644
--- a/include/linux/proportions.h
+++ b/include/linux/proportions.h
@@ -56,8 +56,8 @@ struct prop_local_percpu {
 	/*
 	 * snapshot of the last seen global state
 	 */
-	int shift;
 	unsigned long period;
+	int shift;
 	spinlock_t lock;		/* protect the snapshot state */
 };
 


