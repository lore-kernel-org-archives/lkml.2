Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab1DUQJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 12:09:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33592 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab1DUQJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 12:09:36 -0400
Date: Thu, 21 Apr 2011 09:09:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kvm@vger.kernel.org
Subject: [PATCH -next] kvm: fix const value warning on i386
Message-Id: <20110421090922.4d9a275b.randy.dunlap@oracle.com>
In-Reply-To: <20110421132045.5af1b953.sfr@canb.auug.org.au>
References: <20110421132045.5af1b953.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4DB056B8.0059:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

arch/x86/kvm/emulate.c:2598: warning: integer constant is too large for 'long' type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 arch/x86/kvm/emulate.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20110421.orig/arch/x86/kvm/emulate.c
+++ linux-next-20110421/arch/x86/kvm/emulate.c
@@ -2595,7 +2595,7 @@ static int check_svme_pa(struct x86_emul
 	u64 rax = kvm_register_read(ctxt->vcpu, VCPU_REGS_RAX);
 
 	/* Valid physical address? */
-	if (rax & 0xffff000000000000)
+	if (rax & 0xffff000000000000ULL)
 		return emulate_gp(ctxt, 0);
 
 	return check_svme(ctxt);
