Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757972Ab0LBSqt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 13:46:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:50234 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757144Ab0LBSqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 13:46:46 -0500
X-Authority-Analysis: v=1.1 cv=kXGwZUU/u1JTMRv8Axk4W0omja+vfTT+sGlOkodD8F8= c=1 sm=0 a=4TXF7EkG9GkA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=SyI_GHdlAAAA:8 a=pGLkceISAAAA:8 a=WPyIoOwQAAAA:8 a=meVymXHHAAAA:8 a=OhwXVeo9PEbk0twBTxoA:9 a=PyIjfU3lLpSvMXN2svgA:7 a=4oWWhmEg3zSfDN2USAAAiTjQzZoA:4 a=UQxMgyrMzRwA:10 a=MSl-tDqOz04A:10 a=1DbiqZag68YA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20101202184645.584297526@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 02 Dec 2010 13:46:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaud Lacombe <lacombar@gmail.com>,
        Wu Zhangjin <wuzhangjin@gmail.com>, Ralf Baechle <ralf@linux-mips.org>,
        John Reiser <jreiser@BitWagon.com>
Subject: [PATCH 3/3] ftrace: Have recordmcount honor endianness in fn_ELF_R_INFO
References: <20101202184612.129218522@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-Have-recordmcount-honor-endianness-in-fn_ELF_.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Reiser <jreiser@bitwagon.com>

It looks to me like the change which introduced "virtual functions"
forgot about cross-platform endianness.

Thank you to Arnaud for supplying before+after data files do_mounts*.o.

This fixes a MIPS build failure triggered by recordmcount.

Reported-by: Arnaud Lacombe <lacombar@gmail.com>
Tested-by: Arnaud Lacombe <lacombar@gmail.com>
Acked-by: Wu Zhangjin <wuzhangjin@gmail.com>
Acked-by: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: John Reiser <jreiser@BitWagon.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/recordmcount.h b/scripts/recordmcount.h
index 58e933a..3966717 100644
--- a/scripts/recordmcount.h
+++ b/scripts/recordmcount.h
@@ -119,7 +119,7 @@ static uint_t (*Elf_r_sym)(Elf_Rel const *rp) = fn_ELF_R_SYM;
 
 static void fn_ELF_R_INFO(Elf_Rel *const rp, unsigned sym, unsigned type)
 {
-	rp->r_info = ELF_R_INFO(sym, type);
+	rp->r_info = _w(ELF_R_INFO(sym, type));
 }
 static void (*Elf_r_info)(Elf_Rel *const rp, unsigned sym, unsigned type) = fn_ELF_R_INFO;
 
-- 
1.7.2.3


