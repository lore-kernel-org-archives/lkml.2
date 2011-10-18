Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933185Ab1JRRYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 13:24:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755265Ab1JRRYb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 13:24:31 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, x86@kernel.org
Subject: [PATCH] Add TAINT_FIRMWARE_WORKAROUND on MTRR fixup
Date: Tue, 18 Oct 2011 13:24:10 -0400
Message-Id: <1318958650-12447-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TAINT_FIRMWARE_WORKAROUND should be set when an MTRR fixup is done.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: x86@kernel.org
---
 arch/x86/kernel/cpu/mtrr/generic.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/mtrr/generic.c b/arch/x86/kernel/cpu/mtrr/generic.c
index a71efcd..e1fe7f4 100644
--- a/arch/x86/kernel/cpu/mtrr/generic.c
+++ b/arch/x86/kernel/cpu/mtrr/generic.c
@@ -547,6 +547,7 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
 
 		if (tmp != mask_lo) {
 			printk(KERN_WARNING "mtrr: your BIOS has configured an incorrect mask, fixing it.\n");
+			add_taint(TAINT_FIRMWARE_WORKAROUND);
 			mask_lo = tmp;
 		}
 	}
-- 
1.7.1

