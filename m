Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab0HGSBF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 14:01:05 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39799 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab0HGSBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 14:01:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ZZfSKvSEZeqc/zVyaJadMhW38wbaKA09sk9rlSeXOHmhoVJrzsd/MCLRwlzZ2Me59y
         vkrO4XK9q/AiAiJdm6TOXJL5rkHARlp4DyXizT5QuV2oQqO7ADW7NdsvpYstKy0It+vq
         Ga7tGr22B2nqgz5vaF6UbzZCaUCPzWfomJCCE=
From: Namhyung Kim <namhyung@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>, x86@kernel.org
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] kgdb: add missing __percpu markup in arch/x86/kernel/kgdb.c
Date: Sun,  8 Aug 2010 03:00:59 +0900
Message-Id: <1281204059-20707-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

breakinfo->pev is a pointer to percpu pointer but was missing __percpu markup.
Add it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 arch/x86/kernel/kgdb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 01ab17a..f3be870 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -196,7 +196,7 @@ static struct hw_breakpoint {
 	unsigned long		addr;
 	int			len;
 	int			type;
-	struct perf_event	**pev;
+	struct perf_event	* __percpu *pev;
 } breakinfo[4];
 
 static unsigned long early_dr7;
-- 
1.7.0.4

