Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102Ab1BUTLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 14:11:47 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60785 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab1BUTLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 14:11:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:to:from:cc:date:message-id:user-agent:mime-version
         :content-type:content-transfer-encoding;
        b=K0S/rM5yTHYYzro/mx5bGrw9LiaV8TKYbZTHoLdTS+SDQvZZwxT/Hg6OINEh9gjjpw
         xkKYQH347t5WnikPiB2nV1PWMEOYN5e1I1WVinve88jVBNaKLRJ73cZsHPUtY1SasTNm
         /FhGgRbRLHtmcyotf6SjGUxJPVTuWtjFywr1s=
Subject: [PATCH] proc: hide kernel addresses via %pK in /proc/<pid>/stack
To: linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Kees Cook <kees.cook@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexey Dobriyan <adobriyan@gmail.com>
Date: Mon, 21 Feb 2011 22:11:21 +0300
Message-ID: <20110221191121.5764.81241.stgit@localhost6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This file is readable for the task owner.
Hide kernel addresses from unprivileged users,
leave them function names and offsets.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 fs/proc/base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 9d096e8..4fa8dc6 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -340,7 +340,7 @@ static int proc_pid_stack(struct seq_file *m, struct pid_namespace *ns,
 	save_stack_trace_tsk(task, &trace);
 
 	for (i = 0; i < trace.nr_entries; i++) {
-		seq_printf(m, "[<%p>] %pS\n",
+		seq_printf(m, "[<%pK>] %pS\n",
 			   (void *)entries[i], (void *)entries[i]);
 	}
 	kfree(entries);

