Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079Ab1LRXuW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 18:50:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38694 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab1LRXuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 18:50:19 -0500
Date: Sun, 18 Dec 2011 15:49:59 -0800
From: tip-bot for Alan Cox <alan@linux.intel.com>
Message-ID: <tip-a0c3832a578c84d4a93c61e22cb09c99fa9447ea@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, alan@linux.intel.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20111217215719.3743.93550.stgit@bob.linux.org.uk>
References: <20111217215719.3743.93550.stgit@bob.linux.org.uk>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/apb: Fix configuration constraints
Git-Commit-ID: a0c3832a578c84d4a93c61e22cb09c99fa9447ea
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 18 Dec 2011 15:50:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a0c3832a578c84d4a93c61e22cb09c99fa9447ea
Gitweb:     http://git.kernel.org/tip/a0c3832a578c84d4a93c61e22cb09c99fa9447ea
Author:     Alan Cox <alan@linux.intel.com>
AuthorDate: Sat, 17 Dec 2011 21:57:25 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sun, 18 Dec 2011 09:09:47 +0100

x86/apb: Fix configuration constraints

The APB timer requires SFI, SCU and MID support

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Link: http://lkml.kernel.org/r/20111217215719.3743.93550.stgit@bob.linux.org.uk
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 2b54a2f..ca4ee76 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -665,6 +665,7 @@ config APB_TIMER
        def_bool y if MRST
        prompt "Langwell APB Timer Support" if X86_MRST
        select DW_APB_TIMER
+       depends on X86_INTEL_MID && SFI
        help
          APB timer is the replacement for 8254, HPET on X86 MID platforms.
          The APBT provides a stable time base on SMP
