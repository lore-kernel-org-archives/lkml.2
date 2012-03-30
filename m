Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936072Ab2C3V1R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:27:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34386 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966213Ab2C3VWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:22:31 -0400
Message-Id: <20120330194848.354879625@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:50:18 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Thierry Reding <thierry.reding@avionic-design.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [ 113/175] x86-32: Fix typo for mq_getsetattr in syscall table
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thierry Reding <thierry.reding@avionic-design.de>

commit 13354dc412c36fe554f9904a92f1268c74af7e87 upstream.

Syscall 282 was mistakenly named mq_getsetaddr instead of mq_getsetattr.
When building uClibc against the Linux kernel this would result in a
shared library that doesn't provide the mq_getattr() and mq_setattr()
functions.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Link: http://lkml.kernel.org/r/1332366608-2695-2-git-send-email-thierry.reding@avionic-design.de
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/syscalls/syscall_32.tbl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -288,7 +288,7 @@
 279	i386	mq_timedsend		sys_mq_timedsend		compat_sys_mq_timedsend
 280	i386	mq_timedreceive		sys_mq_timedreceive		compat_sys_mq_timedreceive
 281	i386	mq_notify		sys_mq_notify			compat_sys_mq_notify
-282	i386	mq_getsetaddr		sys_mq_getsetattr		compat_sys_mq_getsetattr
+282	i386	mq_getsetattr		sys_mq_getsetattr		compat_sys_mq_getsetattr
 283	i386	kexec_load		sys_kexec_load			compat_sys_kexec_load
 284	i386	waitid			sys_waitid			compat_sys_waitid
 # 285 sys_setaltroot


