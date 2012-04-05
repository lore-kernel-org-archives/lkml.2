Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab2DEQXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 12:23:37 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:60530 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab2DEQXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 12:23:36 -0400
Message-ID: <4F7DC6ED.7060508@us.ibm.com>
Date: Thu, 05 Apr 2012 09:23:09 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Prarit Bhargava <prarit@redhat.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Salman Qazi <sqazi@google.com>, stable@kernel.org
Subject: Re: [PATCH] clocksource, prevent overflow in clocksource_cyc2ns
References: <1333552260-1170-1-git-send-email-prarit@redhat.com> <4F7C8C3E.1020203@us.ibm.com> <4F7C9402.3090602@redhat.com> <4F7CF094.5020201@us.ibm.com> <4F7D7B4B.7050203@redhat.com>
In-Reply-To: <4F7D7B4B.7050203@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12040516-5518-0000-0000-00000379B0D7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2012 04:00 AM, Prarit Bhargava wrote:
>
> On 04/04/2012 09:08 PM, John Stultz wrote:
>> So what kernel version are you using?
> I was on an earlier version of Fedora (F16) ... but I'll jump forward and see if
> I can still hit it.

Ok, but if you have the specific kernel version, it would help, since 
even if the issue is resolved upstream, we can see if a backport to 
stable is appropriate.

> Keep in mind that 10000 threads is the *minimum* I was able to cause 
> this with, which is only ~315 threads/cpu, which isn't a lot :/. At 
> that number of threads the dump takes about 6 mins. Doubling it, IIRC, 
> exceeded 10 mins.

At that point, if we're starving the system of interrupts for over 10 
minutes, a number of other non-timekeeping issues can crop up. I've seen 
scsci controllers fall over if their heart-beat checks don't come in, etc.

I suspect if printk dumps taking 10 minutes or more is going to be 
considered "acceptable" behavior, we may need to see about adding some 
breaks in the printk code, so that the system can take a few necessary 
irqs.

thanks
-john


