Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab1C3GJE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 02:09:04 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:45256 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070Ab1C3GJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 02:09:03 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] proc: constify status array
Date: Wed, 30 Mar 2011 02:09:03 -0400
Message-Id: <1301465343-6861-1-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No need for this local array to be writable, so mark it const.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 fs/proc/array.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 5e4f776..9b45ee8 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -131,7 +131,7 @@ static inline void task_name(struct seq_file *m, struct task_struct *p)
  * you can test for combinations of others with
  * simple bit tests.
  */
-static const char *task_state_array[] = {
+static const char * const task_state_array[] = {
 	"R (running)",		/*   0 */
 	"S (sleeping)",		/*   1 */
 	"D (disk sleep)",	/*   2 */
@@ -147,7 +147,7 @@ static const char *task_state_array[] = {
 static inline const char *get_task_state(struct task_struct *tsk)
 {
 	unsigned int state = (tsk->state & TASK_REPORT) | tsk->exit_state;
-	const char **p = &task_state_array[0];
+	const char * const *p = &task_state_array[0];
 
 	BUILD_BUG_ON(1 + ilog2(TASK_STATE_MAX) != ARRAY_SIZE(task_state_array));
 
-- 
1.7.4.1

