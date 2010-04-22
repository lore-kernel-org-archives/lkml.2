Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab0DVUBk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:01:40 -0400
Received: from kroah.org ([198.145.64.141]:59871 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932080Ab0DVUBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:01:04 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:14 2010
Message-Id: <20100422195413.888386115@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:54:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [088/139] x86: Fix breakage of UML from the changes in the rwsem system
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 4126faf0ab7417fbc6eb99fb0fd407e01e9e9dfe upstream.

The patches 5d0b7235d83eefdafda300656e97d368afcafc9a and
bafaecd11df15ad5b1e598adc7736afcd38ee13d broke the UML build:

On Sun, 17 Jan 2010, Ingo Molnar wrote:
>
> FYI, -tip testing found that these changes break the UML build:
>
> kernel/built-in.o: In function `__up_read':
> /home/mingo/tip/arch/x86/include/asm/rwsem.h:192: undefined reference to `call_rwsem_wake'
> kernel/built-in.o: In function `__up_write':
> /home/mingo/tip/arch/x86/include/asm/rwsem.h:210: undefined reference to `call_rwsem_wake'
> kernel/built-in.o: In function `__downgrade_write':
> /home/mingo/tip/arch/x86/include/asm/rwsem.h:228: undefined reference to `call_rwsem_downgrade_wake'
> kernel/built-in.o: In function `__down_read':
> /home/mingo/tip/arch/x86/include/asm/rwsem.h:112: undefined reference to `call_rwsem_down_read_failed'
> kernel/built-in.o: In function `__down_write_nested':
> /home/mingo/tip/arch/x86/include/asm/rwsem.h:154: undefined reference to `call_rwsem_down_write_failed'
> collect2: ld returned 1 exit status

Add lib/rwsem_64.o to the UML subarch objects to fix.

LKML-Reference: <alpine.LFD.2.00.1001171023440.13231@localhost.localdomain>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/sys-x86_64/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/um/sys-x86_64/Makefile
+++ b/arch/um/sys-x86_64/Makefile
@@ -8,7 +8,8 @@ obj-y = bug.o bugs.o delay.o fault.o ldt
 	setjmp.o signal.o stub.o stub_segv.o syscalls.o syscall_table.o \
 	sysrq.o ksyms.o tls.o
 
-subarch-obj-y = lib/csum-partial_64.o lib/memcpy_64.o lib/thunk_64.o
+subarch-obj-y = lib/csum-partial_64.o lib/memcpy_64.o lib/thunk_64.o \
+		lib/rwsem_64.o
 subarch-obj-$(CONFIG_MODULES) += kernel/module.o
 
 ldt-y = ../sys-i386/ldt.o


