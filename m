Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab2A0E4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 23:56:53 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:56521 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab2A0Ete (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 23:49:34 -0500
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Damien Millescamps <damien.millescamps@6wind.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 14/29] sysctl: A more obvious version of grab_header.
Date: Thu, 26 Jan 2012 20:51:50 -0800
Message-Id: <1327639925-12920-14-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <m1pqe5ah3z.fsf@fess.ebiederm.org>
References: <m1pqe5ah3z.fsf@fess.ebiederm.org>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/yK2GkN2T2ZjfjyrJ9LelNITnz6XElnrs=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of relying on sysct_head_next(NULL) to magically
return the right header for the root directory instead
explicitly transform NULL into the root directories header.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/proc_sysctl.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index e573f9b..1544485 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -267,10 +267,10 @@ static struct ctl_table *find_in_table(struct ctl_table *p, struct qstr *name)
 
 static struct ctl_table_header *grab_header(struct inode *inode)
 {
-	if (PROC_I(inode)->sysctl)
-		return sysctl_head_grab(PROC_I(inode)->sysctl);
-	else
-		return sysctl_head_next(NULL);
+	struct ctl_table_header *head = PROC_I(inode)->sysctl;
+	if (!head)
+		head = &root_table_header;
+	return sysctl_head_grab(head);
 }
 
 static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
-- 
1.7.2.5

