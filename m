Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab2BOTiZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 14:38:25 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38108 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755051Ab2BOTiV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 14:38:21 -0500
MIME-Version: 1.0
In-Reply-To: <CAMJ=MEe8AMsrEawPO1h_dpc01WvmHUaDv3OMqw3xMRgk-dvMqQ@mail.gmail.com>
References: <CAMJ=MEe8AMsrEawPO1h_dpc01WvmHUaDv3OMqw3xMRgk-dvMqQ@mail.gmail.com>
Date: Wed, 15 Feb 2012 20:38:20 +0100
Message-ID: <CAMJ=MEd46bjasGy5FsjSva8-xz1EgFNvjcMEbXTDpMmkHb9HPg@mail.gmail.com>
Subject: Re: Question [heap] section on /proc/maps
From: Ronny Meeus <ronny.meeus@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 2:23 PM, Ronny Meeus <ronny.meeus@gmail.com> wrote:
> Hello
>
> I have a question about the [heap] section in the /proc/x/maps file.
>
> I tracked all allocations of my build using the mtrace mechanism
> provided by the libc library.
> The total amount of memory that my application allocates is something
> like 15Mb.
> If I look to the maps information in the /proc, I see that almost 35Mb
> is reported in the [heap] section.
>
> Please note that I started the tracking (call to mtrace();) only in
> the beginning of the main so that are most probably some calls to
> malloc done before this but I assume that this is not so much.
>
> Can somebody help me to identify where the 20Mb of heap memory is
> allocated/used for?
>
> Next to this there are also a large number of areas (from 4802f000
> till 494d1000) in the map below. This is another 21Mb of memory that I
> cannot explain.
> Many thanks.
>
> # cat /proc/24160/maps
> 00100000-00102000 r-xp 00000000 00:00 0          [vdso]
> 0fb13000-0fb1e000 r-xp 00000000 00:01 26         /lib/libnss_files-2.10.1.so
> 0fb1e000-0fb2d000 ---p 0000b000 00:01 26         /lib/libnss_files-2.10.1.so
> 0fb2d000-0fb2e000 r--p 0000a000 00:01 26         /lib/libnss_files-2.10.1.so
> 0fb2e000-0fb2f000 rwxp 0000b000 00:01 26         /lib/libnss_files-2.10.1.so
> 0fb3f000-0fb54000 r-xp 00000000 00:01 66         /lib/libpthread-2.10.1.so
> 0fb54000-0fb63000 ---p 00015000 00:01 66         /lib/libpthread-2.10.1.so
> 0fb63000-0fb64000 r--p 00014000 00:01 66         /lib/libpthread-2.10.1.so
> 0fb64000-0fb65000 rwxp 00015000 00:01 66         /lib/libpthread-2.10.1.so
> 0fb65000-0fb67000 rwxp 00000000 00:00 0
> 0fb77000-0fcdf000 r-xp 00000000 00:01 73         /lib/libc-2.10.1.so
> 0fcdf000-0fcef000 ---p 00168000 00:01 73         /lib/libc-2.10.1.so
> 0fcef000-0fcf1000 r--p 00168000 00:01 73         /lib/libc-2.10.1.so
> 0fcf1000-0fcf4000 rwxp 0016a000 00:01 73         /lib/libc-2.10.1.so
> 0fcf4000-0fcf7000 rwxp 00000000 00:00 0
> 0fd07000-0fd1e000 r-xp 00000000 00:01 72         /lib/libgcc_s.so.1
> 0fd1e000-0fd2d000 ---p 00017000 00:01 72         /lib/libgcc_s.so.1
> 0fd2d000-0fd2e000 r--p 00016000 00:01 72         /lib/libgcc_s.so.1
> 0fd2e000-0fd2f000 rwxp 00017000 00:01 72         /lib/libgcc_s.so.1
> 0fd3f000-0fe2b000 r-xp 00000000 00:01 30         /lib/libm-2.10.1.so
> 0fe2b000-0fe3a000 ---p 000ec000 00:01 30         /lib/libm-2.10.1.so
> 0fe3a000-0fe3b000 r--p 000eb000 00:01 30         /lib/libm-2.10.1.so
> 0fe3b000-0fe3c000 rwxp 000ec000 00:01 30         /lib/libm-2.10.1.so
> 0fe4c000-0ff2f000 r-xp 00000000 00:01 535        /usr/lib/libstdc++.so.6.0.13
> 0ff2f000-0ff3f000 ---p 000e3000 00:01 535        /usr/lib/libstdc++.so.6.0.13
> 0ff3f000-0ff43000 r--p 000e3000 00:01 535        /usr/lib/libstdc++.so.6.0.13
> 0ff43000-0ff44000 rwxp 000e7000 00:01 535        /usr/lib/libstdc++.so.6.0.13
> 0ff44000-0ff4d000 rwxp 00000000 00:00 0
> 0ff5d000-0ff60000 r-xp 00000000 00:01 544        /usr/lib/libUIO.so.0.0.0
> 0ff60000-0ff6f000 ---p 00003000 00:01 544        /usr/lib/libUIO.so.0.0.0
> 0ff6f000-0ff70000 r--p 00002000 00:01 544        /usr/lib/libUIO.so.0.0.0
> 0ff70000-0ff71000 rwxp 00003000 00:01 544        /usr/lib/libUIO.so.0.0.0
> 0ff81000-0ff88000 r-xp 00000000 00:01 25         /lib/librt-2.10.1.so
> 0ff88000-0ff97000 ---p 00007000 00:01 25         /lib/librt-2.10.1.so
> 0ff97000-0ff98000 r--p 00006000 00:01 25         /lib/librt-2.10.1.so
> 0ff98000-0ff99000 rwxp 00007000 00:01 25         /lib/librt-2.10.1.so
> 0ffa9000-0ffb4000 r-xp 00000000 00:01 546
> /usr/lib/libcopperplate.so.0.0.0
> 0ffb4000-0ffc4000 ---p 0000b000 00:01 546
> /usr/lib/libcopperplate.so.0.0.0
> 0ffc4000-0ffc5000 r--p 0000b000 00:01 546
> /usr/lib/libcopperplate.so.0.0.0
> 0ffc5000-0ffc6000 rwxp 0000c000 00:01 546
> /usr/lib/libcopperplate.so.0.0.0
> 0ffd6000-0ffdd000 r-xp 00000000 00:01 571        /usr/lib/libpsos.so.0.0.0
> 0ffdd000-0ffec000 ---p 00007000 00:01 571        /usr/lib/libpsos.so.0.0.0
> 0ffec000-0ffed000 r--p 00006000 00:01 571        /usr/lib/libpsos.so.0.0.0
> 0ffed000-0ffee000 rwxp 00007000 00:01 571        /usr/lib/libpsos.so.0.0.0
> 0ffee000-0fff0000 rwxp 00000000 00:00 0
> 10000000-10300000 r-xp 00000000 00:01 62595
> /isam/user/isam_nt_app.nostrip.exe
> 10300000-10301000 r--p 00300000 00:01 62595
> /isam/user/isam_nt_app.nostrip.exe
> 10301000-10305000 rwxp 00301000 00:01 62595
> /isam/user/isam_nt_app.nostrip.exe
> 10305000-123dd000 rwxp 00000000 00:00 0          [heap]
> 48000000-4801d000 r-xp 00000000 00:01 78         /lib/ld-2.10.1.so
> 4801d000-4801f000 rw-p 00000000 00:00 0
> 4801f000-48022000 rw-p 00000000 00:00 0
> 4802d000-4802e000 r--p 0001d000 00:01 78         /lib/ld-2.10.1.so
> 4802e000-4802f000 rwxp 0001e000 00:01 78         /lib/ld-2.10.1.so
> 4802f000-48030000 ---p 00000000 00:00 0
> 48030000-480af000 rw-p 00000000 00:00 0
> 480af000-480b0000 ---p 00000000 00:00 0
> 480b0000-48ed1000 rw-p 00000000 00:00 0
> 48ed1000-48ed2000 ---p 00000000 00:00 0
> 48ed2000-48ef1000 rw-p 00000000 00:00 0
> 48ef1000-48ef2000 ---p 00000000 00:00 0
> 48ef2000-48f11000 rw-p 00000000 00:00 0
> 48f11000-48f12000 ---p 00000000 00:00 0
> 48f12000-48f31000 rw-p 00000000 00:00 0
> 48f31000-48f32000 ---p 00000000 00:00 0
> 48f32000-48f51000 rw-p 00000000 00:00 0
> 48f51000-48f52000 ---p 00000000 00:00 0
> 48f52000-48f71000 rw-p 00000000 00:00 0
> 48f71000-48f72000 ---p 00000000 00:00 0
> 48f72000-48f91000 rw-p 00000000 00:00 0
> 48f91000-48f92000 ---p 00000000 00:00 0
> 48f92000-48fb1000 rw-p 00000000 00:00 0
> 48fb1000-48fb2000 ---p 00000000 00:00 0
> 48fb2000-48fd1000 rw-p 00000000 00:00 0
> 48fd1000-48fd2000 ---p 00000000 00:00 0
> 48fd2000-48ff1000 rw-p 00000000 00:00 0
> 48ff1000-48ff2000 ---p 00000000 00:00 0
> 48ff2000-49011000 rw-p 00000000 00:00 0
> 49011000-49012000 ---p 00000000 00:00 0
> 49012000-49031000 rw-p 00000000 00:00 0
> 49031000-49032000 ---p 00000000 00:00 0
> 49032000-49051000 rw-p 00000000 00:00 0
> 49051000-49052000 ---p 00000000 00:00 0
> 49052000-49071000 rw-p 00000000 00:00 0
> 49071000-49072000 ---p 00000000 00:00 0
> 49072000-49091000 rw-p 00000000 00:00 0
> 49091000-49092000 ---p 00000000 00:00 0
> 49092000-490b1000 rw-p 00000000 00:00 0
> 490b1000-490b2000 ---p 00000000 00:00 0
> 490b2000-490d1000 rw-p 00000000 00:00 0
> 490d1000-490d2000 ---p 00000000 00:00 0
> 490d2000-490f1000 rw-p 00000000 00:00 0
> 490f1000-490f2000 ---p 00000000 00:00 0
> 490f2000-49111000 rw-p 00000000 00:00 0
> 49111000-49112000 ---p 00000000 00:00 0
> 49112000-49131000 rw-p 00000000 00:00 0
> 49131000-49132000 ---p 00000000 00:00 0
> 49132000-49151000 rw-p 00000000 00:00 0
> 49151000-49152000 ---p 00000000 00:00 0
> 49152000-49351000 rw-p 00000000 00:00 0
> 49351000-49352000 ---p 00000000 00:00 0
> 49352000-49371000 rw-p 00000000 00:00 0
> 49371000-49372000 ---p 00000000 00:00 0
> 49372000-49391000 rw-p 00000000 00:00 0
> 49391000-49392000 ---p 00000000 00:00 0
> 49392000-493b1000 rw-p 00000000 00:00 0
> 493b1000-493b2000 ---p 00000000 00:00 0
> 493b2000-493d1000 rw-p 00000000 00:00 0
> 493d1000-493d2000 ---p 00000000 00:00 0
> 493d2000-493f1000 rw-p 00000000 00:00 0
> 493f1000-493f2000 ---p 00000000 00:00 0
> 493f2000-49411000 rw-p 00000000 00:00 0
> 49411000-49412000 ---p 00000000 00:00 0
> 49412000-49431000 rw-p 00000000 00:00 0
> 49431000-49432000 ---p 00000000 00:00 0
> 49432000-49451000 rw-p 00000000 00:00 0
> 49451000-49452000 ---p 00000000 00:00 0
> 49452000-49471000 rw-p 00000000 00:00 0
> 49471000-49472000 ---p 00000000 00:00 0
> 49472000-49491000 rw-p 00000000 00:00 0
> 49491000-49492000 ---p 00000000 00:00 0
> 49492000-494b1000 rw-p 00000000 00:00 0
> 494b1000-494b2000 ---p 00000000 00:00 0
> 494b2000-494d1000 rw-p 00000000 00:00 0
> a0000000-a2000000 rw-s 7e000000 00:01 265        /dev/mem
> bff5b000-bff7c000 rw-p 00000000 00:00 0          [stack]
>
>
> Best regards,
> Ronny

In the meantime I have investigated the issue in more detail and I
found that the [heap] section is in fact the bss section of my build
while the unnamed sections are the blocks allocated by the libc on
behalf of malloc.

So I basically now can explain the memory map and how it maps to my
application's memory usage but I still do not understand why the bss
section is reported under the [heap] section.

Ronny
