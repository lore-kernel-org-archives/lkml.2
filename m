Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab2HMUXU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:23:20 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:51310 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab2HMUXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:23:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H.J. Lu" <hjl.tools@gmail.com>, Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [ 44/82] x86-64, kcmp: The kcmp system call can be common
Date: Mon, 13 Aug 2012 13:19:20 -0700
Message-Id: <20120813201750.306541457@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813201746.448504360@linuxfoundation.org>
References: <20120813201746.448504360@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit eaf4ce6c5fed6b4c55f7efcd5fc3477435cab5e9 upstream.

We already use the same system call handler for i386 and x86-64, there
is absolutely no reason x32 can't use the same system call, too.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: H.J. Lu <hjl.tools@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>
Link: http://lkml.kernel.org/n/tip-vwzk3qbcr3yjyxjg2j38vgy9@git.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/syscalls/syscall_64.tbl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -318,7 +318,7 @@
 309	common	getcpu			sys_getcpu
 310	64	process_vm_readv	sys_process_vm_readv
 311	64	process_vm_writev	sys_process_vm_writev
-312	64	kcmp			sys_kcmp
+312	common	kcmp			sys_kcmp
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact


