Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab2E3KFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 06:05:19 -0400
Received: from relay.parallels.com ([195.214.232.42]:46660 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161Ab2E3KFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 06:05:16 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Eric Biederman <ebiederm@xmission.com>
CC: Vladimir Davydov <vdavydov@parallels.com>, <kexec@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] kexec: consolidate crash late initialization
Date: Wed, 30 May 2012 14:05:09 +0400
Message-ID: <1338372309-24983-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use one module_init() instead of two.
---
 kernel/kexec.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/kernel/kexec.c b/kernel/kexec.c
index 4e2e472..c3341cb 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -1240,7 +1240,6 @@ static int __init crash_notes_memory_init(void)
 	}
 	return 0;
 }
-module_init(crash_notes_memory_init)
 
 
 /*
@@ -1520,7 +1519,13 @@ static int __init crash_save_vmcoreinfo_init(void)
 	return 0;
 }
 
-module_init(crash_save_vmcoreinfo_init)
+static int __init crash_init(void)
+{
+	crash_notes_memory_init();
+	crash_save_vmcoreinfo_init();
+	return 0;
+}
+module_init(crash_init)
 
 /*
  * Move into place and start executing a preloaded standalone
-- 
1.7.1

