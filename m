Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701Ab2GTQhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 12:37:51 -0400
Received: from relay.parallels.com ([195.214.232.42]:37877 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752145Ab2GTQht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 12:37:49 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: Andi Kleen <ak@linux.intel.com>, Borislav Petkov <borislav.petkov@amd.com>,
        Vladimir Davydov <vdavydov@parallels.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] cpu: common: make clearcpuid option take bits list
Date: Fri, 20 Jul 2012 20:37:32 +0400
Message-ID: <73e09fb43e37de851acda10dc64bc495a5b68357.1342801662.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is more convenient to write 'clearcpuid=147,148,...' than
'clearcpuid=147 clearcpuid=148 ...'
---
 arch/x86/kernel/cpu/common.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 6b9333b..8ffe1b9 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1012,10 +1012,10 @@ static __init int setup_disablecpuid(char *arg)
 {
 	int bit;
 
-	if (get_option(&arg, &bit) && bit < NCAPINTS*32)
-		setup_clear_cpu_cap(bit);
-	else
-		return 0;
+	while (get_option(&arg, &bit)) {
+		if (bit >= 0 && bit < NCAPINTS*32)
+			setup_clear_cpu_cap(bit);
+	}
 
 	return 1;
 }
-- 
1.7.1

