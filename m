Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab2E3XYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 19:24:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44490 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab2E3XYd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 19:24:33 -0400
Date: Wed, 30 May 2012 16:23:42 -0700
From: tip-bot for Konrad Rzeszutek Wilk <konrad@darnok.org>
Message-ID: <tip-1ab46fd319bcf1fcd9fb6311727d532b580e4eba@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad@darnok.org, andre.przywara@amd.com, stable@vger.kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad@darnok.org, andre.przywara@amd.com, tglx@linutronix.de,
        stable@vger.kernel.org
In-Reply-To: <20120530222356.GA28417@andromeda.dapyr.net>
References: <20120530222356.GA28417@andromeda.dapyr.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, amd, xen:
  Avoid NULL pointer paravirt references
Git-Commit-ID: 1ab46fd319bcf1fcd9fb6311727d532b580e4eba
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 30 May 2012 16:23:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1ab46fd319bcf1fcd9fb6311727d532b580e4eba
Gitweb:     http://git.kernel.org/tip/1ab46fd319bcf1fcd9fb6311727d532b580e4eba
Author:     Konrad Rzeszutek Wilk <konrad@darnok.org>
AuthorDate: Wed, 30 May 2012 18:23:56 -0400
Committer:  H. Peter Anvin <hpa@zytor.com>
CommitDate: Wed, 30 May 2012 16:15:02 -0700

x86, amd, xen: Avoid NULL pointer paravirt references

Stub out MSR methods that aren't actually needed.  This fixes a crash
as Xen Dom0 on AMD Trinity systems.  A bigger patch should be added to
remove the paravirt machinery completely for the methods which
apparently have no users!

Reported-by: Andre Przywara <andre.przywara@amd.com>
Link: http://lkml.kernel.org/r/20120530222356.GA28417@andromeda.dapyr.net
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Cc: <stable@vger.kernel.org>
---
 arch/x86/xen/enlighten.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 75f33b2..e74df95 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1116,7 +1116,10 @@ static const struct pv_cpu_ops xen_cpu_ops __initconst = {
 	.wbinvd = native_wbinvd,
 
 	.read_msr = native_read_msr_safe,
+	.rdmsr_regs = native_rdmsr_safe_regs,
 	.write_msr = xen_write_msr_safe,
+	.wrmsr_regs = native_wrmsr_safe_regs,
+
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
 
