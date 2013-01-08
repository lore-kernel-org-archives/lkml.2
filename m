Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756923Ab3AHXid (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 18:38:33 -0500
Received: from mail.windriver.com ([147.11.1.11]:63703 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898Ab3AHXib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 18:38:31 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 53/77] Make TASKSTATS require root access
Date: Tue, 8 Jan 2013 18:35:32 -0500
Message-ID: <1357688156-25387-54-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.1
In-Reply-To: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
References: <1357688156-25387-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 1a51410abe7d0ee4b1d112780f46df87d3621043 upstream.

Ok, this isn't optimal, since it means that 'iotop' needs admin
capabilities, and we may have to work on this some more.  But at the
same time it is very much not acceptable to let anybody just read
anybody elses IO statistics quite at this level.

Use of the GENL_ADMIN_PERM suggested by Johannes Berg as an alternative
to checking the capabilities by hand.

Reported-by: Vasiliy Kulikov <segoon@openwall.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Acked-by: Balbir Singh <bsingharora@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/taskstats.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 5e21645..d5a70a0 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -591,6 +591,7 @@ static struct genl_ops taskstats_ops = {
 	.cmd		= TASKSTATS_CMD_GET,
 	.doit		= taskstats_user_cmd,
 	.policy		= taskstats_cmd_get_policy,
+	.flags		= GENL_ADMIN_PERM,
 };
 
 static struct genl_ops cgroupstats_ops = {
-- 
1.7.12.1

