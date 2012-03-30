Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760945Ab2C3OMv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 10:12:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:32969 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759684Ab2C3OMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 10:12:44 -0400
Message-ID: <4F75BF5B.7000306@canonical.com>
Date: Fri, 30 Mar 2012 16:12:43 +0200
From: David Henningsson <david.henningsson@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Arun Raghavan <arun.raghavan@collabora.co.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] [RESEND] rlimits: Print more information when limits
 are exceeded
References: <1330025378-26075-1-git-send-email-arun.raghavan@collabora.co.uk> <alpine.LFD.2.02.1203301455360.2542@ionos>
In-Reply-To: <alpine.LFD.2.02.1203301455360.2542@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2012 03:39 PM, Thomas Gleixner wrote:
> On Fri, 24 Feb 2012, Arun Raghavan wrote:
>
>> This dumps some information in logs when a process exceeds its CPU or RT
>> limits (soft and hard). Makes debugging easier when userspace triggers
>> these limits.
>
> Why do we need to spam the logs with such information?
>
> SIGXCPU is only ever sent by this code. If there is a signal handler
> in the application it's easy to debug. If not it's even easier, the
> thing will simply be killed and you get the reason printed.

I'm not totally sure, but don't we log SIGSEGVs? If so, the same 
reasoning would apply to SIGSEGV.

> For the SIGKILL case there only a limited number of reasons why a
> SIGKILL is sent. So no, I rather commit a patch which removes that
> ugly printk which is already there instead of adding more of them.

The reason I proposed some kind of printk for SIGKILL, was to get some 
diagnostic information out of the SIGKILL. E g, if you have two threads 
both running on rtprio rlimits in the same process, it would be very 
interesting to know which one of them was causing the kernel to send 
SIGKILL.

Also, it could be useful to know whether the SIGKILL was actually sent 
by the kernel, or by some other process feeling evil (e g "kill -9").

-- 
David Henningsson, Canonical Ltd.
http://launchpad.net/~diwic
