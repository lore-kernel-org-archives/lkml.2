Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab1HKOvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:51:25 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:37695 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab1HKOvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 10:51:24 -0400
From: slyich@gmail.com
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Alpha: unbreak osf_setsysinfo(SSI_NVPAIRS, [SSIN_UACPROC, UAC_SIGBUS])
Date: Thu, 11 Aug 2011 17:54:36 +0300
Message-Id: <1313074476-3415-1-git-send-email-slyich@gmail.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Trofimovich <slyfox@gentoo.org>

Update 'UAC_SHIFT' to match 'ALPHA_UAC_SHIFT'.

I don't know why kernel maintains 2 copies of the same constant.
One (UAC_SHIFT) is used to shift bits in syscall definition, and
another is in trap handler (ALPHA_UAC_SHIFT).

Was broken by
> commit 745dd2405e281d96c0a449103bdf6a895048f28c
> Author: Michael Cree <mcree@orcon.net.nz>
> Date:   Mon Nov 30 22:44:40 2009 -0500
>
>    Alpha: Rearrange thread info flags fixing two regressions
>
>    Both regressions fixed by (1) rearranging TIF_NOTIFY_RESUME flag to be
>    in lower 8 bits of the thread info flags, and (2) making sure that
>    ALPHA_UAC_SHIFT matches the rearrangement of the thread info flags.
>
>    Signed-off-by: Michael Cree <mcree@orcon.net.nz>
>    Cc: Richard Henderson <rth@twiddle.net>
>    Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
>    Cc: David Howells <dhowells@redhat.com>,
>    Signed-off-by: Matt Turner <mattst88@gmail.com>

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Michael Cree <mcree@orcon.net.nz>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: David Howells <dhowells@redhat.com>,
Cc: Matt Turner <mattst88@gmail.com>
---
 arch/alpha/include/asm/sysinfo.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/alpha/include/asm/sysinfo.h b/arch/alpha/include/asm/sysinfo.h
index 086aba2..42b3edc 100644
--- a/arch/alpha/include/asm/sysinfo.h
+++ b/arch/alpha/include/asm/sysinfo.h
@@ -32,7 +32,7 @@
 
 /* This is the shift that is applied to the UAC bits as stored in the
    per-thread flags.  See thread_info.h.  */
-#define UAC_SHIFT			6
+#define UAC_SHIFT			10
 
 #endif
 
-- 
1.7.3.4

