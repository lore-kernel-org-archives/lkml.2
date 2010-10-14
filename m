Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab0JNGey (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 02:34:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:55795 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752935Ab0JNGex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 02:34:53 -0400
Date: Thu, 14 Oct 2010 06:34:23 GMT
From: tip-bot for Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        kiran@scalex86.org, tglx@linutronix.de, randy.dunlap@oracle.com,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        kiran@scalex86.org, tglx@linutronix.de, randy.dunlap@oracle.com,
        mingo@elte.hu
In-Reply-To: <20101013210023.9a033222.randy.dunlap@oracle.com>
References: <20101013210023.9a033222.randy.dunlap@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/vsmp: Eliminate kconfig dependency warning
Message-ID: <tip-03f1a17cd5c69deccd3cfe1b954b9426d7a686e3@git.kernel.org>
Git-Commit-ID: 03f1a17cd5c69deccd3cfe1b954b9426d7a686e3
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 14 Oct 2010 06:34:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  03f1a17cd5c69deccd3cfe1b954b9426d7a686e3
Gitweb:     http://git.kernel.org/tip/03f1a17cd5c69deccd3cfe1b954b9426d7a686e3
Author:     Randy Dunlap <randy.dunlap@oracle.com>
AuthorDate: Wed, 13 Oct 2010 21:00:23 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 14 Oct 2010 07:04:30 +0200

x86/vsmp: Eliminate kconfig dependency warning

Fix kconfig dependency warning to satisfy dependencies:

warning: (X86_VSMP && X86_64 && PCI && X86_EXTENDED_PLATFORM ||
XEN && PARAVIRT_GUEST && (X86_64 || X86_32 && X86_PAE && !X86_VISWS) && X86_CMPXCHG && X86_TSC || KVM_CLOCK && PARAVIRT_GUEST || KVM_GUEST && PARAVIRT_GUEST || LGUEST_GUEST && PARAVIRT_GUEST && X86_32) selects PARAVIRT which has unmet direct dependencies (PARAVIRT_GUEST)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Ravikiran Thirumalai <kiran@scalex86.org>
LKML-Reference: <20101013210023.9a033222.randy.dunlap@oracle.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index cea0cd9..64e817e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -372,6 +372,7 @@ endif
 
 config X86_VSMP
 	bool "ScaleMP vSMP"
+	select PARAVIRT_GUEST
 	select PARAVIRT
 	depends on X86_64 && PCI
 	depends on X86_EXTENDED_PLATFORM
