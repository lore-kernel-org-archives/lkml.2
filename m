Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030779Ab2HQDbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 23:31:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46812 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933650Ab2HQD1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 23:27:03 -0400
Message-Id: <20120817030249.078200967@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 17 Aug 2012 04:03:16 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 33/37] s390/compat: fix compat wrappers for process_vm system calls
In-Reply-To: <20120817030243.807605523@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 82aabdb6f1eb61e0034ec23901480f5dd23db7c4 upstream.

The compat wrappers incorrectly called the non compat versions of
the system process_vm system calls.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/s390/kernel/compat_wrapper.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/s390/kernel/compat_wrapper.S b/arch/s390/kernel/compat_wrapper.S
index e835d6d..2d82cfc 100644
--- a/arch/s390/kernel/compat_wrapper.S
+++ b/arch/s390/kernel/compat_wrapper.S
@@ -1635,7 +1635,7 @@ ENTRY(compat_sys_process_vm_readv_wrapper)
 	llgfr	%r6,%r6			# unsigned long
 	llgf	%r0,164(%r15)		# unsigned long
 	stg	%r0,160(%r15)
-	jg	sys_process_vm_readv
+	jg	compat_sys_process_vm_readv
 
 ENTRY(compat_sys_process_vm_writev_wrapper)
 	lgfr	%r2,%r2			# compat_pid_t
@@ -1645,4 +1645,4 @@ ENTRY(compat_sys_process_vm_writev_wrapper)
 	llgfr	%r6,%r6			# unsigned long
 	llgf	%r0,164(%r15)		# unsigned long
 	stg	%r0,160(%r15)
-	jg	sys_process_vm_writev
+	jg	compat_sys_process_vm_writev


