Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756628Ab2B2JNC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 04:13:02 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43499 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753983Ab2B2JM5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 04:12:57 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of shijie8@gmail.com designates 10.236.184.167 as permitted sender) smtp.mail=shijie8@gmail.com; dkim=pass header.i=shijie8@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330043397.4669.44.camel@jonspc>
References: <1329393691.6830.20.camel@jonspc>
	<1329512682.29051.1.camel@jonspc>
	<1329570128.6670.0.camel@jonspc>
	<4F400BBF.9020707@ladisch.de>
	<1329603022.1089.57.camel@jonspc>
	<4F41FC28.1070605@ladisch.de>
	<1329926198.22918.10.camel@jonspc>
	<4F45167A.6080706@ladisch.de>
	<1330043397.4669.44.camel@jonspc>
Date: Wed, 29 Feb 2012 17:12:56 +0800
Message-ID: <CAMiH66EdB9KN1gw_hG=34zab56RxcPKB7G2MyJALfD_5z1yeVQ@mail.gmail.com>
Subject: Re: Random process lockup on ARM board: alsa-lib-1.0.25, FUTEX_WAIT_PRIVATE
From: Huang Shijie <shijie8@gmail.com>
To: jon@jonshouse.co.uk
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi ,

I meet a similar problem with the latest futex code.

I play the video and the processes will hang at the futex.

BR
Huang Shijie

On Fri, Feb 24, 2012 at 8:29 AM, Jonathan Andrews <jon@jonshouse.co.uk> wrote:
> Using kernel 3.2.5 with alsa-lib 1.0.25, all compiled with generic
> Debian arm-linux-gnueabi toolchain.
>
> arm-linux-gnueabi-gcc (Debian 4.3.2-1.1) 4.3.2
> Was used to build kernel, alsa-lib and application.
>
> Changing gcc version, kernel version or alsa-lib version makes the
> problem worse or better, but ALL versions seem to suffer this problem. I
> have also seen it once on Intel (but only once so far).
>
> Something seeks broken at a lower layer than im using.  I simply don't
> have the skill to debug it.
>
> The hardware is a USB cm109 audio adapter, but the problem seems to show
> on more than this one driver.
>
> The audio application writing to alsa will freezes at random intervals,
> infrequent at the moment, last one was after runtime 20H 37M 29S.  Two
> processes are running, one reading from the sound device and one writing
> to the sound device. I am not using threading or anything very clever
> just generic alsa functions.
>
> This is the only diagnostic I can generate so far as running the
> application under strace slows it to the point it no longer functions
> enough to generate the problem.
>
> ARM / # strace -p 417
> Process 417 attached - interrupt to quit
> futex(0x175734, FUTEX_WAIT_PRIVATE, 2, NULL^C <unfinished ...>
> Process 417 detached
>
> ARM / # uname -a
> Linux (none) 3.2.5 #2 Wed Feb 22 17:11:52 GMT 2012 armv4tl GNU/Linux
> ARM / # uptime
>  22:36:19 up 22:36,  0 users,  load average: 0.15, 0.16, 0.18
> ARM / # cat /proc/cpuinfo
> Processor       : ARM920T rev 0 (v4l)
> BogoMIPS        : 199.06
> Features        : swp half thumb crunch
> CPU implementer : 0x41
> CPU architecture: 4T
> CPU variant     : 0x1
> CPU part        : 0x920
> CPU revision    : 0
>
>
> Any help welcome.
>
> Thanks,
> Jon
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
