Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab2IQKbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 06:31:03 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:32909 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752668Ab2IQKbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 06:31:01 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] proc: fix unterminated string
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 17 Sep 2012 11:49:30 +0100
Message-ID: <20120917104901.29914.81645.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

oom_score_adj_write doesn't terminate the string as it should. Also fix
sched_autogroup_write and other copy/pastes of the bug.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: Horses <stable@vger.kernel.org>

---

 fs/proc/base.c     |    2 ++
 fs/proc/task_mmu.c |    1 +
 2 files changed, 3 insertions(+)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 21fb230..4d42cf18 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -910,6 +910,7 @@ static ssize_t oom_score_adj_write(struct file *file, const char __user *buf,
 		err = -EFAULT;
 		goto out;
 	}
+	buffer[count] = '\0';
 
 	err = kstrtoint(strstrip(buffer), 0, &oom_score_adj);
 	if (err)
@@ -1192,6 +1193,7 @@ sched_autogroup_write(struct file *file, const char __user *buf,
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
+	buffer[count] = '\0';
 
 	err = kstrtoint(strstrip(buffer), 0, &nice);
 	if (err < 0)
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 79827ce..a1dae68 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -639,6 +639,7 @@ static ssize_t clear_refs_write(struct file *file, const char __user *buf,
 		count = sizeof(buffer) - 1;
 	if (copy_from_user(buffer, buf, count))
 		return -EFAULT;
+	buffer[count] = '\0';
 	rv = kstrtoint(strstrip(buffer), 10, &type);
 	if (rv < 0)
 		return rv;

