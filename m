Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab0JMULS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 16:11:18 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63023 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab0JMULQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 16:11:16 -0400
Date: Wed, 13 Oct 2010 13:10:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Doug Thompson <dougthompson@xmission.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH -next] edac/mce_amd: fix shift warning
Message-Id: <20101013131057.88238be6.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

The BIT() macro works on unsigned longs, but this warning happens
on i386 (X86_32), where UL is 32 bits and this value needs to be
64 bits, so use open-coded ULL.

drivers/edac/mce_amd.c:262: warning: left shift count >= width of type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Borislav Petkov <borislav.petkov@amd.com>
---
 drivers/edac/mce_amd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20101012.orig/drivers/edac/mce_amd.c
+++ linux-next-20101012/drivers/edac/mce_amd.c
@@ -259,7 +259,8 @@ static void amd_decode_ic_mce(struct mce
 		pr_cont("%s TLB %s.\n", LL_MSG(ec),
 			(xec ? "multimatch" : "parity error"));
 	else if (BUS_ERROR(ec)) {
-		bool k8 = (boot_cpu_data.x86 == 0xf && (m->status & BIT(58)));
+		bool k8 = (boot_cpu_data.x86 == 0xf &&
+				(m->status & (1ULL << 58)));
 
 		pr_cont("during %s.\n", (k8 ? "system linefill" : "NB data read"));
 	} else if (fam_ops->ic_mce(ec))
