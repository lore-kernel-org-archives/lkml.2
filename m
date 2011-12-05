Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932707Ab1LESG7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 13:06:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59119 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932551Ab1LESG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 13:06:57 -0500
Date: Mon, 5 Dec 2011 10:06:21 -0800
From: tip-bot for Alessandro Rubini <rubini@gnudd.com>
Message-ID: <tip-f9b15df466ba923a5832c9121ad8327ccf5483ef@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        johnstul@us.ibm.com, rubini@gnudd.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        johnstul@us.ibm.com, rubini@gnudd.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <20111028224842.GA7582@mail.gnudd.com>
References: <20111028224842.GA7582@mail.gnudd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/Kconfig: Cyclone-timer depends on x86-summit
Git-Commit-ID: f9b15df466ba923a5832c9121ad8327ccf5483ef
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 10:06:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f9b15df466ba923a5832c9121ad8327ccf5483ef
Gitweb:     http://git.kernel.org/tip/f9b15df466ba923a5832c9121ad8327ccf5483ef
Author:     Alessandro Rubini <rubini@gnudd.com>
AuthorDate: Sat, 29 Oct 2011 00:48:42 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 5 Dec 2011 18:18:15 +0100

x86/Kconfig: Cyclone-timer depends on x86-summit

CONFIG_X86_CYCLONE_TIMER depends on CONFIG_X86_32_NON_STANDARD,
which forces drivers/clocksource/cyclone.c to be compiled. The
file doesn't do anything unless enabled by
arch/x86/kernel/apic/summit_32.c

Make CONFIG_X86_CYCLONE_TIMER depend by X86_SUMMIT instead, to
avoid unnecessary code in other non-standard systems.

Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
Cc: john stultz <johnstul@us.ibm.com>
Link: http://lkml.kernel.org/r/20111028224842.GA7582@mail.gnudd.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9e7a361..faf39a0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -633,7 +633,7 @@ config X86_SUMMIT_NUMA
 
 config X86_CYCLONE_TIMER
 	def_bool y
-	depends on X86_32_NON_STANDARD
+	depends on X86_SUMMIT
 
 source "arch/x86/Kconfig.cpu"
 
