Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab1EWTcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:32:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:58899 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932346Ab1EWTcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:32:13 -0400
Date: Mon, 23 May 2011 19:31:48 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Message-ID: <tip-b18bf0948e1037e7ed33378c80f1ecb8c77c30e9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        sfr@canb.auug.org.au, tglx@linutronix.de, randy.dunlap@oracle.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, sfr@canb.auug.org.au, randy.dunlap@oracle.com,
        mingo@elte.hu
In-Reply-To: <20110523104300.dd532a99.randy.dunlap@oracle.com>
References: <20110523104300.dd532a99.randy.dunlap@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, apic: Include module.h header in apic_flat_64.c
Git-Commit-ID: b18bf0948e1037e7ed33378c80f1ecb8c77c30e9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 23 May 2011 19:31:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b18bf0948e1037e7ed33378c80f1ecb8c77c30e9
Gitweb:     http://git.kernel.org/tip/b18bf0948e1037e7ed33378c80f1ecb8c77c30e9
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Mon, 23 May 2011 10:43:00 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 May 2011 21:27:35 +0200

x86, apic: Include module.h header in apic_flat_64.c

apic_flat_64.c needs to include module.h because it uses
EXPORT_SYMBOL_GPL().

This fixes these warnings on some !SMP randconfigs:

  arch/x86/kernel/apic/apic_flat_64.c:31: warning: data definition has no type or storage class
  arch/x86/kernel/apic/apic_flat_64.c:31: warning: type defaults to 'int' in declaration of 'EXPORT_SYMBOL_GPL'
  arch/x86/kernel/apic/apic_flat_64.c:31: warning: parameter names (without types) in function declaration

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Link: http://lkml.kernel.org/r/20110523104300.dd532a99.randy.dunlap@oracle.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/apic/apic_flat_64.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/apic_flat_64.c b/arch/x86/kernel/apic/apic_flat_64.c
index 9570ee5..f7a41e4 100644
--- a/arch/x86/kernel/apic/apic_flat_64.c
+++ b/arch/x86/kernel/apic/apic_flat_64.c
@@ -16,6 +16,7 @@
 #include <linux/ctype.h>
 #include <linux/init.h>
 #include <linux/hardirq.h>
+#include <linux/module.h>
 #include <asm/smp.h>
 #include <asm/apic.h>
 #include <asm/ipi.h>
