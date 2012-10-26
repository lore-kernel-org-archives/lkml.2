Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346Ab2JZLKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 07:10:24 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:45219 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758280Ab2JZLKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 07:10:18 -0400
Subject: [PATCH 1/5] ipc: wrap new sysctls for CRIU inside
	CONFIG_CHECKPOINT_RESTORE
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Larry.Finger@lwfinger.net, mitsuo.hayasaka.hu@hitachi.com,
        nhorman@tuxdriver.com, linux-doc@vger.kernel.org,
        catalin.marinas@arm.com, xemul@parallels.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, cmetcalf@tilera.com, dhowells@redhat.com,
        ebiederm@xmission.com, rob@landley.net, dan@mindstab.net,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, devel@openvz.org,
        mtk.manpages@gmail.com
Date: Fri, 26 Oct 2012 15:05:57 +0400
Message-ID: <20121026110557.17494.92212.stgit@localhost.localdomain>
In-Reply-To: <20121026110103.17494.28182.stgit@localhost.localdomain>
References: <20121026110103.17494.28182.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set wraps "msg_next_id", "sem_next_id" and "shm_next_id" inside
CONFIG_CHECKPOINT_RESTORE macro.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
---
 ipc/ipc_sysctl.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index d06d77a..130dfec 100644
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -158,7 +158,9 @@ static int proc_ipcauto_dointvec_minmax(ctl_table *table, int write,
 
 static int zero;
 static int one = 1;
+#ifdef CONFIG_CHECKPOINT_RESTORE
 static int int_max = INT_MAX;
+#endif
 
 static struct ctl_table ipc_kern_table[] = {
 	{
@@ -228,6 +230,7 @@ static struct ctl_table ipc_kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+#ifdef CONFIG_CHECKPOINT_RESTORE
 	{
 		.procname	= "sem_next_id",
 		.data		= &init_ipc_ns.ids[IPC_SEM_IDS].next_id,
@@ -255,6 +258,7 @@ static struct ctl_table ipc_kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &int_max,
 	},
+#endif
 	{}
 };
 

