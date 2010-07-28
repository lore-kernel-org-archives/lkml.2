Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755632Ab0G1Qj1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 12:39:27 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:59447 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab0G1QjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 12:39:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=qP0Sl8OvJPcTNhwT20ZEUn+NaxsVjDQNk/ou8zKXOVLgftZ5Ift1Uw2FuOzdd93BoH
         6RqNP/BYdL4F1APtx3dsUkCZfkrsl8fbtmrqQhJymnnmGobpSNG0CrKhyjk1VXCF0oJk
         QluM8HvCJ6pEurVIP1a+Mts6iJAdY44Dfq7TA=
From: Kulikov Vasiliy <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        Tejun Heo <tj@kernel.org>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 02/10] s390: sysinfo: check return value of create_proc_read_entry()
Date: Wed, 28 Jul 2010 20:39:07 +0400
Message-Id: <1280335147-23185-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

create_proc_read_entry() may fail, if so return -ENOMEM.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 arch/s390/kernel/sysinfo.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/s390/kernel/sysinfo.c b/arch/s390/kernel/sysinfo.c
index a0ffc77..db358e6 100644
--- a/arch/s390/kernel/sysinfo.c
+++ b/arch/s390/kernel/sysinfo.c
@@ -231,9 +231,8 @@ static int proc_read_sysinfo(char *page, char **start,
 
 static __init int create_proc_sysinfo(void)
 {
-	create_proc_read_entry("sysinfo", 0444, NULL,
-			       proc_read_sysinfo, NULL);
-	return 0;
+	return create_proc_read_entry("sysinfo", 0444, NULL,
+			       proc_read_sysinfo, NULL) ? 0 : -ENOMEM;
 }
 device_initcall(create_proc_sysinfo);
 
-- 
1.7.0.4

