Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab1AWOqC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jan 2011 09:46:02 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:41187 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095Ab1AWOp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jan 2011 09:45:59 -0500
Message-ID: <4D3C3F20.7030203@free.fr>
Date: Sun, 23 Jan 2011 15:45:52 +0100
From: matthieu castet <castet.matthieu@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr; rv:1.8.1.23) Gecko/20090823 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Linux Kernel list <linux-kernel@vger.kernel.org>
CC: Xiaotian Feng <xtfeng@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        linux-security-module@vger.kernel.org, Jason Baron <jbaron@redhat.com>
Subject: [PATCH] Fix jump label with RO/NX module protection
Content-Type: multipart/mixed;
 boundary="------------080204070901040506020704"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080204070901040506020704
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

I think it should be applied before 2.6.38 release, because without
this patch there can be crash if RO/NX module protection and jump label are enabled.

--------------080204070901040506020704
Content-Type: text/x-diff;
 name="0001-Fix-jump-table-in-module-init-section.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="0001-Fix-jump-table-in-module-init-section.patch"

>From 0eeba453aaba0ebff86f0a7ad9bfb8afbde0c0dc Mon Sep 17 00:00:00 2001
From: Matthieu CASTET <castet.matthieu@free.fr>
Date: Thu, 20 Jan 2011 21:25:03 +0100
Subject: [PATCH] Fix jump table in module init section

If we use jump table in module init, there are marked
as removed in __jump_table section after init is done.

But we already applied ro permissions on the module, so
we can't modify a read only section (crash in
remove_jump_label_module_init).

Make the __jump_table section rw.

Signed-off-by: Matthieu CASTET <castet.matthieu@free.fr>
---
 arch/x86/include/asm/jump_label.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
index f52d42e..574dbc2 100644
--- a/arch/x86/include/asm/jump_label.h
+++ b/arch/x86/include/asm/jump_label.h
@@ -14,7 +14,7 @@
 	do {							\
 		asm goto("1:"					\
 			JUMP_LABEL_INITIAL_NOP			\
-			".pushsection __jump_table,  \"a\" \n\t"\
+			".pushsection __jump_table,  \"aw\" \n\t"\
 			_ASM_PTR "1b, %l[" #label "], %c0 \n\t" \
 			".popsection \n\t"			\
 			: :  "i" (key) :  : label);		\
-- 
1.7.2.3


--------------080204070901040506020704--
