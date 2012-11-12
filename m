Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893Ab2KLUMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 15:12:00 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:53886 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab2KLUL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 15:11:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAK3+h2z87F5gAMwM8ndQMGV+Xik+gEmWPcdd_B74FgmUhMw+og@mail.gmail.com>
References: <CAK3+h2z87F5gAMwM8ndQMGV+Xik+gEmWPcdd_B74FgmUhMw+og@mail.gmail.com>
Date: Mon, 12 Nov 2012 12:11:58 -0800
Message-ID: <CAK3+h2yc0OdA9WeL=CqfnemsiriPTrwHyEW9rL2WxESor2QpBw@mail.gmail.com>
Subject: Re: ubuntu 10.04 with kernel 3.7.0-rc4 cause ssh fail to start
From: Vincent Li <vincent.mc.li@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 8, 2012 at 4:54 PM, Vincent Li <vincent.mc.li@gmail.com> wrote:
> Hi,
>
> I am running ubuntu 10.04  with most recent kernel based on this link
> https://wiki.ubuntu.com/KernelTeam/GitKernelBuild. I had experienced a
> strange issue that with 3.7.0-rc4. the ssh service fail to start, but
> with 3.6.0 kernel, ssh service startup fine. I did 'strace -tt -f -o
> <output>  service start ssh'  the difference here:
>
> 3.7.0-rc4 strace:
>
> 1868  16:45:06.047289 writev(3,
> [{"l\1\2\1\10\0\0\0\2\0\0\0i\0\0\0\1\1o\0\34\0\0\0/com/ubu"..., 128},
> {"\0\0\0\0\1\0\0\0", 8}], 2) = 136
> 1868  16:45:06.047441 poll([{fd=3, events=POLLIN}], 1, -1) = 1
> ([{fd=3, revents=POLLIN}])
> 1868  16:45:06.047742 read(3,
> "l\4\1\1#\0\0\0\2\0\0\0o\0\0\0\1\1o\0\34\0\0\0/com/ubu"..., 2048) =
> 163
> 1868  16:45:06.047892 read(3, 0xb92eb050, 2048) = -1 EAGAIN (Resource
> temporarily unavailable)
> 1868  16:45:06.047985 gettimeofday({1352421906, 48023}, NULL) = 0
> 1868  16:45:06.048083 poll([{fd=3, events=POLLIN}], 1, 2078517183) = 1
> ([{fd=3, revents=POLLIN}])
> 1868  16:45:06.048984 read(3,
> "l\3\1\1\30\0\0\0\3\0\0\0?\0\0\0\4\1s\0%\0\0\0com.ubun"..., 2048) =
> 104
> 1868  16:45:06.049121 read(3, 0xb92eb050, 2048) = -1 EAGAIN (Resource
> temporarily unavailable)
> 1868  16:45:06.049319 write(2, "start: Job failed to start\n", 27) = 27
> 1868  16:45:06.049514 close(3)          = 0
> 1868  16:45:06.049837 exit_group(1)     = ?
>
>
>
> 3.6.0 strace:
>
> 2125  16:41:09.150074 writev(3,
> [{"l\1\2\1\10\0\0\0\2\0\0\0i\0\0\0\1\1o\0\34\0\0\0/com/ubu"..., 128},
> {"\0\0\0\0\1\0\0\0", 8}], 2) = 136
> 2125  16:41:09.150224 poll([{fd=3, events=POLLIN}], 1, -1) = 1
> ([{fd=3, revents=POLLIN}])
> 2125  16:41:09.150527 read(3,
> "l\4\1\1#\0\0\0\2\0\0\0o\0\0\0\1\1o\0\34\0\0\0/com/ubu"..., 2048) =
> 163
> 2125  16:41:09.150671 read(3, 0xb9302050, 2048) = -1 EAGAIN (Resource
> temporarily unavailable)
> 2125  16:41:09.150760 gettimeofday({1352421669, 150798}, NULL) = 0
> 2125  16:41:09.150857 poll([{fd=3, events=POLLIN}], 1, -2122005215) =
> 1 ([{fd=3, revents=POLLIN}])
> 2125  16:41:09.155263 read(3,
> "l\2\1\1#\0\0\0\3\0\0\0\17\0\0\0\5\1u\0\2\0\0\0\10\1g\0\1o\0\0"...,
> 2048) = 67
> 2125  16:41:09.155456 read(3, 0xb9302050, 2048) = -1 EAGAIN (Resource
> temporarily unavailable)
> 2125  16:41:09.155716 writev(3,
> [{"l\1\2\1)\0\0\0\3\0\0\0h\0\0\0\1\1o\0\34\0\0\0/com/ubu"..., 120},
> {"\31\0\0\0com.ubuntu.Upstart0_6.Job\0\0\0"..., 41}], 2) = 161
> 2125  16:41:09.156108 gettimeofday({1352421669, 156142}, NULL) = 0
> 2125  16:41:09.156199 poll([{fd=3, events=POLLIN}], 1, 25000) = 1
> ([{fd=3, revents=POLLIN}])
> 2125  16:41:09.156308 read(3,
> "l\2\1\1\f\0\0\0\4\0\0\0\17\0\0\0\5\1u\0\3\0\0\0\10\1g\0\1v\0\0"...,
> 2048) = 44
> 2125  16:41:09.156465 read(3, 0xb9302050, 2048) = -1 EAGAIN (Resource
> temporarily unavailable)
> 2125  16:41:09.156641 writev(3,
> [{"l\1\2\1#\0\0\0\4\0\0\0g\0\0\0\1\1o\0\36\0\0\0/com/ubu"..., 120},
> {"\36\0\0\0com.ubuntu.Upstart0_6.Instan"..., 35}], 2) = 155
> 2125  16:41:09.157043 gettimeofday({1352421669, 157080}, NULL) = 0
> 2125  16:41:09.157144 poll([{fd=3, events=POLLIN}], 1, 25000) = 1
> ([{fd=3, revents=POLLIN}])
> 2125  16:41:09.157258 read(3,
> "l\2\1\1\210\0\0\0\5\0\0\0\23\0\0\0\5\1u\0\4\0\0\0\10\1g\0\5a{s"...,
> 2048) = 176
> 2125  16:41:09.157412 read(3, 0xb9302050, 2048) = -1 EAGAIN (Resource
> temporarily unavailable)
> 2125  16:41:09.157564 fstat64(1, {st_mode=S_IFCHR|0600,
> st_rdev=makedev(136, 0), ...}) = 0
> 2125  16:41:09.157739 mmap2(NULL, 4096, PROT_READ|PROT_WRITE,
> MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0xb73d8000
> 2125  16:41:09.157834 write(1, "ssh start/running, process 2131\n", 32) = 32
> 2125  16:41:09.158004 close(3)          = 0
> 2125  16:41:09.158410 exit_group(0)     = ?
>
> I attached the kernel config and full strace log, is there anything
> else I can provide to help diagnosis the issue?
>
> Thanks
>
> Vincent

FYI:

it looks to be this kernel commit caused user space issue:

commit 01dc52ebdf472f77cca623ca693ca24cfc0f1bbe
Author: Davidlohr Bueso <dave@gnu.org>
Date:   Mon Oct 8 16:29:30 2012 -0700

    oom: remove deprecated oom_adj

    The deprecated /proc/<pid>/oom_adj is scheduled for removal this month.

I filed a bug report in ubuntu
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1077248

Vincent
