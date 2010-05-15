Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab0EOTLx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 15:11:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:58800 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab0EOTLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 15:11:52 -0400
Date: Sat, 15 May 2010 12:14:24 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Andi Kleen <andi@firstfloor.org>, Venkatesh Pallipadi <venki@google.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
Message-ID: <20100515121424.38f5b389@infradead.org>
In-Reply-To: <35aa841b-e151-424d-b1c1-0c03dbcae5cc@default>
References: <1273887635-27610-1-git-send-email-venki@google.com
 87tyq9mqrz.fsf@basil.nowhere.org>
	<35aa841b-e151-424d-b1c1-0c03dbcae5cc@default>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 May 2010 06:29:25 -0700 (PDT)
Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> > It would be better to fix them to use the vsyscalls instead.
> > Or if they can't use the vsyscalls for some reason today fix them.
> 
> The problem is from an app point-of-view there is no vsyscall.
> There are two syscalls: gettimeofday and clock_gettime.  Sometimes,
> if it gets lucky, they turn out to be very fast and sometimes
> it doesn't get lucky and they are VERY slow (resulting in a
> performance hit of 10% or more), depending on a number of factors
> completely out of the control of the app and even undetectable to the
> app.

But the point is.. in the case you get that 10% hit.... that is exactly
the case where tsc would not work either!!!
>

> If tsc_reliable is 1, the system and the kernel are guaranteeing
> to the app that nothing will change in the TSC.  In an Invariant
> TSC system that has passed Ingo's warp test (to eliminate the
> possibility of a fixed interprocessor TSC gap due to a broken BIOS
> in a multi-node NUMA system), if anything changes in the clock

just when we're trying to get rid of this constraint by allowing a per
cpu offset... (this is needed to cope with cpus not powering on at the
exact same time... including hotplug cpu etc etc)


oh and.. what notification mechanism do you have to notify the
application that the tsc now is no longer reliable? Such conditions
can exist... for example due to a CPU being hotplugged, or some SMM
screwing around and the kernel detecting that or .. or ...


really. Use the vsyscall. If the vsyscall does not do exactly what you
want, make a better vsyscall. 

But friends don't let friends use rdtsc in application code.




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
