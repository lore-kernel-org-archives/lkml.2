Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab2K3CCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 21:02:33 -0500
Received: from [201.191.100.135] ([201.191.100.135]:44314 "EHLO
	bruno.wildbear.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755042Ab2K3CCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 21:02:32 -0500
Date: Thu, 29 Nov 2012 20:02:29 -0600 (CST)
From: Joseph Parmelee <jparmele@wildbear.com>
X-X-Sender: jparmele@bruno
To: Andi Kleen <andi@firstfloor.org>
cc: linux-kernel@vger.kernel.org
Subject: Re: Binutils test suite freezes kernel
In-Reply-To: <m2k3t4f9uq.fsf@firstfloor.org>
Message-ID: <alpine.LNX.2.00.1211291958280.8027@bruno>
References: <alpine.LNX.2.00.1211071634440.1754@bruno> <m2k3t4f9uq.fsf@firstfloor.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




On Thu, 29 Nov 2012, Andi Kleen wrote:

> Joseph Parmelee <jparmele@wildbear.com> writes:
>
>> Greetings:
>>
>> The gas test suite in recent binutils snapshots from
>> ftp://sourceware.org/pub/binutils/snapshots/ consistently freezes my i386
>> custom-built kernels.  This may be a kernel configuration problem but if so
>> it has manifested only recently.  I have been building kernels since 1995
>> and this is the first instance I have seen where the kernel is brought down
>> by a non-privileged user space process.  AIUI this should be impossible
>> regardless of what that process is doing.  The problem affects all kernels
>> between 3.6.2 and 3.6.6.  These are merely the kernels were I have seen the
>> problem; it may well affect other kernels.
>
> A common cause of this would be running out of memory.
> While this should eventually resolve itself it may take a long time
> and the system may appear frozen.
>
> I would rerun with an appropiate ulimit setting.
>
> -Andi
>
> -- 
> ak@linux.intel.com -- Speaking for myself only
>

I appreciate your response but there is no ulimit on memory usage defined
and this system has 1 gb of RAM and 10 gb of swap.

The offending test is assembly of rept.s in the gas testsuite which
generates a labeled data segment of about 55 MB containing all zeroes.  This
is far less than the memory available.  Running just this assembly by itself
with the gas in the snapshot will freeze the system.  This is probably the
kswapd problem being discussed now on the mailing list.

At the time I posted I was unaware that I also had a hardware problem with
one of the SATA controllers probably induced by lightning which did other
damage in October.  I have since fixed that issue which gets rid of the bad
blocks and the reconstruction failures.  But the reconstruction is still
occurring because the system is still freezing under the md layer with the
swap array often in an inconsistent state.

With the latest changes in 3.6.8 I can sometimes run the test once without
failures.  But repeating the test has so far always resulted in a system
freeze with swap reconstruction usually (but not always) occurring on
reboot.  At one point I left it for 30 minutes before using sysreq to sync,
unmount, and reboot to be sure that it is really frozen.  This certainly
sounds like an infinite loop in kswapd as described by others.

Because this machine is in use for other purposes I am unable to run very
many such tests, so I will wait to see what patches the developers produce
and test some more after upgrading to the next "stable" kernel.  I will
squawk to the list again if the fix doesn't work for me.

Thanks for your interest.

Joseph

