Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab2GQSVm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 14:21:42 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:41133 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab2GQSVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 14:21:39 -0400
Message-ID: <5005AD06.8080403@us.ibm.com>
Date: Tue, 17 Jul 2012 11:20:54 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: stable@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] 3.0-stable: Fix for leapsecond deadlock & hrtimer/futex
 issue
References: <1342546438-17534-1-git-send-email-johnstul@us.ibm.com> <20120717175741.GA3665@1wt.eu> <5005ABC2.8050006@us.ibm.com>
In-Reply-To: <5005ABC2.8050006@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12071718-2398-0000-0000-000008931720
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2012 11:15 AM, John Stultz wrote:
> On 07/17/2012 10:57 AM, Willy Tarreau wrote:
>> Hi John,
>>
>> On Tue, Jul 17, 2012 at 01:33:47PM -0400, John Stultz wrote:
>>> I've already done backports to all the stable kernels to 2.6.32, and
>>> will send out the rest soon.
>> That's very much appreciated, thank you! Do not hesitate to send me
>> your reproducers, I'll happily run some tests.
>
> Attached are two tests. One is general exerciser of the leapsecond 
> code (leap-a-day) which also notes if it sees the hrtimer/futuex early 
> expiration issue, and the other is a much faster (almost immediate) 
> reproducer for the leapsecond deadlock (leapcrash).
>
> The leapcrash test will likely wedge unpatched systems in hardirq 
> context, and has caused lost (dirty) data in my testing, so BEWARE!
> RUN AT YOUR OWN RISK!
>
> And of course, the leap-a-day has the same potential, but doesn't 
> tickle the deadlock issue as aggressively.

As a tangent, I'm looking to try to get these tests integrated with a 
testing suite that developers, distros and other testing organizations 
run regularly.  I'm aware of LTP, however last I looked at it, it seems 
to have become a bit messy, being somewhat of a catch all, and in casual 
asking around not too many folks I know regularly use it (Is that no 
longer the case?).

Are there any other test suites that folks would recommend I look into 
for merging these (and other time related) tests?

thanks
-john


