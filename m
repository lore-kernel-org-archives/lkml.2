Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab0LOQVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 11:21:01 -0500
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:44519 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752486Ab0LOQU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 11:20:58 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: .YEYzNgVM1kFiDD0Hv77O6Kx5A_AoNWZAyKn8i7rRzsOXky
 BwCjFWPV_Y5esZGKxLL06tRcIXCvToRYfx4ilIaME2FJmVim5N1U02P1433A
 AsRStI4qSVWrnfYcp0AbmTqFqHdhrSKsApH7KiW52lvsnUoqnhJWezuPKtMw
 LzpsEX8uEPWTjcKOvLRt1jlo0ksHe6VVRrayGQwxMSKvVNRCJHr5ulH7xvBK
 qnTC7KIK4CU9SDiAwF_lLVIlmSz4I6J_6UQBJ6ocroNVVxyuyjh8uxiPV4rH
 EA7h57u8WrDXZR6_dNDiOc5R51mjElUW1br7kw1vR_4ZBXFA-
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 15 Dec 2010 10:20:53 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V1 2/4] x86: this_cpu_cmpxchg_double()
 support
In-Reply-To: <alpine.DEB.2.00.1012151011550.12186@router.home>
Message-ID: <alpine.DEB.2.00.1012151020030.12470@router.home>
References: <20101214174847.887713690@linux.com> <20101214174900.659284593@linux.com> <4D080FDC.7030005@zytor.com> <4D081225.8000007@zytor.com> <alpine.DEB.2.00.1012151011550.12186@router.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Better comments:

Subject: Fixup comments for cmpxchg16b_cpuops_emu

Indicate that the sematics are not fullly atomic but just per cpu atomic.

Signed-off-by: Christoph Lameter <cl@linux.com>

---
 arch/x86/lib/cmpxchg16b_emu.S |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6/arch/x86/lib/cmpxchg16b_emu.S
===================================================================
--- linux-2.6.orig/arch/x86/lib/cmpxchg16b_emu.S	2010-12-15 10:18:18.000000000 -0600
+++ linux-2.6/arch/x86/lib/cmpxchg16b_emu.S	2010-12-15 10:19:11.000000000 -0600
@@ -30,6 +30,10 @@ CFI_STARTPROC
 # Emulate 'cmpxchg16b %gs:(%rsi)' except we return the result in
 # al not via the ZF. Caller will access al to get result.
 #
+# Note that this is only useful for a cpuops operation. Meaning that we
+# do *not* have a fully atomic operation but just an operation that is
+# *atomic* on a single cpu (as provided by the this_cpu_xx class of macros)
+#
 cmpxchg16b_cpuops_emu:
 	pushf
 	cli

