Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab0LPSOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 13:14:51 -0500
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:48968 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757054Ab0LPSOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 13:14:49 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: N42qDkwVM1k1iLnF3YBGemj3SRJyFdnC___Mrb5.toTMWRm
 SY.B4bndT
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 16 Dec 2010 12:14:43 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Tejun Heo <htejun@gmail.com>
cc: "H. Peter Anvin" <hpa@zytor.com>, Eric Dumazet <eric.dumazet@gmail.com>,
        akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: x86: udelay: Use this_cpu_read to avoid address calculation
In-Reply-To: <4D0A3AF2.50508@gmail.com>
Message-ID: <alpine.DEB.2.00.1012161214040.21588@router.home>
References: <20101214162842.542421046@linux.com>  <20101214162855.392020353@linux.com> <1292345072.5934.32.camel@edumazet-laptop> <alpine.DEB.2.00.1012141055220.17229@router.home> <4D07A2B7.8080405@zytor.com> <alpine.DEB.2.00.1012141109470.17229@router.home>
 <4D07A7CB.7010205@zytor.com> <4D07A95C.7030703@kernel.org> <4D0814AF.7080209@zytor.com> <4D08ECEF.3040909@kernel.org> <4D08EE57.8010602@zytor.com> <4D08EF4E.8070403@kernel.org> <4D0A3AF2.50508@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code will use a segment prefix instead of doing the lookup and calculation.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 arch/x86/lib/delay.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/lib/delay.c
===================================================================
--- linux-2.6.orig/arch/x86/lib/delay.c	2010-12-16 11:45:12.000000000 -0600
+++ linux-2.6/arch/x86/lib/delay.c	2010-12-16 11:45:37.000000000 -0600
@@ -121,7 +121,7 @@ inline void __const_udelay(unsigned long
 	asm("mull %%edx"
 		:"=d" (xloops), "=&a" (d0)
 		:"1" (xloops), "0"
-		(cpu_data(raw_smp_processor_id()).loops_per_jiffy * (HZ/4)));
+		(this_cpu_read(cpu_info.loops_per_jiffy) * (HZ/4)));

 	__delay(++xloops);
 }

