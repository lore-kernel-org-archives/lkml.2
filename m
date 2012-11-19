Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab2KSPRz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 10:17:55 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:35535 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab2KSPRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 10:17:06 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: Linux Containers <containers@lists.linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Mon, 19 Nov 2012 07:12:36 -0800
Message-Id: <1353337961-12962-11-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
References: <87lidx8wbo.fsf@xmission.com>
 <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
X-XM-AID: U2FsdGVkX19pRUa1pgzyfpuLVf1/qIlGCOGnACjyk98=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMDrug1234561 Drug references
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linux Containers <containers@lists.linux-foundation.org>
X-Spam-Relay-Country: 
Subject: [PATCH review 11/16] procfs: Print task uids and gids in the userns that opened the proc file
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Instead of using current_userns() use the userns of the opener
of the file so that if the file is passed between processes
the contents of the file do not change.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/proc/array.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index c1c207c..5544342 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -162,7 +162,7 @@ static inline const char *get_task_state(struct task_struct *tsk)
 static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 				struct pid *pid, struct task_struct *p)
 {
-	struct user_namespace *user_ns = current_user_ns();
+	struct user_namespace *user_ns = seq_user_ns(m);
 	struct group_info *group_info;
 	int g;
 	struct fdtable *fdt = NULL;
-- 
1.7.5.4

