Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab1CPPc5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 11:32:57 -0400
Received: from mtaout02-winn.ispmail.ntl.com ([81.103.221.48]:36559 "EHLO
	mtaout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752967Ab1CPPcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 11:32:51 -0400
From: Daniel Drake <dsd@laptop.org>
To: hpa@zytor.com
To: mingo@redhat.com
To: tglx@linutronix.de
To: x86@kernel.org
Cc: dilinger@queued.net
Cc: linux-kernel@vger.kernel.org
Cc: jon.nettleton@gmail.com
Subject: [PATCH] x86: Use PentiumPro-optimized partial_csum() on VIA C7
Message-Id: <20110316153247.30CBC9D401E@zog.reactivated.net>
Date: Wed, 16 Mar 2011 15:32:47 +0000 (GMT)
X-Cloudmark-Analysis: v=1.1 cv=R50lirqlHffDPPkwUlkuVa99MrvKdVWo//yz83qex8g= c=1 sm=0 a=sPz8cD7fu90A:10 a=pGLkceISAAAA:8 a=Op-mwl0xAAAA:8 a=AoRmLkDiQGNTvVk2bYYA:9 a=_NAwfJwhTU-g270CjT9JkOhReFUA:4 a=MSl-tDqOz04A:10 a=d4CUUju0HPYA:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Nettleton <jon.nettleton@gmail.com>

Testing on the OLPC XO-1.5 (VIA C7-M 1000MHz CPU) shows a
partial_csum() speed increase by a factor of 1.5 when we switch
to the Pentium-optimized version.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 arch/x86/Kconfig.cpu |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig.cpu b/arch/x86/Kconfig.cpu
index ed47e6e..75d89ac 100644
--- a/arch/x86/Kconfig.cpu
+++ b/arch/x86/Kconfig.cpu
@@ -366,7 +366,7 @@ config X86_INTEL_USERCOPY
 
 config X86_USE_PPRO_CHECKSUM
 	def_bool y
-	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MEFFICEON || MGEODE_LX || MCORE2 || MATOM
+	depends on MWINCHIP3D || MWINCHIPC6 || MCYRIXIII || MK7 || MK6 || MPENTIUM4 || MPENTIUMM || MPENTIUMIII || MPENTIUMII || M686 || MK8 || MVIAC3_2 || MVIAC7 || MEFFICEON || MGEODE_LX || MCORE2 || MATOM
 
 config X86_USE_3DNOW
 	def_bool y
-- 
1.7.4

