Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab1KOUWm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 15:22:42 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49484 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757064Ab1KOUWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 15:22:40 -0500
Message-ID: <4EC2CA45.7070605@solonet.org.ua>
Date: Tue, 15 Nov 2011 22:23:33 +0200
From: Denis Kuzmenko <linux@solonet.org.ua>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: Stephen Warren <swarren@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio/gpio-sysfs: Try to export busy GPIO line leads to
 wrong GPIO line exporting
References: <4EBF1DD1.8090600@solonet.org.ua> <74CDBE0F657A3D45AFBB94109FB122FF1740805B5B@HQMAIL01.nvidia.com> <4EC1A0BE.3000901@solonet.org.ua>
In-Reply-To: <4EC1A0BE.3000901@solonet.org.ua>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 11/15/2011 01:14 AM, Denis Kuzmenko wrote:
> On 11/14/2011 10:45 PM, Stephen Warren wrote:
>> Denis Kuzmenko wrote at Saturday, November 12, 2011 6:31 PM:
> 
> Looks like userspace doesn't retries write. Here is trace:
> 
> open("/sys/class/gpio/export", O_WRONLY|O_CREAT|O_TRUNC, 0666) = 3
> ioctl(3, SNDCTL_TMR_TIMEBASE or TCGETS, 0xbef76c64) = -1 ENOTTY (Inappropriate ioctl for device)
> brk(0x30e000)                           = 0x30e000
> write(3, "37\n", 3)                     = -1 EBUSY (Device or resource busy)
> close(3)                                = 0
> exit(0)                                 = ?
> 
> this was made by simple self-written program:
> 	fopen("/sys/class/gpio/export", "w"); fprintf(fp, "37\n");

That was userspace - problem in not reproducible with a code above.
The only way I know to reproduce is:
echo 37 > /sys/class/gpio/export

Traces are generated:

execve("./test-gpio.sh", ["./test-gpio.sh"], [/* 15 vars */]) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x400c0000
open("/lib/libc.so.0", O_RDONLY)        = 3
fstat(3, {st_mode=S_IFREG|0755, st_size=244456, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS|0x4000000, -1, 0) = 0x40183000
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0(\0\1\0\0\0 \204\0\0004\0\0\0"..., 4096) = 4096
mmap2(NULL, 294912, PROT_NONE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x401b9000
mmap2(0x401b9000, 237612, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_FIXED, 3, 0) = 0x401b9000
mmap2(0x401fb000, 4848, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED, 3, 0x3a) = 0x401fb000
mmap2(0x401fd000, 12940, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x401fd000
close(3)                                = 0
munmap(0x40183000, 4096)                = 0
stat("/lib/ld-uClibc.so.0", {st_mode=S_IFREG|0755, st_size=21200, ...}) = 0
mprotect(0x401fb000, 4096, PROT_READ)   = 0
mprotect(0x4005f000, 4096, PROT_READ)   = 0
ioctl(0, SNDCTL_TMR_TIMEBASE or TCGETS, {B115200 opost isig icanon echo ...}) = 0
ioctl(1, SNDCTL_TMR_TIMEBASE or TCGETS, {B115200 opost isig icanon echo ...}) = 0
getuid32()                              = 0
brk(0)                                  = 0xb63000
brk(0xb64000)                           = 0xb64000
brk(0xb65000)                           = 0xb65000
getpid()                                = 540
rt_sigaction(SIGCHLD, {SIG_DFL, [CHLD], SA_RESTART|0x4000000}, {SIG_DFL, [], 0}, 8) = 0
rt_sigaction(SIGHUP, {SIG_DFL, [HUP], SA_RESTART|0x4000000}, {SIG_DFL, [], 0}, 8) = 0
getppid()                               = 539
stat64("/root", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
stat64(".", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
open("./test-gpio.sh", O_RDONLY|O_LARGEFILE) = 3
fcntl64(3, F_DUPFD, 10)                 = 10
close(3)                                = 0
fcntl64(10, F_SETFD, FD_CLOEXEC)        = 0
rt_sigaction(SIGINT, NULL, {SIG_DFL, [], 0}, 8) = 0
rt_sigaction(SIGINT, {0x2f724, ~[], 0x4000000 /* SA_??? */}, NULL, 8) = 0
rt_sigaction(SIGQUIT, NULL, {SIG_DFL, [], 0}, 8) = 0
rt_sigaction(SIGQUIT, {SIG_IGN, [], 0x4000000 /* SA_??? */}, NULL, 8) = 0
rt_sigaction(SIGTERM, NULL, {SIG_DFL, [], 0}, 8) = 0
rt_sigaction(SIGTERM, {SIG_DFL, [], 0x4000000 /* SA_??? */}, NULL, 8) = 0
read(10, "#!/bin/sh\necho 37 > /sys/class/g"..., 1023) = 43
open("/sys/class/gpio/export", O_WRONLY|O_CREAT|O_TRUNC|O_LARGEFILE, 0666) = 3
fcntl64(1, F_DUPFD, 10)                 = 11
dup2(3, 1)                              = 1
close(3)                                = 0
wait4(-1, 0xbed568d4, WNOHANG, NULL)    = -1 ECHILD (No child processes)
fcntl64(1, F_GETFL)                     = 0x20001 (flags O_WRONLY|O_LARGEFILE)
write(1, "37\n", 3)                     = -1 EBUSY (Device or resource busy)
write(1, "3", 1)                        = -1 EBUSY (Device or resource busy)
write(1, "3", 1)                        = -1 EBUSY (Device or resource busy)
dup2(11, 1)                             = 1
close(11)                               = 0
write(1, "3", 13)                        = 1
read(10, "", 1023)                      = 0
exit(255)                               = ?

Traces added to kernel:

export_store: 0x33 
export_store: 0x37 
export_store: 0xa 
export_store: 37

------------[ cut here ]------------
WARNING: at drivers/gpio/gpiolib.c:650 export_store+0xe8/0x148()
Modules linked in:
[<c0028064>] (unwind_backtrace+0x0/0xf0) from [<c0039234>] (warn_slowpath_common+0x48/0x60)
[<c0039234>] (warn_slowpath_common+0x48/0x60) from [<c0039268>] (warn_slowpath_null+0x1c/0x24)
[<c0039268>] (warn_slowpath_null+0x1c/0x24) from [<c0182df0>] (export_store+0xe8/0x148)
[<c0182df0>] (export_store+0xe8/0x148) from [<c01b1bf0>] (class_attr_store+0x30/0xcc)
[<c01b1bf0>] (class_attr_store+0x30/0xcc) from [<c00db9ac>] (sysfs_write_file+0xfc/0x180)
[<c00db9ac>] (sysfs_write_file+0xfc/0x180) from [<c0093304>] (vfs_write+0xac/0x13c)
[<c0093304>] (vfs_write+0xac/0x13c) from [<c0093578>] (sys_write+0x40/0x6c)
[<c0093578>] (sys_write+0x40/0x6c) from [<c0023ffc>] (__sys_trace_return+0x0/0x24)
---[ end trace a23bd23b77702f39 ]---
export_store: 0x33 
export_store: 3
------------[ cut here ]------------
WARNING: at drivers/gpio/gpiolib.c:650 export_store+0xe8/0x148()
Modules linked in:
[<c0028064>] (unwind_backtrace+0x0/0xf0) from [<c0039234>] (warn_slowpath_common+0x48/0x60)
[<c0039234>] (warn_slowpath_common+0x48/0x60) from [<c0039268>] (warn_slowpath_null+0x1c/0x24)
[<c0039268>] (warn_slowpath_null+0x1c/0x24) from [<c0182df0>] (export_store+0xe8/0x148)
[<c0182df0>] (export_store+0xe8/0x148) from [<c01b1bf0>] (class_attr_store+0x30/0xcc)
[<c01b1bf0>] (class_attr_store+0x30/0xcc) from [<c00db9ac>] (sysfs_write_file+0xfc/0x180)
[<c00db9ac>] (sysfs_write_file+0xfc/0x180) from [<c0093304>] (vfs_write+0xac/0x13c)
[<c0093304>] (vfs_write+0xac/0x13c) from [<c0093578>] (sys_write+0x40/0x6c)
[<c0093578>] (sys_write+0x40/0x6c) from [<c0023ffc>] (__sys_trace_return+0x0/0x24)
---[ end trace a23bd23b77702f3a ]---
export_store: 0x33 
export_store: 3
------------[ cut here ]------------
WARNING: at drivers/gpio/gpiolib.c:650 export_store+0xe8/0x148()
Modules linked in:
[<c0028064>] (unwind_backtrace+0x0/0xf0) from [<c0039234>] (warn_slowpath_common+0x48/0x60)
[<c0039234>] (warn_slowpath_common+0x48/0x60) from [<c0039268>] (warn_slowpath_null+0x1c/0x24)
[<c0039268>] (warn_slowpath_null+0x1c/0x24) from [<c0182df0>] (export_store+0xe8/0x148)
[<c0182df0>] (export_store+0xe8/0x148) from [<c01b1bf0>] (class_attr_store+0x30/0xcc)
[<c01b1bf0>] (class_attr_store+0x30/0xcc) from [<c00db9ac>] (sysfs_write_file+0xfc/0x180)
[<c00db9ac>] (sysfs_write_file+0xfc/0x180) from [<c0093304>] (vfs_write+0xac/0x13c)
[<c0093304>] (vfs_write+0xac/0x13c) from [<c0093578>] (sys_write+0x40/0x6c)
[<c0093578>] (sys_write+0x40/0x6c) from [<c0023ffc>] (__sys_trace_return+0x0/0x24)
---[ end trace a23bd23b77702f3b ]---

Can someone point me where the problem can be? 
Should i search it in command interpreter or in libc?

-- 
Best regards, Denis Kuzmenko.
