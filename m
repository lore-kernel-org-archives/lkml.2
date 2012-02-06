Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755289Ab2BFT0g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 14:26:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44299 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753850Ab2BFT0f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 14:26:35 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>,
        Borislav Petkov <borislav.petkov@amd.com>, x86@kernel.org
Subject: [PATCH] x86, Remove AMD microcode warning
Date: Mon,  6 Feb 2012 13:28:55 -0500
Message-Id: <1328552935-965-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

AMD processors will never support /dev/cpu/microcode updating so just silently
fail instead of printing out a warning for every cpu.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Cc: x86@kernel.org
---
 arch/x86/kernel/microcode_amd.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/microcode_amd.c b/arch/x86/kernel/microcode_amd.c
index ac0417b..73465aa 100644
--- a/arch/x86/kernel/microcode_amd.c
+++ b/arch/x86/kernel/microcode_amd.c
@@ -360,7 +360,6 @@ out:
 static enum ucode_state
 request_microcode_user(int cpu, const void __user *buf, size_t size)
 {
-	pr_info("AMD microcode update via /dev/cpu/microcode not supported\n");
 	return UCODE_ERROR;
 }
 
-- 
1.7.1

