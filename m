Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058Ab1GFDbG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 23:31:06 -0400
Received: from imovil.entelpcs.cl ([200.72.211.69]:2590 "EHLO
	localhost6.localdomain6" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752329Ab1GFDbF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 23:31:05 -0400
Subject: [PATCH] FDPIC: fix memory leak
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: David Howells <dhowells@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: GNU
Date: Tue, 05 Jul 2011 23:30:42 -0400
Message-ID: <1309923042.3975.4.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

The shdr4extnum variable isn't being freed in the cleanup process of elf_fdpic_core_dump().

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 fs/binfmt_elf_fdpic.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index 63039ed..2bc5dc6 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -1864,6 +1864,7 @@ cleanup:
 	kfree(psinfo);
 	kfree(notes);
 	kfree(fpu);
+	kfree(shdr4extnum);
 #ifdef ELF_CORE_COPY_XFPREGS
 	kfree(xfpu);
 #endif
-- 
1.7.4.1


