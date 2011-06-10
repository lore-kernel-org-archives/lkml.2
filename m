Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463Ab1FJNKS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 09:10:18 -0400
Received: from grimli.r00tworld.net ([83.169.44.195]:43527 "EHLO
	mail.r00tworld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757409Ab1FJNKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:10:11 -0400
From: Mathias Krause <minipli@googlemail.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-am33-list@redhat.com, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Subject: [PATCH] mn10300, exec: remove redundant set_fs(USER_DS)
Date: Fri, 10 Jun 2011 15:10:10 +0200
Message-Id: <1307711410-13451-1-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com>
References: <BANLkTinv1teZEHMK0qymaVdcxPOErpqSyg@mail.gmail.com>
References: <BANLkTiknCeAxe30MJdVTxDom+ko8+EDQ4A@mail.gmail.com> <1307642718-22257-1-git-send-email-minipli@googlemail.com> <20110609155630.0f734351.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The address limit is already set in flush_old_exec() so this
set_fs(USER_DS) is redundant.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
---
 arch/mn10300/include/asm/processor.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/mn10300/include/asm/processor.h b/arch/mn10300/include/asm/processor.h
index 4c1b5cc..f7b3c9a 100644
--- a/arch/mn10300/include/asm/processor.h
+++ b/arch/mn10300/include/asm/processor.h
@@ -127,7 +127,6 @@ static inline void start_thread(struct pt_regs *regs,
 {
 	struct thread_info *ti = current_thread_info();
 	struct pt_regs *frame0;
-	set_fs(USER_DS);
 
 	frame0 = thread_info_to_uregs(ti);
 	frame0->epsw = EPSW_nSL | EPSW_IE | EPSW_IM;
-- 
1.5.6.5

