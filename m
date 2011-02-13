Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab1BMW5r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 17:57:47 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50296 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab1BMW5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 17:57:42 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: X32 psABI status
Date: Sun, 13 Feb 2011 23:57:29 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: x32-abi@googlegroups.com, "H.J. Lu" <hjl.tools@gmail.com>,
        GCC Development <gcc@gcc.gnu.org>,
        GNU C Library <libc-alpha@sourceware.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
References: <AANLkTikgfv+L9WS4s6n5mQcXWTzc6YMNUSsgBiAOmKbE@mail.gmail.com> <201102132328.15360.arnd@arndb.de> <4D585F5F.6030708@zytor.com>
In-Reply-To: <4D585F5F.6030708@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102132357.29725.arnd@arndb.de>
X-Provags-ID: V02:K0:QWlXoH6z6CVdVhl5wwhI+X+PvKaX4NDiqg5h5pl/NqC
 IkR1tImwpuSKsVOxCRQ/VLunQZnjv2QSp9kMo/Q5oyUAlfluM6
 SYicZQLBowXinf2kIeOITMuLU2nKbctj7vfL7x7zfbin9i1wZc
 HKltKX7+vfPPQbOB/oqdGh8/9mUaSoEYgy/She/haRT4MLeP7Y
 NqQdv7+6BshpqSJ8HYQMg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 February 2011, H. Peter Anvin wrote:
> We prototyped using the int $0x80 system call entry point.  However,
> there are two disadvantages:
> 
> a. the int $0x80 instruction is much slower than syscall.  An actual
>    i386 process can use the syscall instruction which is disambiguated
>    by the CPU based on mode, but an x32 process is in the same CPU mode
>    as a normal 64-bit process.

Well, you could simply change entry.S to allow syscall with high numbers
to have the same effect as int $0x80, but not introduce another table
to solve this.

> b. 64-bit arguments have to be split between two registers for the
>    i386 entry points, requiring user-space stubs.

64 bit arguments are very rare, and most of those syscalls are not
performance critical, so this could be dealt with on a case-by-case
basis, possibly by introducing a new syscall number for the variant
passing a 64 bit register.

> All in all, the cost of an extra system call table is quite modest.

The memory size overhead may be small, but auditing another table
for every change could become a noticable burden (your though, not mine).

> The cost of an entire different ABI layer (supporting a new memory layout)
> would be enormous, a.k.a. "not worth it", which is why the memory layout
> of kernel objects needs to be compatible with i386.

Right, this makes sense, you certainly can't redefine all the data
structures. 

What would probably be a good idea is to compare the set of syscalls
in X32 and asm-generic, and to either eliminate or document the
differences. You can probably even take the asm-generic syscall numbers,
even if you keep the i386 data structures.

	Arnd
