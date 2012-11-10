Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664Ab2KJWpP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 17:45:15 -0500
Received: from smtp.outflux.net ([198.145.64.163]:34415 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751235Ab2KJWpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 17:45:13 -0500
From: Kees Cook <keescook@chromium.org>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Geremy Condra <gcondra@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>
Subject: [PATCH v5 0/4] arch/arm: support seccomp
Date: Sat, 10 Nov 2012 14:44:41 -0800
Message-Id: <1352587485-18348-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for seccomp BPF to ARM. When built with the seccomp
improvement patch waiting in linux-next ("seccomp: Make syscall skipping
and nr changes more consistent"), this passes the seccomp regression
test suite: https://github.com/redpig/seccomp

Thanks,

-Kees

---
v5:
 - clean up seccomp failure path, as requested by Will Deacon.
v4:
 - fixed syscall_get_arch, thanks to Will Deacon.
v3:
 - updates suggested by Russell King:
   - reduced scope of expansion
   - leveraged TIF_SYSCALL_WORK bit mask
   - fixed syscall==-1 short-circuit logic
v2:
 - expanded ptrace_syscall_trace() into both callers and do
   secure_computing() hookup there, as requested by Al Viro.

