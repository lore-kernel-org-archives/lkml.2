Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab0EIITX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 04:19:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:43990 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab0EIITR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 04:19:17 -0400
Date: Sun, 9 May 2010 08:19:01 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       greg@kroah.com, hjanssen@microsoft.com, ksrinivasan@novell.com,
       dtor@vmware.com, tglx@linutronix.de, akataria@vmware.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       greg@kroah.com, hjanssen@microsoft.com, ksrinivasan@novell.com,
       dtor@vmware.com, tglx@linutronix.de, akataria@vmware.com
In-Reply-To: <4BE49778.6060800@zytor.com>
References: <4BE49778.6060800@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] Modify the VMware balloon driver for the new x86_hyper API
Message-ID: <tip-a10a569806e43b9be5fce60b21f836b50b1010e4@git.kernel.org>
Git-Commit-ID: a10a569806e43b9be5fce60b21f836b50b1010e4
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 09 May 2010 08:19:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a10a569806e43b9be5fce60b21f836b50b1010e4
Gitweb:     http://git.kernel.org/tip/a10a569806e43b9be5fce60b21f836b50b1010e4
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Sun, 9 May 2010 01:13:42 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sun, 9 May 2010 01:13:42 -0700

Modify the VMware balloon driver for the new x86_hyper API

Modify the VMware balloon driver to match the new x86_hyper API.

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Greg KH <greg@kroah.com>
Cc: Hank Janssen <hjanssen@microsoft.com>
Cc: Alok Kataria <akataria@vmware.com>
Cc: Ky Srinivasan <ksrinivasan@novell.com>
Cc: Dmitry Torokhov <dtor@vmware.com>
LKML-Reference: <4BE49778.6060800@zytor.com>
---
 drivers/misc/vmware_balloon.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/vmware_balloon.c b/drivers/misc/vmware_balloon.c
index e7161c4..db9cd02 100644
--- a/drivers/misc/vmware_balloon.c
+++ b/drivers/misc/vmware_balloon.c
@@ -41,7 +41,7 @@
 #include <linux/workqueue.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
-#include <asm/vmware.h>
+#include <asm/hypervisor.h>
 
 MODULE_AUTHOR("VMware, Inc.");
 MODULE_DESCRIPTION("VMware Memory Control (Balloon) Driver");
@@ -767,7 +767,7 @@ static int __init vmballoon_init(void)
 	 * Check if we are running on VMware's hypervisor and bail out
 	 * if we are not.
 	 */
-	if (!vmware_platform())
+	if (x86_hyper != &x86_hyper_vmware)
 		return -ENODEV;
 
 	vmballoon_wq = create_freezeable_workqueue("vmmemctl");
