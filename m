Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab2FHFWw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 01:22:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:43220 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761164Ab2FHFHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 01:07:20 -0400
Message-Id: <20120608041845.548668887@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 08 Jun 2012 05:19:15 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Andre Przywara <andre.przywara@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [ 35/82] x86, amd, xen: Avoid NULL pointer paravirt references
In-Reply-To: <20120608041840.861504477@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad@darnok.org>

commit 1ab46fd319bcf1fcd9fb6311727d532b580e4eba upstream.

Stub out MSR methods that aren't actually needed.  This fixes a crash
as Xen Dom0 on AMD Trinity systems.  A bigger patch should be added to
remove the paravirt machinery completely for the methods which
apparently have no users!

Reported-by: Andre Przywara <andre.przywara@amd.com>
Link: http://lkml.kernel.org/r/20120530222356.GA28417@andromeda.dapyr.net
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/xen/enlighten.c |    3 +++
 1 file changed, 3 insertions(+)

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
 


