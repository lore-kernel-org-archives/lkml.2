Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602Ab1GITzJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 15:55:09 -0400
Received: from wnohang.net ([178.79.154.173]:34765 "EHLO mail.wnohang.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459Ab1GITzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 15:55:04 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 2F7E2F0004
X-DKIM: Sendmail DKIM Filter v2.8.3 mail.wnohang.net 40689F0003
Date: Sun, 10 Jul 2011 01:24:57 +0530
From: Raghavendra D Prabhu <rprabhu@wnohang.net>
To: viro@zeniv.linux.org.uk
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Add unlikely to page condition
Message-ID: <376838df2b62c77cc4651d74ab57dff21a082b07.1310240917.git.rprabhu@wnohang.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
X-Operating-System: Arch linux x86_64 3.0.0-rc6-LYM
X-Editor: VIM - Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, 
     Added an unlikely to the page check since page will more likely be
     in the page cache because of page_cache_sync_readahead before it. 

Signed-off-by: Raghavendra D Prabhu <rprabhu@wnohang.net>
---
  fs/splice.c |    2 +-
  1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/splice.c b/fs/splice.c
index aa866d3..f0e591a 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -349,7 +349,7 @@ __generic_file_splice_read(struct file *in, loff_t *ppos,
  		 * the first hole.
  		 */
  		page = find_get_page(mapping, index);
-		if (!page) {
+		if (unlikely(!page)) {
  			/*
  			 * page didn't exist, allocate one.
  			 */
-- 
1.7.6

--------------------------
Raghavendra Prabhu
GPG Id : 0xD72BE977
Fingerprint: B93F EBCB 8E05 7039 CD3C A4B8 A616 DCA1 D72B E977
www: wnohang.net
