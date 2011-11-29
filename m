Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab1K2LHR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 06:07:17 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:38753 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab1K2LHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 06:07:13 -0500
Message-ID: <4ED4BCD5.3090308@linux.vnet.ibm.com>
Date: Tue, 29 Nov 2011 16:37:01 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Thunderbird/3.1.15
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Andi Kleen <andi@firstfloor.org>
CC: Nicolas Kalkhof <nkalkhof@web.de>, linux-kernel@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: Too many poll_idle cpu calls in kernel 3.2 rc-series
References: <492649473.3864850.1322512273580.JavaMail.fmail@mwmweb020> <20111128204412.GM24062@one.firstfloor.org>
In-Reply-To: <20111128204412.GM24062@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11112911-2674-0000-0000-000001E90536
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2011 02:14 AM, Andi Kleen wrote:

> On Mon, Nov 28, 2011 at 09:31:13PM +0100, Nicolas Kalkhof wrote:
>> Andi,
>>
>> correct. The issue was introduced somewhere between 3.1 final and 3.2-rc1. I've tried to track down the bad commit but so far I haven't been successfull. The only workaround I found is to set the idle boot parameter to mwait and to disable CONFIG_INTEL_IDLE. Somehow the kernel seems to set idle to poll by default - no idea why :-(. I wonder if other mobile sandy bridge cpus are affected as well.
> 
> There are only a few changesets affecting drivers/idle
> 
> Can you try to git revert 
> 
> 46bcfad7a819bd17ac4e831b04405152d59784ab
> 4202735e8ab6ecfb0381631a0d0b58fefe0bd4e2
> e978aa7d7d57d04eb5f88a7507c4fb98577def77
> 
> ?
> 
> -Andi


Hi,

I am guessing that for workaround just setting the idle boot parameter
to mwait should work. Have u tested this without disabling
CONFIG_INTEL_IDLE ?

Also one thing to note from your logs is, cpu is not entering any of the
other C states except for POLL. Can you also check if your are enabling
only POLL for idle. I am able to enter deeper C-states on i5-2540M with
Intel_Idle enabled.

Power top o/p:
-------------

            Core    |             CPU 0               CPU 1
POLL        0.0%    | POLL        0.0%    0.0 ms      0.0%    0.0 ms
C1-SNB      1.4%    | C1-SNB      2.2%    0.7 ms      0.5%    0.9 ms
C3-SNB      0.9%    | C3-SNB      1.6%    1.2 ms      0.1%    1.2 ms
C6-SNB      0.2%    | C6-SNB      0.3%    1.6 ms      0.0%    0.9 ms
C7-SNB     95.8%    | C7-SNB     93.7%    3.7 ms     97.8%   15.1 ms


Regards,
Deepthi

