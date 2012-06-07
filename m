Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654Ab2FGEQs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 00:16:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63657 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003Ab2FGEQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 00:16:45 -0400
Message-Id: <20120607040339.446198849@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 07 Jun 2012 13:03:57 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Andre Przywara <andre.przywara@amd.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [ 21/82] x86, amd, xen: Avoid NULL pointer paravirt references
In-Reply-To: <20120607041406.GA13233@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/enlighten.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -1106,7 +1106,10 @@ static const struct pv_cpu_ops xen_cpu_o
 	.wbinvd = native_wbinvd,
 
 	.read_msr = native_read_msr_safe,
+	.rdmsr_regs = native_rdmsr_safe_regs,
 	.write_msr = xen_write_msr_safe,
+	.wrmsr_regs = native_wrmsr_safe_regs,
+
 	.read_tsc = native_read_tsc,
 	.read_pmc = native_read_pmc,
 


