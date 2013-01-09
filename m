Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934014Ab3AIUlG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:41:06 -0500
Received: from mail.kernel.org ([198.145.19.201]:43719 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933967Ab3AIUkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:40:55 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Al Viro <viro@ZenIV.linux.org.uk>, Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [ 095/123] arm64: compat for clock_adjtime(2) is miswired
Date: Wed,  9 Jan 2013 12:35:34 -0800
Message-Id: <20130109201510.791519071@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@ZenIV.linux.org.uk>

commit 18a80376ddb0bdc466995ff58c844d6fd0a65e61 upstream.

struct timex is different on arm and arm64; adjtimex(2) takes care to
convert, clock_adjtime(2) doesn't...

Signed-off-by: Al Viro <viro@ZenIV.linux.org.uk>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 arch/arm64/include/asm/unistd32.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/include/asm/unistd32.h
+++ b/arch/arm64/include/asm/unistd32.h
@@ -393,7 +393,7 @@ __SYSCALL(368, compat_sys_fanotify_mark_
 __SYSCALL(369, sys_prlimit64)
 __SYSCALL(370, sys_name_to_handle_at)
 __SYSCALL(371, compat_sys_open_by_handle_at)
-__SYSCALL(372, sys_clock_adjtime)
+__SYSCALL(372, compat_sys_clock_adjtime)
 __SYSCALL(373, sys_syncfs)
 
 #define __NR_compat_syscalls		374


