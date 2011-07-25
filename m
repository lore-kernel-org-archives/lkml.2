Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665Ab1GYNCm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 09:02:42 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:64103 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab1GYNCh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 09:02:37 -0400
Message-ID: <4E2D6961.9000909@gmail.com>
Date: Mon, 25 Jul 2011 21:02:25 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] jbd: change the field "b_cow_tid" of struct journal_head
 from type unsigned to tid_t
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is against 3.0

In the definition of struct journal_head, the comment for
the field "unsigned b_cow_tid" says the field tracks the
last transaction id in which this buffer has been cowed.

In the header part of file journal-head.h, it defines
   typedef unsigned int  tid_t;
We should use type tid_t to define transaction id fields.

Change the field "b_cow_tid" of struct journal_head from
type unsigned to tid_t.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 include/linux/journal-head.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/journal-head.h b/include/linux/journal-head.h
index 44e95d0..423cb6d 100644
--- a/include/linux/journal-head.h
+++ b/include/linux/journal-head.h
@@ -45,7 +45,7 @@ struct journal_head {
 	 * has been cowed
 	 * [jbd_lock_bh_state()]
 	 */
-	unsigned b_cow_tid;
+	tid_t b_cow_tid;
 
 	/*
 	 * Copy of the buffer data frozen for writing to the log.
-- 
1.7.1

