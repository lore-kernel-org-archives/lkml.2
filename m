Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415Ab2CENxQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 08:53:16 -0500
Received: from mail.pripojeni.net ([178.22.112.14]:34611 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246Ab2CENxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 08:53:07 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 13/68] TTY: serialP, remove DECLARE_WAITQUEUE check
Date: Mon,  5 Mar 2012 14:52:00 +0100
Message-Id: <1330955575-26641-14-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro is always defined now. This was there only for historical
reasons.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 include/linux/serialP.h |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/linux/serialP.h b/include/linux/serialP.h
index e811a61..ec27b34 100644
--- a/include/linux/serialP.h
+++ b/include/linux/serialP.h
@@ -79,15 +79,9 @@ struct async_struct {
 	int			io_type;
 	struct work_struct			work;
 	struct tasklet_struct	tlet;
-#ifdef DECLARE_WAITQUEUE
 	wait_queue_head_t	open_wait;
 	wait_queue_head_t	close_wait;
 	wait_queue_head_t	delta_msr_wait;
-#else	
-	struct wait_queue	*open_wait;
-	struct wait_queue	*close_wait;
-	struct wait_queue	*delta_msr_wait;
-#endif	
 	struct async_struct	*next_port; /* For the linked list */
 	struct async_struct	*prev_port;
 };
-- 
1.7.9.2


