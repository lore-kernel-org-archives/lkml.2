Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab1LLWeN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 17:34:13 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:32779 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266Ab1LLWeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 17:34:10 -0500
Message-ID: <4EE6815E.8090905@gmail.com>
Date: Mon, 12 Dec 2011 23:34:06 +0100
From: roel <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] arch/tile: misplaced parens near likely
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Parentheses were missing.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 arch/tile/lib/spinlock_32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

This is what it should be, right?

diff --git a/arch/tile/lib/spinlock_32.c b/arch/tile/lib/spinlock_32.c
index cb0999f..b16ac49 100644
--- a/arch/tile/lib/spinlock_32.c
+++ b/arch/tile/lib/spinlock_32.c
@@ -144,7 +144,7 @@ void arch_read_unlock(arch_rwlock_t *rwlock)
 	for (;;) {
 		__insn_mtspr(SPR_INTERRUPT_CRITICAL_SECTION, 1);
 		val = __insn_tns((int *)&rwlock->lock);
-		if (likely(val & 1) == 0) {
+		if (likely((val & 1) == 0)) {
 			rwlock->lock = val - (1 << _RD_COUNT_SHIFT);
 			__insn_mtspr(SPR_INTERRUPT_CRITICAL_SECTION, 0);
 			break;
