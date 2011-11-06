Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574Ab1KFK1W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 05:27:22 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33655 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab1KFK1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 05:27:20 -0500
MIME-Version: 1.0
Date: Sun, 6 Nov 2011 11:27:20 +0100
X-Google-Sender-Auth: 6M6Nqwfa6K0Skws9lY5kpqWCGb0
Message-ID: <CAB1b2sjW94L3wm5KPRQDacu9dxoD+1LCoX+4m8O2OSNWp-+n0w@mail.gmail.com>
Subject: ttyS0 stuck in tty_wait_until_sent when sending break (opened with O_NONBLOCK)
From: Domen Puncer <domen@cba.si>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

I'm not able to create a simple program, that would reproduce this
problem, but calling OW_init()
from libowcapi and with nothing plugged into serial seems to always do
the trick.

$ cat /proc/`pidof test`/wchan; echo
tty_wait_until_sent

$ uname -a
Linux river 3.0-ARCH #1 SMP PREEMPT Wed Oct 19 10:27:51 CEST 2011
x86_64 Intel(R) Core(TM)2 Duo CPU E6750 @ 2.66GHz GenuineIntel
GNU/Linux
But I've also seen this on an older mips kernel.

Is there any way I can assist hunting this down?
I'll try harder to make a simple test program, if the strace output
doesn't produce any ideas.


strace output:

open("/dev/ttyS0", O_RDWR|O_NOCTTY|O_NONBLOCK) = 3
ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or
TCGETS, {B115200 -opost -isig -icanon -echo ...}) = 0
ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or
TCGETS, {B115200 -opost -isig -icanon -echo ...}) = 0
ioctl(3, SNDCTL_TMR_CONTINUE or SNDRV_TIMER_IOCTL_GPARAMS or TCSETSF,
{B9600 -opost -isig -icanon -echo ...}) = 0
ioctl(3, TCFLSH, 0x2)                   = 0
ioctl(3, TCSBRK, 0)                     = 0
select(4, NULL, [3], NULL, {5, 0})      = 1 (out [3], left {4, 999995})
write(3, "\301", 1)                     = 1
ioctl(3, TCSBRK, 0x1)                   = 0
nanosleep({0, 4000000}, 0x7fff2d209ba0) = 0
ioctl(3, TCFLSH, 0x2)                   = 0
select(4, [3], NULL, NULL, {0, 1000})   = 0 (Timeout)
ioctl(3, TCFLSH, 0x2)                   = 0
nanosleep({0, 5000000}, 0x7fff2d209b20) = 0
select(4, NULL, [3], NULL, {5, 0})      = 1 (out [3], left {4, 999998})
write(3, "q", 1)                        = 1
ioctl(3, TCSBRK, 0x1)                   = 0
nanosleep({0, 5000000}, 0x7fff2d209b20) = 0
ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or
TCGETS, {B9600 -opost -isig -icanon -echo ...}) = 0
ioctl(3, SNDCTL_TMR_CONTINUE or SNDRV_TIMER_IOCTL_GPARAMS or TCSETSF,
{B9600 -opost -isig -icanon -echo ...}) = 0
ioctl(3, TCFLSH, 0x2)                   = 0
nanosleep({0, 5000000}, 0x7fff2d209b20) = 0
select(4, [3], NULL, NULL, {0, 1000})   = 0 (Timeout)
select(4, NULL, [3], NULL, {5, 0})      = 1 (out [3], left {4, 999998})
write(3, "\17", 1)                      = 1
ioctl(3, TCSBRK, 0x1)                   = 0
select(4, [3], NULL, NULL, {5, 0})      = 0 (Timeout)
ioctl(3, TCSBRK, 0x1)                   = 0
ioctl(3, TCFLSH, 0x2)                   = 0
select(4, NULL, [3], NULL, {5, 0})      = 1 (out [3], left {4, 999998})
write(3, "\305", 1)                     = 1
ioctl(3, TCSBRK, 0x1)                   = 0
select(4, [3], NULL, NULL, {5, 0})      = 0 (Timeout)
ioctl(3, TCSBRK, 0x1)                   = 0
nanosleep({0, 400000000}, 0x7fff2d209ba0) = 0
ioctl(3, TCFLSH, 0x2)                   = 0
select(4, [3], NULL, NULL, {0, 1000})   = 0 (Timeout)
ioctl(3, TCFLSH, 0x2)                   = 0
nanosleep({0, 5000000}, 0x7fff2d209b20) = 0
select(4, NULL, [3], NULL, {5, 0})      = 1 (out [3], left {4, 999997})
write(3, "q", 1)                        = 1
ioctl(3, TCSBRK, 0x1)                   = 0
nanosleep({0, 5000000}, 0x7fff2d209b20) = 0
ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or
TCGETS, {B9600 -opost -isig -icanon -echo ...}) = 0
ioctl(3, SNDCTL_TMR_CONTINUE or SNDRV_TIMER_IOCTL_GPARAMS or TCSETSF,
{B9600 -opost -isig -icanon -echo ...}) = 0
ioctl(3, TCFLSH, 0x2)                   = 0
nanosleep({0, 5000000}, 0x7fff2d209b20) = 0
select(4, [3], NULL, NULL, {0, 1000})   = 0 (Timeout)
select(4, NULL, [3], NULL, {5, 0})      = 1 (out [3], left {4, 999998})
write(3, "\17", 1)                      = 1
ioctl(3, TCSBRK, 0x1)                   = 0
select(4, [3], NULL, NULL, {5, 0})      = 0 (Timeout)
ioctl(3, TCSBRK, 0x1)                   = 0
ioctl(3, TCFLSH, 0x2)                   = 0
select(4, NULL, [3], NULL, {5, 0})      = 1 (out [3], left {4, 999998})
write(3, "\305", 1)                     = 1
ioctl(3, TCSBRK, 0x1)                   = 0
select(4, [3], NULL, NULL, {5, 0})      = 0 (Timeout)
ioctl(3, TCSBRK, 0x1)                   = 0
nanosleep({0, 4000000}, 0x7fff2d209ba0) = 0
select(4, NULL, [3], NULL, {5, 0})      = 1 (out [3], left {4, 999997})
write(3, "E", 1)                        = 1
ioctl(3, TCSBRK, 0x1)                   = 0
select(4, [3], NULL, NULL, {5, 0})      = 0 (Timeout)
ioctl(3, TCSBRK, 0x1)                   = 0
close(3)                                = 0
open("/dev/ttyS0", O_RDWR|O_NOCTTY|O_NONBLOCK) = 3
ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or
TCGETS, {B9600 -opost -isig -icanon -echo ...}) = 0
ioctl(3, SNDCTL_TMR_CONTINUE or SNDRV_TIMER_IOCTL_GPARAMS or TCSETSF,
{B9600 -opost -isig -icanon -echo ...}) = 0
ioctl(3, TCFLSH, 0x2)                   = 0
ioctl(3, TCSBRK, 0)                     = 0
select(4, NULL, [3], NULL, {5, 0})      = 1 (out [3], left {4, 999996})
write(3, "\301", 1)                     = 1
ioctl(3, TCSBRK, 0x1)                   = 0
nanosleep({0, 4000000}, 0x7fff2d209ba0) = 0
ioctl(3, TCFLSH, 0x2)                   = 0
select(4, [3], NULL, NULL, {0, 1000})   = 0 (Timeout)
ioctl(3, TCFLSH, 0x2)                   = 0
nanosleep({0, 5000000}, 0x7fff2d209b20) = 0
select(4, NULL, [3], NULL, {5, 0})      = 1 (out [3], left {4, 999998})
write(3, "q", 1)                        = 1
ioctl(3, TCSBRK, 0x1)                   = 0
nanosleep({0, 5000000}, 0x7fff2d209b20) = 0
ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or
TCGETS, {B9600 -opost -isig -icanon -echo ...}) = 0
ioctl(3, SNDCTL_TMR_CONTINUE or SNDRV_TIMER_IOCTL_GPARAMS or TCSETSF,
{B9600 -opost -isig -icanon -echo ...}) = 0
ioctl(3, TCFLSH, 0x2)                   = 0
nanosleep({0, 5000000}, 0x7fff2d209b20) = 0
select(4, [3], NULL, NULL, {0, 1000})   = 0 (Timeout)
select(4, NULL, [3], NULL, {5, 0})      = 1 (out [3], left {4, 999998})
write(3, "\17", 1)                      = 1
ioctl(3, TCSBRK, 0x1)                   = 0
select(4, [3], NULL, NULL, {5, 0})      = 0 (Timeout)
ioctl(3, TCSBRK, 0x1)                   = 0
ioctl(3, TCFLSH, 0x2)                   = 0
select(4, NULL, [3], NULL, {5, 0})      = 1 (out [3], left {4, 999998})
write(3, "\305", 1)                     = 1
ioctl(3, TCSBRK, 0x1)                   = 0
select(4, [3], NULL, NULL, {5, 0})      = 0 (Timeout)
ioctl(3, TCSBRK, 0x1)                   = 0
nanosleep({0, 400000000}, 0x7fff2d209ba0) = 0
ioctl(3, TCFLSH, 0x2)                   = 0
select(4, [3], NULL, NULL, {0, 1000})   = 0 (Timeout)
ioctl(3, TCFLSH, 0x2)                   = 0
nanosleep({0, 5000000}, 0x7fff2d209b20) = 0
select(4, NULL, [3], NULL, {5, 0})      = 1 (out [3], left {4, 999997})
write(3, "q", 1)                        = 1
ioctl(3, TCSBRK, 0x1)                   = 0
nanosleep({0, 5000000}, 0x7fff2d209b20) = 0
ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or
TCGETS, {B9600 -opost -isig -icanon -echo ...}) = 0
ioctl(3, SNDCTL_TMR_CONTINUE or SNDRV_TIMER_IOCTL_GPARAMS or TCSETSF,
{B9600 -opost -isig -icanon -echo ...}) = 0
ioctl(3, TCFLSH, 0x2)                   = 0
nanosleep({0, 5000000}, 0x7fff2d209b20) = 0
select(4, [3], NULL, NULL, {0, 1000})   = 0 (Timeout)
select(4, NULL, [3], NULL, {5, 0})      = 1 (out [3], left {4, 999998})
write(3, "\17", 1)                      = 1
ioctl(3, TCSBRK, 0x1)                   = 0
select(4, [3], NULL, NULL, {5, 0})      = 0 (Timeout)
ioctl(3, TCSBRK, 0x1)                   = 0
ioctl(3, TCFLSH, 0x2)                   = 0
select(4, NULL, [3], NULL, {5, 0})      = 1 (out [3], left {4, 999997})
write(3, "\305", 1)                     = 1
ioctl(3, TCSBRK, 0x1)                   = 0
select(4, [3], NULL, NULL, {5, 0})      = 0 (Timeout)
ioctl(3, TCSBRK, 0x1)                   = 0
nanosleep({0, 4000000}, 0x7fff2d209ba0) = 0
select(4, NULL, [3], NULL, {5, 0})      = 1 (out [3], left {4, 999995})
write(3, "E", 1)                        = 1
ioctl(3, TCSBRK, 0x1)                   = 0
select(4, [3], NULL, NULL, {5, 0})      = 0 (Timeout)
ioctl(3, TCSBRK, 0x1)                   = 0
close(3)                                = 0
open("/dev/ttyS0", O_RDWR|O_NOCTTY|O_NONBLOCK) = 3
ioctl(3, SNDCTL_TMR_TIMEBASE or SNDRV_TIMER_IOCTL_NEXT_DEVICE or
TCGETS, {B9600 -opost -isig -icanon -echo ...}) = 0
ioctl(3, SNDCTL_TMR_CONTINUE or SNDRV_TIMER_IOCTL_GPARAMS or TCSETSF,
{B9600 -opost -isig -icanon -echo ...}) = 0
ioctl(3, TCFLSH, 0x2)                   = 0
ioctl(3, TCSBRK, 0)                     = 0
select(4, NULL, [3], NULL, {5, 0})      = 1 (out [3], left {4, 999997})
write(3, "\301", 1)                     = 1
ioctl(3, TCSBRK <unfinished ...>
