Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab2BGTlS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 14:41:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40842 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756727Ab2BGTlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 14:41:16 -0500
Date: Tue, 7 Feb 2012 11:40:56 -0800
From: tip-bot for Prarit Bhargava <prarit@redhat.com>
Message-ID: <tip-c1d2f1bccf4259384e581b937e694ee8a350fe55@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        tglx@linutronix.de, prarit@redhat.com, mingo@elte.hu,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, prarit@redhat.com, borislav.petkov@amd.com,
        mingo@elte.hu
In-Reply-To: <1328552935-965-1-git-send-email-prarit@redhat.com>
References: <1328552935-965-1-git-send-email-prarit@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/microcode: Remove noisy AMD microcode warning
Git-Commit-ID: c1d2f1bccf4259384e581b937e694ee8a350fe55
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 07 Feb 2012 11:41:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c1d2f1bccf4259384e581b937e694ee8a350fe55
Gitweb:     http://git.kernel.org/tip/c1d2f1bccf4259384e581b937e694ee8a350fe55
Author:     Prarit Bhargava <prarit@redhat.com>
AuthorDate: Mon, 6 Feb 2012 13:28:55 -0500
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Feb 2012 10:53:42 +0100

x86/microcode: Remove noisy AMD microcode warning

AMD processors will never support /dev/cpu/microcode updating so
just silently fail instead of printing out a warning for every
cpu.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
Link: http://lkml.kernel.org/r/1328552935-965-1-git-send-email-prarit@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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
 
