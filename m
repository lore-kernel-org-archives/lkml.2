Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758274Ab2JZLKR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 07:10:17 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:5639 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593Ab2JZLKM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 07:10:12 -0400
Subject: [PATCH 2/5] ipc: remove redundant MSG_COPY check
To: akpm@linux-foundation.org
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Larry.Finger@lwfinger.net, mitsuo.hayasaka.hu@hitachi.com,
        nhorman@tuxdriver.com, linux-doc@vger.kernel.org,
        catalin.marinas@arm.com, xemul@parallels.com, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, cmetcalf@tilera.com, dhowells@redhat.com,
        ebiederm@xmission.com, rob@landley.net, dan@mindstab.net,
        tglx@linutronix.de, paulmck@linux.vnet.ibm.com, devel@openvz.org,
        mtk.manpages@gmail.com
Date: Fri, 26 Oct 2012 15:06:02 +0400
Message-ID: <20121026110602.17494.86455.stgit@localhost.localdomain>
In-Reply-To: <20121026110103.17494.28182.stgit@localhost.localdomain>
References: <20121026110103.17494.28182.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Small cleanup patch.

Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
---
 ipc/msg.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/ipc/msg.c b/ipc/msg.c
index 28320ab..f9774ff 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -786,11 +786,8 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, long msgtyp,
 		return -EINVAL;
 	if (msgflg & MSG_COPY) {
 #ifdef CONFIG_CHECKPOINT_RESTORE
-
-		if (msgflg & MSG_COPY) {
-			copy_number = msgtyp;
-			msgtyp = 0;
-		}
+		copy_number = msgtyp;
+		msgtyp = 0;
 
 		/*
 		 * Create dummy message to copy real message to.

