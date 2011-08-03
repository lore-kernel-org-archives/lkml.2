Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab1HCB7P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 21:59:15 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:61892 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab1HCB7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 21:59:06 -0400
Message-ID: <4E38AB50.9040804@gmail.com>
Date: Wed, 03 Aug 2011 09:58:40 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Jan Kara <jack@suse.cz>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] jbd/jbd2: add pointer type conversion on void *arg from void
 * to journal_t * explicitly in kjournald/kjournald2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch is against 3.0

The arg of kjournald/kjournald2 is void *, and points to type
journal_t. We should convert it to journal_t * explicitly in
the kjournald/kjournald2 function body.

Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
---
 fs/jbd/journal.c  |    2 +-
 fs/jbd2/journal.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/jbd/journal.c b/fs/jbd/journal.c
index e2d4285..32956fd 100644
--- a/fs/jbd/journal.c
+++ b/fs/jbd/journal.c
@@ -116,7 +116,7 @@ static void commit_timeout(unsigned long __data)
 
 static int kjournald(void *arg)
 {
-	journal_t *journal = arg;
+	journal_t *journal = (journal_t *)arg;
 	transaction_t *transaction;
 
 	/*
diff --git a/fs/jbd2/journal.c b/fs/jbd2/journal.c
index 0dfa5b5..c4f4bfc 100644
--- a/fs/jbd2/journal.c
+++ b/fs/jbd2/journal.c
@@ -129,7 +129,7 @@ static void commit_timeout(unsigned long __data)
 
 static int kjournald2(void *arg)
 {
-	journal_t *journal = arg;
+	journal_t *journal = (journal_t *)arg;
 	transaction_t *transaction;
 
 	/*
-- 
1.7.1
