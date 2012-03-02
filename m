Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756097Ab2CBAVY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 19:21:24 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:7106 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755111Ab2CBAVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 19:21:23 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArwBAKU/KE8Y9geI/2dsb2JhbAAMgVOCPbt0hkyBK4NngQcEhlCYVA
X-IronPort-AV: E=Sophos;i="4.73,1,1325480400"; 
   d="scan'208";a="165463031"
Message-ID: <4F501282.8050408@teksavvy.com>
Date: Thu, 01 Mar 2012 19:21:22 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.3-rc5
References: <CA+55aFytp=ZT++sj_P7nw9mNSKjPaqjB4srgSB6HYAAJW04-Pw@mail.gmail.com> <4F4B9FFE.5050709@teksavvy.com> <CA+55aFxMPOAdvu-iFL8vDzC=d1osVD91RfksLiE4sAP5Lf5oNQ@mail.gmail.com> <4F4F8BEE.3040806@teksavvy.com> <CA+55aFyij_ORw+BE-Sbkt9Y9qcUQSmW_4e-r7p3t0DNA4Sg9pA@mail.gmail.com> <4F5011AC.2020909@teksavvy.com>
In-Reply-To: <4F5011AC.2020909@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12-03-01 07:17 PM, Mark Lord wrote:
..
> Here's a go, 64-bit kernel (3.2.8), 32-bit userspace:
>
> Dell laptop SMM driver v1.14 21/02/2005 Massimo Dal Zotto (dz@debian.org)
> ioctl32(i8kctl:1474): Unknown cmd fd(3) cmd(80046980){t:'i';sz:4} arg(ff8b1fd8)
> on /proc/i8k
> ioctl32(i8kctl:1475): Unknown cmd fd(3) cmd(c0046986){t:'i';sz:4} arg(ff90ed5c)
> on /proc/i8k
> ioctl32(i8kctl:1475): Unknown cmd fd(3) cmd(c0046986){t:'i';sz:4} arg(ff90ed5c)
> on /proc/i8k
>
> I'll reboot/redo that again with strace shortly.

It all seems to work in 32-bit/32-bit mode, by the way.

Here's the promised strace from 64/32 mode:


$ strace -e raw=ioctl i8kctl fan

execve("/usr/bin/i8kctl", ["i8kctl", "fan"], [/* 21 vars */]) = 0
brk(0)                                  = 0x8e6a000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
mmap2(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0xf77c9000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=123776, ...}) = 0
mmap2(NULL, 123776, PROT_READ, MAP_PRIVATE, 3, 0) = 0xf77aa000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/tls/i686/cmov/libc.so.6", O_RDONLY) = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0000m\1\0004\0\0\0"...,
512) = 512
fstat64(3, {st_mode=S_IFREG|0755, st_size=1405508, ...}) = 0
mmap2(NULL, 1415592, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE, 3, 0) =
0xf7650000
mprotect(0xf77a3000, 4096, PROT_NONE)   = 0
mmap2(0xf77a4000, 12288, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x153) = 0xf77a4000
mmap2(0xf77a7000, 10664, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xf77a7000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0xf764f000
set_thread_area({entry_number:-1 -> 12, base_addr:0xf764f8d0, limit:1048575,
seg_32bit:1, contents:0, read_exec_only:0, limit_in_pages:1, seg_not_present:0,
useable:1}) = 0
mprotect(0xf77a4000, 8192, PROT_READ)   = 0
mprotect(0x804a000, 4096, PROT_READ)    = 0
mprotect(0xf77e7000, 4096, PROT_READ)   = 0
munmap(0xf77aa000, 123776)              = 0
open("/proc/i8k", O_RDONLY)             = 3
ioctl(0x3, 0xc0046986, 0xffc06dcc)      = -1 (errno 22)
ioctl(0x3, 0xc0046986, 0xffc06dcc)      = -1 (errno 22)
fstat64(1, {st_mode=S_IFREG|0644, st_size=1848, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) =
0xf77c8000
write(1, "-1 -1\n", 6-1 -1
)                  = 6
exit_group(0)                           = ?

and from dmesg:

ioctl32(i8kctl:1434): Unknown cmd fd(3) cmd(c0046986){t:'i';sz:4} arg(ffc06dcc)
on /proc/i8k
ioctl32(i8kctl:1434): Unknown cmd fd(3) cmd(c0046986){t:'i';sz:4} arg(ffc06dcc)
on /proc/i8k
