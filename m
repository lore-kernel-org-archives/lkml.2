Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933542Ab1DNRrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 13:47:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:38608 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933472Ab1DNRr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:47:27 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Americo Wang <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 107/209] sysctl: fix min/max handling in __do_proc_doulongvec_minmax()
Date: Thu, 14 Apr 2011 13:42:17 -0400
Message-Id: <1302803039-9400-108-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit 27b3d80a7b6adcf069b5e869e4efcc3a79f88a91 upstream.

When proc_doulongvec_minmax() is used with an array of longs, and no
min/max check requested (.extra1 or .extra2 being NULL), we dereference a
NULL pointer for the second element of the array.

Noticed while doing some changes in network stack for the "16TB problem"

Fix is to not change min & max pointers in __do_proc_doulongvec_minmax(),
so that all elements of the vector share an unique min/max limit, like
proc_dointvec_minmax().

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Americo Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/sysctl.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 8686b0f..d2ceded 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2314,7 +2314,7 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
 	vleft = table->maxlen / sizeof(unsigned long);
 	left = *lenp;
 	
-	for (; left && vleft--; i++, min++, max++, first=0) {
+	for (; left && vleft--; i++, first = 0) {
 		if (write) {
 			while (left) {
 				char c;
-- 
1.7.4.4

