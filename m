Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751612Ab0KVHDH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 02:03:07 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48354 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab0KVHDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 02:03:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pHcozUiZ1ZLIXjfRkFpAJo8Sb2SnHTYFpaqX4qD+hwfltVzzfFje28+QJfv7zKEcQX
         TEsjhdSi+xJUhOouylVolw11b/yfIhblphi4RmaFkx1rXWvocpBlKP4p3yqmbtsVw4dO
         VDQceSXE36P93BIwF2yBwLD270bYGqd+/FLR0=
From: Namhyung Kim <namhyung@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86_64,kgdb: add default case into a switch
Date: Mon, 22 Nov 2010 16:02:55 +0900
Message-Id: <1290409375-28187-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes following sparse warning on x86_64:

 arch/x86/kernel/kgdb.c:123:9: warning: switch with no cases

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 arch/x86/kernel/kgdb.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index cd21b65..6919506 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -135,6 +135,8 @@ char *dbg_get_reg(int regno, void *mem, struct pt_regs *regs)
 		*(unsigned long *)mem = 0xFFFF;
 		break;
 #endif
+	default:
+		break;
 	}
 	return dbg_reg_def[regno].name;
 }
-- 
1.7.0.4

