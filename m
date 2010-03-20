Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752756Ab0CTBWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 21:22:23 -0400
Received: from qw-out-2122.google.com ([74.125.92.25]:28867 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365Ab0CTBWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 21:22:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=u+V+WChF9Qqx/AqpJcpM0ojDOc/IBFxSglSa5Kl0rPlbHn3WFtW/xCjDSj5yUgpi3M
         74EgLBOa620FaMYesMIGZfTlqmqGMpPm3J2l7HLThuZJmUeVMEe3WM1H6JnUGOzyZ+KM
         rwMAj0mV/b8gY4q2VDJbSfNO9zG3Cnizc0630=
Message-ID: <4BA42345.3080703@gmail.com>
Date: Sat, 20 Mar 2010 12:22:13 +1100
From: Graeme Russ <graeme.russ@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Fixed] x86 - Boot hangs at Calibrating delay loop on AMD SC520
References: <4BA0CE4B.90508@gmail.com>
In-Reply-To: <4BA0CE4B.90508@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Graeme Russ wrote:
> 
> During boot I was getting a warning at arch/x86/kernel/rtc.c:125 and the
> kernel hung at Calibrating delay loop... Also, all boot messages have a
> zero time-stamp.
> 

> I have tried with and without the AMD Elan Extended (non-PC) x86 platform
> 

I tracked down the problem - The SC520 has allows interrupts sources to be
routed to practically any IRQ (it even has a third interrupt controller
providing more IRQ lines). I have been using the more advanced programmable
timer available in the SC520 and had routed its interrupt output to IRQ0.
There are a few other timer and interrupt related configurations which also
need to be set 'just right' as well. Basically, you need to make the SC520
fully PC/AT compatible for Linux to work. I'll be posting all my
development work onto the U-Boot mailing list, so you should be able to use
to the U-Boot source for future reference.

I know have a fully functional boot loader and Linux kernel to the point of
looking for /sbin/init - Now to create a JFSS2 file system and get a fully
functional GNU/Linux system up and running.

I just want to say a huge thanks to all the Linux Kernel developers for
their generous donations of time, knowledge and skill such that others like
myself can learn. You are the real drivers of innovation, not just because
you come up with new ideas, but you allow everyone the _see_ how those
ideas are implemented - This gives us all the tools to realise our own ideas.

Thanks,

Graeme
