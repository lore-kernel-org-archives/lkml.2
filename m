Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737Ab2GWTv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 15:51:59 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:58837 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210Ab2GWTv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 15:51:58 -0400
Message-ID: <500DAB3F.30606@us.ibm.com>
Date: Mon, 23 Jul 2012 12:51:27 -0700
From: John Stultz <johnstul@us.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
CC: stable@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] 3.2-stable: Fix for leapsecond caused hrtimer/futex
 issue
References: <1342508724-14527-1-git-send-email-johnstul@us.ibm.com> <50050FD9.3070403@us.ibm.com> <1342730535@msgid.manchmal.in-ulm.de>
In-Reply-To: <1342730535@msgid.manchmal.in-ulm.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072319-5806-0000-0000-0000179761DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2012 01:48 PM, Christoph Biedl wrote:
> John Stultz wrote...
>
>> Attached is the test case I used to reproduce and test the solution
>> to the hard-hang deadlock.
> I was wondering whether anybody managed to crash a virtualbox guest
> using your program. No avail, using version 4.1.18 on the host and the
> guest kernel running several 3.0.x (x < 38) kernels on both x32 and
> x64, the guest utilies were stopped. Rather a fun fact I guess but I
> wanted to let you know.

I've been able to crash a kvm guest with an unpatched kernel with my 
test.  The issue requires that the adding of the hrtimer causes the 
clockevent to be reprogrammed. This usually happens if there's no timers 
that expire sooner then the leapsecond timer. So if there are drivers 
that set frequent timers, or set timers right before the leapsecond, it 
may be difficult to trigger this issue.

Lowering HZ or adding more vcpus might help if you really want to be 
able to trigger the issue.


> All real hardware tested, including a dockstar on armel, crashed as
> predicted, while 3.0.38-rc1 was immune.
Great to hear!

thanks
-john

