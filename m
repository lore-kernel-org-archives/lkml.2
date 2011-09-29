Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab1I2Ty1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 15:54:27 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:36389 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755666Ab1I2TxG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 15:53:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: Dan Carpenter <error27@gmail.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 8/9] xen/enlighten: Fix compile warnings.
Date: Thu, 29 Sep 2011 15:52:50 -0400
Message-Id: <1317325971-21603-9-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
References: <1317325971-21603-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090206.4E84CC9F.0025,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux/arch/x86/xen/enlighten.c: In function ‘xen_start_kernel’:
linux/arch/x86/xen/enlighten.c:226: warning: ‘cx’ may be used uninitialized in this function
linux/arch/x86/xen/enlighten.c:240: note: ‘cx’ was declared here

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/enlighten.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index 2d69617..9473861 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -237,7 +237,7 @@ static void xen_cpuid(unsigned int *ax, unsigned int *bx,
 
 static void __init xen_init_cpuid_mask(void)
 {
-	unsigned int ax, bx, cx, dx;
+	unsigned int ax, bx, uninitialized_var(cx), dx;
 	unsigned int xsave_mask;
 
 	cpuid_leaf1_edx_mask =
-- 
1.7.4.1

