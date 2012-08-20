Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab2HTEQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:16:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42117 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab2HTD5h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 23:57:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [ 01/32] s390/compat: fix compat wrappers for process_vm system calls
Date: Sun, 19 Aug 2012 20:56:57 -0700
Message-Id: <20120820035648.053126520@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035647.862247088@linuxfoundation.org>
References: <20120820035647.862247088@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit 82aabdb6f1eb61e0034ec23901480f5dd23db7c4 upstream.

The compat wrappers incorrectly called the non compat versions of
the system process_vm system calls.

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/s390/kernel/compat_wrapper.S |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/kernel/compat_wrapper.S
+++ b/arch/s390/kernel/compat_wrapper.S
@@ -1636,7 +1636,7 @@ ENTRY(compat_sys_process_vm_readv_wrappe
 	llgfr	%r6,%r6			# unsigned long
 	llgf	%r0,164(%r15)		# unsigned long
 	stg	%r0,160(%r15)
-	jg	sys_process_vm_readv
+	jg	compat_sys_process_vm_readv
 
 ENTRY(compat_sys_process_vm_writev_wrapper)
 	lgfr	%r2,%r2			# compat_pid_t
@@ -1646,4 +1646,4 @@ ENTRY(compat_sys_process_vm_writev_wrapp
 	llgfr	%r6,%r6			# unsigned long
 	llgf	%r0,164(%r15)		# unsigned long
 	stg	%r0,160(%r15)
-	jg	sys_process_vm_writev
+	jg	compat_sys_process_vm_writev


