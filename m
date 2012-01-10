Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab2AJUx0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 15:53:26 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:56358 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755288Ab2AJUxY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 15:53:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Phil Oester <kernel@linuxace.com>
Subject: PM: Make sysrq-o be available for CONFIG_PM unset (was: Re: sysrq-o broken since 2.6.38)
Date: Tue, 10 Jan 2012 21:56:47 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20120104053618.GA20879@linuxace.com> <201201092245.28799.rjw@sisk.pl> <20120110191740.GA16465@linuxace.com>
In-Reply-To: <20120110191740.GA16465@linuxace.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201102156.48030.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 10, 2012, Phil Oester wrote:
> On Mon, Jan 09, 2012 at 10:45:28PM +0100, Rafael J. Wysocki wrote:
> > OK, so I think the appended patch should help.
> > 
> > Thanks,
> > Rafael
> 
> Confirmed, your patch solves the issue, thanks.

Great, thanks for testing!

The patch is reproduced below with a changelog and tags.

Thanks,
Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM: Make sysrq-o be available for CONFIG_PM unset

After commit 1eb208aea3179dd2fc0cdeea45ef869d75b4fe70, "PM: Make
CONFIG_PM depend on (CONFIG_PM_SLEEP || CONFIG_PM_RUNTIME)", the
files under kernel/power are not built unless CONFIG_PM_SLEEP or
CONFIG_PM_RUNTIME is set.  In particular, this causes
kernel/power/poweroff.c to be omitted, even though it should be
compiled, because CONFIG_MAGIC_SYSRQ is set.

Fix the problem by causing kernel/power/Makefile to be processed
for CONFIG_PM unset too.

Reported-and-tested-by: Phil Oester <kernel@linuxace.com>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/Makefile |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux/kernel/Makefile
===================================================================
--- linux.orig/kernel/Makefile
+++ linux/kernel/Makefile
@@ -23,6 +23,7 @@ CFLAGS_REMOVE_irq_work.o = -pg
 endif
 
 obj-y += sched/
+obj-y += power/
 
 obj-$(CONFIG_FREEZER) += freezer.o
 obj-$(CONFIG_PROFILING) += profile.o
@@ -52,8 +53,6 @@ obj-$(CONFIG_PROVE_LOCKING) += spinlock.
 obj-$(CONFIG_UID16) += uid16.o
 obj-$(CONFIG_MODULES) += module.o
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
-obj-$(CONFIG_PM) += power/
-obj-$(CONFIG_FREEZER) += power/
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
 obj-$(CONFIG_KEXEC) += kexec.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
