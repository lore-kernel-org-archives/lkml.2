Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab2FNV1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 17:27:32 -0400
Received: from eu1sys200aog114.obsmtp.com ([207.126.144.137]:58697 "EHLO
	eu1sys200aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755362Ab2FNV1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 17:27:31 -0400
From: Per Forlin <per.forlin@stericsson.com>
To: <linux-kernel@vger.kernel.org>, <gorcunov@openvz.org>,
        <serge.hallyn@canonical.com>, <keescook@chromium.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Per Forlin <per.lkml@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Per Forlin <per.forlin@stericsson.com>
Subject: [PATCH] reboot: disable nonboot CPUs
Date: Thu, 14 Jun 2012 23:25:15 +0200
Message-ID: <1339709115-531-1-git-send-email-per.forlin@stericsson.com>
X-Mailer: git-send-email 1.7.10
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disable the nonboot CPUs to safely migrate tasks and interrupts
to the boot CPU. This will prevent the nonboot CPUs to
interfer or block the boot CPU from being able to reboot
the system successfully.

Signed-off-by: Per Forlin <per.forlin@stericsson.com>
---
Is there a reason for disable nonboot CPUs only for power_off but not reboot?

I have run into an issue on an ARM platform that prevents reboot unless
the nonboot CPUs are brought down safetly. I could make this patch ARM
specific but I thought that other ARCHs may benefit from this patch too.

 kernel/sys.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index f0ec44d..0eaa8e0 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -323,6 +323,7 @@ void kernel_restart_prepare(char *cmd)
 	system_state = SYSTEM_RESTART;
 	usermodehelper_disable();
 	device_shutdown();
+	disable_nonboot_cpus();
 	syscore_shutdown();
 }
 
-- 
1.7.8

