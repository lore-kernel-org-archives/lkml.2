Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758712Ab2JAXet (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:34:49 -0400
Received: from 1wt.eu ([62.212.114.60]:35125 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932624Ab2JAXAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:18 -0400
Message-Id: <20121001225203.715539863@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:54:21 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ben Hutchings <ben@decadent.org.uk>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 144/180] x86, amd, xen: Avoid NULL pointer paravirt references
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/xen/enlighten.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 0087b00..d52f895 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -945,7 +945,10 @@ static const struct pv_cpu_ops xen_cpu_ops __initdata = {
 	.wbinvd = native_wbinvd,
 
 	.read_msr = native_read_msr_safe,
+	.rdmsr_regs = native_rdmsr_safe_regs,
 	.write_msr = xen_write_msr_safe,
+	.wrmsr_regs = native_wrmsr_safe_regs,
+
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
 
-- 
1.7.2.1.45.g54fbc



