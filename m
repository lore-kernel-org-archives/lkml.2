Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab0G1X3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 19:29:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:48426 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755884Ab0G1X3P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 19:29:15 -0400
Date: Wed, 28 Jul 2010 23:28:56 GMT
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, hans.rosenfeld@amd.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, hans.rosenfeld@amd.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1280336972-865982-1-git-send-email-hans.rosenfeld@amd.com>
References: <1280336972-865982-1-git-send-email-hans.rosenfeld@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/cpu] x86, cpu: Export AMD errata definitions
Message-ID: <tip-a5b91606bdc9d0a0d036d2d829a22921c705573e@git.kernel.org>
Git-Commit-ID: a5b91606bdc9d0a0d036d2d829a22921c705573e
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 28 Jul 2010 23:28:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5b91606bdc9d0a0d036d2d829a22921c705573e
Gitweb:     http://git.kernel.org/tip/a5b91606bdc9d0a0d036d2d829a22921c705573e
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Wed, 28 Jul 2010 16:23:20 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 28 Jul 2010 16:23:20 -0700

x86, cpu: Export AMD errata definitions

Exprot the AMD errata definitions, since they are needed by kvm_amd.ko
if that is built as a module.  Doing "make allmodconfig" during
testing would have caught this.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Hans Rosenfeld <hans.rosenfeld@amd.com>
LKML-Reference: <1280336972-865982-1-git-send-email-hans.rosenfeld@amd.com>
---
 arch/x86/kernel/cpu/amd.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
index 30f30dc..60a57b1 100644
--- a/arch/x86/kernel/cpu/amd.c
+++ b/arch/x86/kernel/cpu/amd.c
@@ -631,9 +631,11 @@ cpu_dev_register(amd_cpu_dev);
 const int amd_erratum_400[] =
 	AMD_OSVW_ERRATUM(1, AMD_MODEL_RANGE(0xf, 0x41, 0x2, 0xff, 0xf),
 			    AMD_MODEL_RANGE(0x10, 0x2, 0x1, 0xff, 0xf));
+EXPORT_SYMBOL_GPL(amd_erratum_400);
 
 const int amd_erratum_383[] =
 	AMD_OSVW_ERRATUM(3, AMD_MODEL_RANGE(0x10, 0, 0, 0xff, 0xf));
+EXPORT_SYMBOL_GPL(amd_erratum_383);
 
 bool cpu_has_amd_erratum(const int *erratum)
 {
@@ -676,3 +678,5 @@ bool cpu_has_amd_erratum(const int *erratum)
 
 	return false;
 }
+
+EXPORT_SYMBOL_GPL(cpu_has_amd_erratum);
