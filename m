Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760701Ab2ERKpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 06:45:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42735 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705Ab2ERKpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 06:45:08 -0400
Date: Fri, 18 May 2012 03:43:52 -0700
From: tip-bot for Ingo Molnar <mingo@kernel.org>
Message-ID: <tip-7ccybvue6mw6wje3uxzzcglj@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, jarkko.sakkinen@intel.com, jeremy@goop.org,
        lenb@kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, jarkko.sakkinen@intel.com, jeremy@goop.org,
        lenb@kernel.org, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86/xen/apic: Add missing #include <xen/xen.h>
Git-Commit-ID: 87e4baacaeba098e217b14e9d2f6af428fe3f657
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 18 May 2012 03:43:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  87e4baacaeba098e217b14e9d2f6af428fe3f657
Gitweb:     http://git.kernel.org/tip/87e4baacaeba098e217b14e9d2f6af428fe3f657
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Fri, 18 May 2012 09:34:45 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 18 May 2012 09:34:45 +0200

x86/xen/apic: Add missing #include <xen/xen.h>

This file depends on <xen/xen.h>, but the dependency was hidden due
to: <asm/acpi.h> -> <asm/trampoline.h> -> <asm/io.h> -> <xen/xen.h>

With the removal of <asm/trampoline.h>, this exposed the missing

Cc: Len Brown <lenb@kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Jarkko Sakkinen <jarkko.sakkinen@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Link: http://lkml.kernel.org/n/tip-7ccybvue6mw6wje3uxzzcglj@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/xen/apic.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/apic.c b/arch/x86/xen/apic.c
index 1913bf2..ec57bd3 100644
--- a/arch/x86/xen/apic.c
+++ b/arch/x86/xen/apic.c
@@ -1,9 +1,12 @@
 #include <linux/init.h>
+
 #include <asm/x86_init.h>
 #include <asm/apic.h>
-#include <xen/interface/physdev.h>
 #include <asm/xen/hypercall.h>
 
+#include <xen/xen.h>
+#include <xen/interface/physdev.h>
+
 unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
 {
 	struct physdev_apic apic_op;
