Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab0KXJTZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 04:19:25 -0500
Received: from mail-ww0-f42.google.com ([74.125.82.42]:56259 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab0KXJTV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 04:19:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VjwVHVdz+y7O3ZephDm6t0UNf79sAemjFOzQoMuKoGxMN4Trg4pqS6n1SILSCLTQq5
         EsFqVOHts2i+KArwtZmnWDt6UC7kmXPW9QDqBjj7xnACa4JDBtENZgiD3fbWSPAJppjK
         1Gu/ryI9tE9aJRSNpgQ2mwyB5Gn0mS3QJIaI0=
MIME-Version: 1.0
Date: Wed, 24 Nov 2010 15:19:19 +0600
Message-ID: <AANLkTinV6r_1yHdxbi+o=_w=pHXrdu4fYXONMjYg0yiG@mail.gmail.com>
Subject: [PATCH] x86, dumpstack: Fix unused variable warning.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With allnoconfig, bp becomes unused. So put bp into defination of
CONFIG_FRAME_POINTER.

arch/x86/kernel/dumpstack.c: In function ‘dump_stack’:
arch/x86/kernel/dumpstack.c:200: warning: unused variable ‘bp’

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 8474c99..fc5a253 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -197,10 +197,10 @@ void show_stack(struct task_struct *task,
unsigned long *sp)
  */
 void dump_stack(void)
 {
-	unsigned long bp = 0;
 	unsigned long stack;

 #ifdef CONFIG_FRAME_POINTER
+	unsigned long bp = 0;
 	if (!bp)
 		get_bp(bp);
 #endif
