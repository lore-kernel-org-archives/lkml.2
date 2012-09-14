Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab2INGUz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 02:20:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49058 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab2INGUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 02:20:53 -0400
Date: Thu, 13 Sep 2012 23:20:38 -0700
From: tip-bot for T Makphaibulchoke <tmac@hp.com>
Message-ID: <tip-73e8f3d7e2cb23614d5115703d76d8e54764b641@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, tmac@hp.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, tmac@hp.com
In-Reply-To: <1346210503-14276-1-git-send-email-tmac@hp.com>
References: <1346210503-14276-1-git-send-email-tmac@hp.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/mm/init.c: Fix devmem_is_allowed() off by one
Git-Commit-ID: 73e8f3d7e2cb23614d5115703d76d8e54764b641
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 13 Sep 2012 23:20:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  73e8f3d7e2cb23614d5115703d76d8e54764b641
Gitweb:     http://git.kernel.org/tip/73e8f3d7e2cb23614d5115703d76d8e54764b641
Author:     T Makphaibulchoke <tmac@hp.com>
AuthorDate: Tue, 28 Aug 2012 21:21:43 -0600
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 13 Sep 2012 17:35:54 +0200

x86/mm/init.c: Fix devmem_is_allowed() off by one

Fixing an off-by-one error in devmem_is_allowed(), which allows
accesses to physical addresses 0x100000-0x100fff, an extra page
past 1MB.

Signed-off-by: T Makphaibulchoke <tmac@hp.com>
Acked-by: H. Peter Anvin <hpa@zytor.com>
Cc: yinghai@kernel.org
Cc: tiwai@suse.de
Cc: dhowells@redhat.com
Link: http://lkml.kernel.org/r/1346210503-14276-1-git-send-email-tmac@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/mm/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index e0e6990..ab1f6a9 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -319,7 +319,7 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
  */
 int devmem_is_allowed(unsigned long pagenr)
 {
-	if (pagenr <= 256)
+	if (pagenr < 256)
 		return 1;
 	if (iomem_is_exclusive(pagenr << PAGE_SHIFT))
 		return 0;
