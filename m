Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab1I1Opo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 10:45:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33900 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357Ab1I1Opm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 10:45:42 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ming Lei <ming.lei@canonical.com>
Subject: Re: linux-next: build failure after merge of the pm tree
Date: Wed, 28 Sep 2011 16:47:55 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20110928145144.3d074db9aa9b6f858e0dc4fb@canb.auug.org.au> <CACVXFVMrPNZupCQnBMBXsSA1OH=15m9QBKhXT1Of+LghZbKn0Q@mail.gmail.com> <201109281558.05289.rjw@sisk.pl>
In-Reply-To: <201109281558.05289.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201109281647.55538.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 28, 2011, Rafael J. Wysocki wrote:
> On Wednesday, September 28, 2011, Ming Lei wrote:
> > Hi Stephen and Rafael,
> > 
> > Sorry, the attachment patch can fix the build failure, which is
> > caused by unset CONFIG_RUNTIME_PM.
> 
> First off, that's CONFIG_PM_RUNTIME.  Second, why do you want to build
> rpm-traces.c at all if CONFIG_PM_RUNTIME is unset?

IOW, what about the appended patch instead?

Rafael

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: PM / Tracing: Build runtime PM tracepoints if PM_RUNTIME is set

Do not build kernel/trace/rpm-traces.c if CONFIG_PM_RUNTIME is not
set, which avoids a build failure.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/Kconfig  |    4 ++++
 kernel/trace/Makefile |    2 +-
 2 files changed, 5 insertions(+), 1 deletion(-)

Index: linux/kernel/power/Kconfig
===================================================================
--- linux.orig/kernel/power/Kconfig
+++ linux/kernel/power/Kconfig
@@ -238,3 +238,7 @@ config PM_GENERIC_DOMAINS
 config PM_GENERIC_DOMAINS_RUNTIME
 	def_bool y
 	depends on PM_RUNTIME && PM_GENERIC_DOMAINS
+
+config RUNTIME_PM_TRACEPOINTS
+	def_bool y
+	depends on PM_RUNTIME && TRACEPOINTS
Index: linux/kernel/trace/Makefile
===================================================================
--- linux.orig/kernel/trace/Makefile
+++ linux/kernel/trace/Makefile
@@ -53,7 +53,7 @@ endif
 obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
 obj-$(CONFIG_KPROBE_EVENT) += trace_kprobe.o
 obj-$(CONFIG_TRACEPOINTS) += power-traces.o
-obj-$(CONFIG_TRACEPOINTS) += rpm-traces.o
+obj-$(CONFIG_RUNTIME_PM_TRACEPOINTS) += rpm-traces.o
 ifeq ($(CONFIG_TRACING),y)
 obj-$(CONFIG_KGDB_KDB) += trace_kdb.o
 endif
