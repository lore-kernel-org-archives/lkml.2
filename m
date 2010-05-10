Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab0EJF5B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 01:57:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:38014 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab0EJF46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 01:56:58 -0400
Date: Mon, 10 May 2010 05:56:02 GMT
From: "tip-bot for H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       greg@kroah.com, hjanssen@microsoft.com, ksrinivasan@novell.com,
       dtor@vmware.com, tglx@linutronix.de, akataria@vmware.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       greg@kroah.com, hjanssen@microsoft.com, ksrinivasan@novell.com,
       dtor@vmware.com, tglx@linutronix.de, akataria@vmware.com, mingo@elte.hu
In-Reply-To: <4BE49778.6060800@zytor.com>
References: <4BE49778.6060800@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, hypervisor: add missing <linux/module.h>
Message-ID: <tip-3998d095354d2a3062bdaa821ef07a1e1c82873c@git.kernel.org>
Git-Commit-ID: 3998d095354d2a3062bdaa821ef07a1e1c82873c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 10 May 2010 05:56:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3998d095354d2a3062bdaa821ef07a1e1c82873c
Gitweb:     http://git.kernel.org/tip/3998d095354d2a3062bdaa821ef07a1e1c82873c
Author:     H. Peter Anvin <hpa@zytor.com>
AuthorDate: Sun, 9 May 2010 22:46:54 -0700
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Sun, 9 May 2010 22:46:54 -0700

x86, hypervisor: add missing <linux/module.h>

EXPORT_SYMBOL() needs <linux/module.h> to be included; fixes modular
builds of the VMware balloon driver, and any future modular drivers
which depends on the hypervisor.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: Greg KH <greg@kroah.com>
Cc: Hank Janssen <hjanssen@microsoft.com>
Cc: Alok Kataria <akataria@vmware.com>
Cc: Ky Srinivasan <ksrinivasan@novell.com>
Cc: Dmitry Torokhov <dtor@vmware.com>
LKML-Reference: <4BE49778.6060800@zytor.com>
---
 arch/x86/kernel/cpu/hypervisor.c |    1 +
 arch/x86/kernel/cpu/mshyperv.c   |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/hypervisor.c b/arch/x86/kernel/cpu/hypervisor.c
index 4afb5a2..dd531cc 100644
--- a/arch/x86/kernel/cpu/hypervisor.c
+++ b/arch/x86/kernel/cpu/hypervisor.c
@@ -21,6 +21,7 @@
  *
  */
 
+#include <linux/module.h>
 #include <asm/processor.h>
 #include <asm/hypervisor.h>
 
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 0f13717..16f41bb 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/types.h>
+#include <linux/module.h>
 #include <asm/processor.h>
 #include <asm/hypervisor.h>
 #include <asm/hyperv.h>
