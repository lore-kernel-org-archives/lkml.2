Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931Ab1I2HLV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 03:11:21 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56545 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286Ab1I2HLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 03:11:20 -0400
Date: Thu, 29 Sep 2011 15:09:40 +0800
From: wangyanqing <udknight@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] init:main.c: start 'usermodehelper_enable()' a little early
Message-ID: <20110929070940.GA2838@udknight.homenetwork>
Mail-Followup-To: wangyanqing <Udknight@gmail.com>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit d5767c53535ac79758084773418e0ad186aba4a2 move 'usermodehelper_enable()'
to end of rest_init, then I get failed to let uvesafb work on my computer, and
lose the splash boot.So maybe we could start usermodehelper_enable a little early
to make some task work that need eary init with the help of user mode.
---
 init/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/main.c b/init/main.c
index 23702bb..03b408d 100644
--- a/init/main.c
+++ b/init/main.c
@@ -730,8 +730,8 @@ static void __init do_basic_setup(void)
 	driver_init();
 	init_irq_proc();
 	do_ctors();
-	do_initcalls();
 	usermodehelper_enable();
+	do_initcalls();
 }
 
 static void __init do_pre_smp_initcalls(void)
-- 
1.7.3.4
