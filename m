Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754487Ab0DOQ2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 12:28:38 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:54661 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab0DOQ2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 12:28:37 -0400
From: Andreas Schwab <schwab@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix compat uname machine
CC: Christoph Hellwig <hch@lst.de>
X-Yow: Don't hit me!!  I'm in the Twilight Zone!!!
Date: Thu, 15 Apr 2010 18:28:33 +0200
Message-ID: <m2wrw8he8e.fsf@igel.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mask off personality flags when checking for PER_LINUX32.

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
---
On ppc64 you get this error:

$ setarch ppc -R true
setarch: ppc: Unrecognized architecture

because uname still reports ppc64 as the machine.

Andreas.

---
 kernel/sys.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sys.c b/kernel/sys.c
index 6d1a7e0..7cb426a 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -1118,7 +1118,7 @@ DECLARE_RWSEM(uts_sem);
 
 #ifdef COMPAT_UTS_MACHINE
 #define override_architecture(name) \
-	(current->personality == PER_LINUX32 && \
+	(personality(current->personality) == PER_LINUX32 && \
 	 copy_to_user(name->machine, COMPAT_UTS_MACHINE, \
 		      sizeof(COMPAT_UTS_MACHINE)))
 #else
-- 
1.7.0.4


-- 
Andreas Schwab, schwab@linux-m68k.org
GPG Key fingerprint = 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4ED5
"And now for something completely different."
