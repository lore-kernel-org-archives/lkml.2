Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957Ab0DVUAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:00:07 -0400
Received: from kroah.org ([198.145.64.141]:59500 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932067Ab0DVT7w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 15:59:52 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:07 2010
Message-Id: <20100422195407.135905679@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:53:21 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "David S. Miller" <davem@davemloft.net>
Subject: [024/139] sparc: Fix regset register window handling.
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit b857bd292223f54aaae3693c82fa7299a99991cd ]

We have to adjust 'reg_window' down by 16 becuase the 'pos' iterator
we'll use to index into the stack slots will be between 16 and 32.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/ptrace_32.c |    4 ++++
 arch/sparc/kernel/ptrace_64.c |    4 ++++
 2 files changed, 8 insertions(+)

--- a/arch/sparc/kernel/ptrace_32.c
+++ b/arch/sparc/kernel/ptrace_32.c
@@ -65,6 +65,7 @@ static int genregs32_get(struct task_str
 			*k++ = regs->u_regs[pos++];
 
 		reg_window = (unsigned long __user *) regs->u_regs[UREG_I6];
+		reg_window -= 16;
 		for (; count > 0 && pos < 32; count--) {
 			if (get_user(*k++, &reg_window[pos++]))
 				return -EFAULT;
@@ -76,6 +77,7 @@ static int genregs32_get(struct task_str
 		}
 
 		reg_window = (unsigned long __user *) regs->u_regs[UREG_I6];
+		reg_window -= 16;
 		for (; count > 0 && pos < 32; count--) {
 			if (get_user(reg, &reg_window[pos++]) ||
 			    put_user(reg, u++))
@@ -141,6 +143,7 @@ static int genregs32_set(struct task_str
 			regs->u_regs[pos++] = *k++;
 
 		reg_window = (unsigned long __user *) regs->u_regs[UREG_I6];
+		reg_window -= 16;
 		for (; count > 0 && pos < 32; count--) {
 			if (put_user(*k++, &reg_window[pos++]))
 				return -EFAULT;
@@ -153,6 +156,7 @@ static int genregs32_set(struct task_str
 		}
 
 		reg_window = (unsigned long __user *) regs->u_regs[UREG_I6];
+		reg_window -= 16;
 		for (; count > 0 && pos < 32; count--) {
 			if (get_user(reg, u++) ||
 			    put_user(reg, &reg_window[pos++]))
--- a/arch/sparc/kernel/ptrace_64.c
+++ b/arch/sparc/kernel/ptrace_64.c
@@ -492,6 +492,7 @@ static int genregs32_get(struct task_str
 			*k++ = regs->u_regs[pos++];
 
 		reg_window = (compat_ulong_t __user *) regs->u_regs[UREG_I6];
+		reg_window -= 16;
 		if (target == current) {
 			for (; count > 0 && pos < 32; count--) {
 				if (get_user(*k++, &reg_window[pos++]))
@@ -516,6 +517,7 @@ static int genregs32_get(struct task_str
 		}
 
 		reg_window = (compat_ulong_t __user *) regs->u_regs[UREG_I6];
+		reg_window -= 16;
 		if (target == current) {
 			for (; count > 0 && pos < 32; count--) {
 				if (get_user(reg, &reg_window[pos++]) ||
@@ -599,6 +601,7 @@ static int genregs32_set(struct task_str
 			regs->u_regs[pos++] = *k++;
 
 		reg_window = (compat_ulong_t __user *) regs->u_regs[UREG_I6];
+		reg_window -= 16;
 		if (target == current) {
 			for (; count > 0 && pos < 32; count--) {
 				if (put_user(*k++, &reg_window[pos++]))
@@ -625,6 +628,7 @@ static int genregs32_set(struct task_str
 		}
 
 		reg_window = (compat_ulong_t __user *) regs->u_regs[UREG_I6];
+		reg_window -= 16;
 		if (target == current) {
 			for (; count > 0 && pos < 32; count--) {
 				if (get_user(reg, u++) ||


