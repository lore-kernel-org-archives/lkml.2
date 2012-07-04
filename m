Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab2GDOgJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 10:36:09 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:49867 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753535Ab2GDOgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 10:36:04 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] kernel: fix mishandling of out of memory in poweroff
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Date: Wed, 04 Jul 2012 16:34:51 +0100
Message-ID: <20120704153443.4055.53130.stgit@bluebook>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Coverity 703573

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index b04ae03..9271b7c 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2212,13 +2212,13 @@ int orderly_poweroff(bool force)
 
 	ret = call_usermodehelper_fns(argv[0], argv, envp, UMH_NO_WAIT,
 				      NULL, argv_cleanup, NULL);
-out:
 	if (likely(!ret))
 		return 0;
 
 	if (ret == -ENOMEM)
 		argv_free(argv);
 
+out:
 	if (force) {
 		printk(KERN_WARNING "Failed to start orderly shutdown: "
 		       "forcing the issue\n");

