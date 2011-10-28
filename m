Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260Ab1J1KJ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 06:09:27 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42424 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab1J1KJ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 06:09:26 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: <vnc-list@realvnc.com>, <linux-kernel@vger.kernel.org>
References: <025301cc9423$8c70a320$a551e960$@lucidpixels.com> <02b001cc9437$43c50800$cb4f1800$@lucidpixels.com>
In-Reply-To: <02b001cc9437$43c50800$cb4f1800$@lucidpixels.com>
Subject: RE: 3.x/libc6 -- out of ideas -- launching chrome results in an immediate crash of Xvnc everytime
Date: Fri, 28 Oct 2011 06:09:13 -0400
Message-ID: <008c01cc9559$a56cca20$f0465e60$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
thread-index: AQC0F+Y4HsGwzo8sF9HRL8dAbXa9PANYaQsHl6e/65A=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I built another machine clean install and the problem is the same (If you
use google sync it syncs your extensions), I am getting closer,but
essentially its an extension in Google Chrome that causes Xvnc/vnc to crash.
I have quite a few extensions so I am trying to narrow it down now.

Justin.

-----Original Message-----
From: Justin Piszcz [mailto:jpiszcz@lucidpixels.com] 
Sent: Wednesday, October 26, 2011 7:31 PM
To: vnc-list@realvnc.com; linux-kernel@vger.kernel.org
Subject: RE: 3.x/libc6 -- out of ideas -- launching chrome results in an
immediate crash of Xvnc everytime

Hi,

It happens with tightvnc too, and more details at crash time:

(gdb) bt
#0  0x00007f04db334405 in raise () from /lib/x86_64-linux-gnu/libc.so.6
#1  0x00007f04db337680 in abort () from /lib/x86_64-linux-gnu/libc.so.6
#2  0x00007f04db36adbb in ?? () from /lib/x86_64-linux-gnu/libc.so.6
#3  0x00007f04db374606 in ?? () from /lib/x86_64-linux-gnu/libc.so.6
#4  0x00007f04db37933c in free () from /lib/x86_64-linux-gnu/libc.so.6
#5  0x0000000000548c9a in miSetShape ()
#6  0x0000000000549eef in ?? ()
#7  0x000000000054a13e in ?? ()
#8  0x000000000043c157 in Dispatch ()
#9  0x000000000042259b in main ()
(gdb)

--

Any thoughts on this??
Cannot use VNC, cannot use tightvnc :(

--

$ /usr/bin/tightvncserver :1 -geometry 1920x1200

--

user@p34:~$ *** glibc detected *** Xtightvnc: free(): invalid pointer:
0x00007f04db681e60 ***
======= Backtrace: =========
/lib/x86_64-linux-gnu/libc.so.6(+0x72606)[0x7f04db374606]
/lib/x86_64-linux-gnu/libc.so.6(cfree+0x6c)[0x7f04db37933c]
Xtightvnc(miSetShape+0x2ba)[0x548c9a]
Xtightvnc[0x549eef]
Xtightvnc[0x54a13e]
Xtightvnc(Dispatch+0x167)[0x43c157]
Xtightvnc(main+0x7eb)[0x42259b]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xfd)[0x7f04db320ead]
Xtightvnc[0x421c89]
======= Memory map: ========
00400000-00582000 r-xp 00000000 08:22 1453767 /usr/bin/Xtightvnc
00782000-00795000 rw-p 00182000 08:22 1453767 /usr/bin/Xtightvnc
00795000-007b8000 rw-p 00000000 00:00 0
01d14000-02751000 rw-p 00000000 00:00 0
[heap]
7f04d4000000-7f04d4021000 rw-p 00000000 00:00 0
7f04d4021000-7f04d8000000 ---p 00000000 00:00 0
7f04d96bf000-7f04d96d4000 r-xp 00000000 08:22 3673919
/lib/x86_64-linux-gnu/libgcc_s.so.1
7f04d96d4000-7f04d98d4000 ---p 00015000 08:22 3673919
/lib/x86_64-linux-gnu/libgcc_s.so.1
7f04d98d4000-7f04d98d5000 rw-p 00015000 08:22 3673919
/lib/x86_64-linux-gnu/libgcc_s.so.1
7f04d98d5000-7f04d98e0000 r-xp 00000000 08:22 3676132
/lib/x86_64-linux-gnu/libnss_files-2.13.so
7f04d98e0000-7f04d9adf000 ---p 0000b000 08:22 3676132
/lib/x86_64-linux-gnu/libnss_files-2.13.so
7f04d9adf000-7f04d9ae0000 r--p 0000a000 08:22 3676132
/lib/x86_64-linux-gnu/libnss_files-2.13.so
7f04d9ae0000-7f04d9ae1000 rw-p 0000b000 08:22 3676132
/lib/x86_64-linux-gnu/libnss_files-2.13.so
7f04d9ae1000-7f04d9aeb000 r-xp 00000000 08:22 3676007
/lib/x86_64-linux-gnu/libnss_nis-2.13.so
7f04d9aeb000-7f04d9cea000 ---p 0000a000 08:22 3676007
/lib/x86_64-linux-gnu/libnss_nis-2.13.so
7f04d9cea000-7f04d9ceb000 r--p 00009000 08:22 3676007
/lib/x86_64-linux-gnu/libnss_nis-2.13.so
7f04d9ceb000-7f04d9cec000 rw-p 0000a000 08:22 3676007
/lib/x86_64-linux-gnu/libnss_nis-2.13.so
7f04d9cec000-7f04d9d01000 r-xp 00000000 08:22 3676005
/lib/x86_64-linux-gnu/libnsl-2.13.so
7f04d9d01000-7f04d9f00000 ---p 00015000 08:22 3676005
/lib/x86_64-linux-gnu/libnsl-2.13.so
7f04d9f00000-7f04d9f01000 r--p 00014000 08:22 3676005
/lib/x86_64-linux-gnu/libnsl-2.13.so
7f04d9f01000-7f04d9f02000 rw-p 00015000 08:22 3676005
/lib/x86_64-linux-gnu/libnsl-2.13.so
7f04d9f02000-7f04d9f04000 rw-p 00000000 00:00 0
7f04d9f04000-7f04d9f0b000 r-xp 00000000 08:22 3675998
/lib/x86_64-linux-gnu/libnss_compat-2.13.so
7f04d9f0b000-7f04da10a000 ---p 00007000 08:22 3675998
/lib/x86_64-linux-gnu/libnss_compat-2.13.so
7f04da10a000-7f04da10b000 r--p 00006000 08:22 3675998
/lib/x86_64-linux-gnu/libnss_compat-2.13.so
7f04da10b000-7f04da10c000 rw-p 00007000 08:22 3675998
/lib/x86_64-linux-gnu/libnss_compat-2.13.so
7f04da10c000-7f04da16c000 rw-s 00000000 00:04 7864330
/SYSV00000000 (deleted)
7f04da16c000-7f04db302000 rw-p 00000000 00:00 0
7f04db302000-7f04db47c000 r-xp 00000000 08:22 3675991
/lib/x86_64-linux-gnu/libc-2.13.so
7f04db47c000-7f04db67c000 ---p 0017a000 08:22 3675991
/lib/x86_64-linux-gnu/libc-2.13.so
7f04db67c000-7f04db680000 r--p 0017a000 08:22 3675991
/lib/x86_64-linux-gnu/libc-2.13.so
7f04db680000-7f04db681000 rw-p 0017e000 08:22 3675991
/lib/x86_64-linux-gnu/libc-2.13.so
7f04db681000-7f04db686000 rw-p 00000000 00:00 0
7f04db686000-7f04db68e000 r-xp 00000000 08:22 3675995
/lib/x86_64-linux-gnu/libcrypt-2.13.so
7f04db68e000-7f04db88d000 ---p 00008000 08:22 3675995
/lib/x86_64-linux-gnu/libcrypt-2.13.so
7f04db88d000-7f04db88e000 r--p 00007000 08:22 3675995
/lib/x86_64-linux-gnu/libcrypt-2.13.so
7f04db88e000-7f04db88f000 rw-p 00008000 08:22 3675995
/lib/x86_64-linux-gnu/libcrypt-2.13.so
7f04db88f000-7f04db8bd000 rw-p 00000000 00:00 0
7f04db8bd000-7f04db8e1000 r-xp 00000000 08:22 1445921
/usr/lib/libjpeg.so.62.0.0
7f04db8e1000-7f04dbae0000 ---p 00024000 08:22 1445921
/usr/lib/libjpeg.so.62.0.0
7f04dbae0000-7f04dbae1000 rw-p 00023000 08:22 1445921
/usr/lib/libjpeg.so.62.0.0
7f04dbae1000-7f04dbae3000 r-xp 00000000 08:22 3676009
/lib/x86_64-linux-gnu/libdl-2.13.so
7f04dbae3000-7f04dbce3000 ---p 00002000 08:22 3676009
/lib/x86_64-linux-gnu/libdl-2.13.so
7f04dbce3000-7f04dbce4000 r--p 00002000 08:22 3676009
/lib/x86_64-linux-gnu/libdl-2.13.so
7f04dbce4000-7f04dbce5000 rw-p 00003000 08:22 3676009
/lib/x86_64-linux-gnu/libdl-2.13.so
7f04dbce5000-7f04dbd66000 r-xp 00000000 08:22 3676000
/lib/x86_64-linux-gnu/libm-2.13.so
7f04dbd66000-7f04dbf65000 ---p 00081000 08:22 3676000
/lib/x86_64-linux-gnu/libm-2.13.so
7f04dbf65000-7f04dbf66000 r--p 00080000 08:22 3676000
/lib/x86_64-linux-gnu/libm-2.13.so
7f04dbf66000-7f04dbf67000 rw-p 00081000 08:22 3676000
/lib/x86_64-linux-gnu/libm-2.13.so
7f04dbf67000-7f04dbf7e000 r-xp 00000000 08:22 1444016
/usr/lib/libz.so.1.2.3.4
7f04dbf7e000-7f04dc17d000 ---p 00017000 08:22 1444016
/usr/lib/libz.so.1.2.3.4
7f04dc17d000-7f04dc17e000 rw-p 00016000 08:22 1444016
/usr/lib/libz.so.1.2.3.4
7f04dc17e000-7f04dc19d000 r-xp 00000000 08:22 3677025
/lib/x86_64-linux-gnu/ld-2.13.so
7f04dc25a000-7f04dc2ba000 rw-s 00000000 00:04 7929868
/SYSV00000000 (deleted)
7f04dc2ba000-7f04dc31a000 rw-s 00000000 00:04 7897099
/SYSV00000000 (deleted)
7f04dc31a000-7f04dc37a000 rw-s 00000000 00:04 7831561
/SYSV00000000 (deleted)
7f04dc37a000-7f04dc37f000 rw-p 00000000 00:00 0
7f04dc39b000-7f04dc39d000 rw-p 00000000 00:00 0
7f04dc39d000-7f04dc39e000 r--p 0001f000 08:22 3677025
/lib/x86_64-linux-gnu/ld-2.13.so
7f04dc39e000-7f04dc39f000 rw-p 00020000 08:22 3677025
/lib/x86_64-linux-gnu/ld-2.13.so
7f04dc39f000-7f04dc3a0000 rw-p 00000000 00:00 0
7fffc7cc0000-7fffc7ce1000 rw-p 00000000 00:00 0 [stack]
7fffc7df3000-7fffc7df4000 r-xp 00000000 00:00 0 [vdso]
ffffffffff600000-ffffffffff601000 r-xp 00000000 00:00 0 [vsyscall]

Justin.


