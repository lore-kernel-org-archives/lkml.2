Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754433Ab1EDQ5F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:57:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:54861 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752817Ab1EDQ5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:57:02 -0400
Date: Wed, 4 May 2011 09:56:51 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, netdev <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        davem@davemloft.net
Subject: [PATCH -next] x86/net: only select BPF_JIT when NET is enabled
Message-Id: <20110504095651.60082594.randy.dunlap@oracle.com>
In-Reply-To: <20110504144759.802483cc.sfr@canb.auug.org.au>
References: <20110504144759.802483cc.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DC1855A.00F0:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kconfig unmet dependency warning: HAVE_BPF_JIT depends on NET, so
make the "select" of it depend on NET also.

warning: (X86) selects HAVE_BPF_JIT which has unmet direct dependencies (NET)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20110503.orig/arch/x86/Kconfig
+++ linux-next-20110503/arch/x86/Kconfig
@@ -71,7 +71,7 @@ config X86
 	select GENERIC_IRQ_SHOW
 	select IRQ_FORCED_THREADING
 	select USE_GENERIC_SMP_HELPERS if SMP
-	select HAVE_BPF_JIT if X86_64
+	select HAVE_BPF_JIT if (X86_64 && NET)
 
 config INSTRUCTION_DECODER
 	def_bool (KPROBES || PERF_EVENTS)
