Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628Ab1LBToP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 14:44:15 -0500
Received: from e38.co.us.ibm.com ([32.97.110.159]:59533 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851Ab1LBToO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 14:44:14 -0500
Message-ID: <1322855029.21423.170.camel@work-vm>
Subject: Re: System freezes with high network activity
From: john stultz <johnstul@us.ibm.com>
To: Jose Luis Salas <josacar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Jonathan Nieder <jrnieder@gmail.com>
Date: Fri, 02 Dec 2011 11:43:49 -0800
In-Reply-To: <CAJPugqsJgN9ZL3jQAZ+eGKfzxH0PAZonj-36H6PB1cHSpQHqSw@mail.gmail.com>
References: <CAJPugqsJgN9ZL3jQAZ+eGKfzxH0PAZonj-36H6PB1cHSpQHqSw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11120219-5518-0000-0000-000000C4A660
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-02 at 17:44 +0100, Jose Luis Salas wrote:
> Hello there,
> 
> I' ve filled a bug against linux kernel in Debian [1] for the
> linux-kernel-image 2.6.32.
> 
> The problem is that the system freezes ( no complete ) when high
> network activity occurrs, for example copying files over NFS or
> downloading files with Bittorrent.
> 
> When the system is frozen, there is no network connecivity, the
> console freezes ( with top program, for ex. ) until a key from the
> laptop is pressed or when network activity drops. The  network
> throughtput also drops before the freeze.
> 
> I've also realized that clock drifts ( it's frozen too ) when the
> system is frozen.
> 
> This problem didn't occur in Linux kernel 2.6.26 ( from the Lenny
> release ), I think >2.6.26 are affected, but I need to confirm it ( >=
> 2.6.30 are included for sure ).
> 
> After investigating for a while (  tested noapic, noacpi and several
> switches with no luck.) , I've search for a solution and I finally
> found it.  I think that the bug is caused by changes in the
> clocksource between kernels and the powernow-k8 module.
> 
> One time I tested booting the xen-patched the linux kernel and the
> problem dissapeared, the net worked at full speed but there was no cpu
> scaling.
> 
> Now, with recent kernels, I boot the kernel with the
> clocksource=jiffies option and the powersaved daemon to do the
> frequency scaling, the net works al full speed. With acpi_pm and tsc
> options doesn't work neither.

So, could you attach a full dmesg when you're not using
clocksource=jiffies?

Also, when not using clocksource=jiffies, does booting with nohz=off
change the behavior?

thanks
-john


