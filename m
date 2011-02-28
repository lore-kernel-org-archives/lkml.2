Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab1B1LTd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 06:19:33 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49474 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab1B1LTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 06:19:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GIT7MPaLYK6Urlv3ncJeqYVBL94Qk3D6CzgcFGfVe/R3rnyD+Mks90u+JZPZw1yxep
         QPqvl8RDDA22VZV84cL9FyvJVRCNtUzoTjXiohQCNd4NFr+gtrBtaODVdP1ys1DYhET7
         /EyVEBbCu5bC8TV1eamqa9c6kM6iFUjyzBpwM=
From: Johan Wessfeldt <johan.wessfeldt@gmail.com>
To: tglx@linutronix.de
Cc: mingo@redhat.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        Johan Wessfeldt <johan.wessfeldt@gmail.com>
Subject: [PATCH] mcheck: Correction to a missing return value from misc_register
Date: Mon, 28 Feb 2011 12:19:04 +0100
Message-Id: <1298891944-21364-1-git-send-email-johan.wessfeldt@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return value from misc_register was not handled correctly
in mcheck_init_device()

Signed-off-by: Johan Wessfeldt <johan.wessfeldt@gmail.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index d916183..7274a11 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -2140,7 +2140,7 @@ static __init int mcheck_init_device(void)
 	}
 
 	register_hotcpu_notifier(&mce_cpu_notifier);
-	misc_register(&mce_log_device);
+	err = misc_register(&mce_log_device);
 
 	return err;
 }
-- 
1.7.2.3

