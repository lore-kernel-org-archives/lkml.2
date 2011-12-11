Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab1LKVWQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 16:22:16 -0500
Received: from eu1sys200aog110.obsmtp.com ([207.126.144.129]:49907 "EHLO
	eu1sys200aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752482Ab1LKVWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 16:22:15 -0500
Date: Mon, 12 Dec 2011 02:51:39 +0530
From: Rabin Vincent <rabin.vincent@stericsson.com>
To: Andreas Friedrich <afrie@gmx.net>
Cc: "john.stultz@linaro.org" <john.stultz@linaro.org>,
        <rtc-linux@googlegroups.com>, <linux-kernel@vger.kernel.org>
Subject: Re: REGRESSION 3.1.5: auto poweron after 5 minutes
Message-ID: <20111211212110.GA8839@bnru05.bnr.st.com>
References: <20111210140908.GA18596@upset.ux.pdb.fsc.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20111210140908.GA18596@upset.ux.pdb.fsc.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CCing the lists)

On Sat, Dec 10, 2011 at 15:09:08 +0100, Andreas Friedrich wrote:
> with kernel 3.1.5 I've got a problem on my Toshiba Tecra notebook:
> 
> After shuting down my system as usual, it powers on automatically
> after about 5 minutes. With kernel 3.1.4 the system stays off.
> 
> After wondering around some time I read something about "ACPI RTC
> wakealarm" and found the description of your fix in the changelog of
> kernel 3.1.5:
> 
>   commit 0cbc008c56f7b4a11ba6fe80e196d7ab322baabf
>   Author: Rabin Vincent <rabin.vincent@stericsson.com>
>   Date:   Tue Nov 22 11:03:14 2011 +0100
> 
>       rtc: Disable the alarm in the hardware
> 
>       commit c0afabd3d553c521e003779c127143ffde55a16f upstream.
> 
>       Currently, the RTC code does not disable the alarm in the hardware.
> 
>       This means that after a sequence such as the one below (the files are in the
>       RTC sysfs), the box will boot up after 2 minutes even though we've
>       asked for the alarm to be turned off.
> 
>           # echo $((`cat since_epoch`)+120) > wakealarm
>           # echo 0 > wakealarm
>           # poweroff
> 
>       Fix this by disabling the alarm when there are no timers to run.
> 
> So may be your fix caused the opposite reaction on my system. Have you
> any ideas to fix this problem?

That patch, in order to disable the alarm, calls set_alarm() on the
RTC driver with alarm->enabled as zero (and a time value that is five
minutes ahead).

Perhaps the ACPI RTC driver enables the alarm even when alarm->enable
is zero?  There appears to be handling for this in rtc-cmos.c (I assume
that's what is being used) but I don't know enough about that hardware
to say if that's sufficient or not.
