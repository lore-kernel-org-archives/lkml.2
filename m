Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361Ab0EGCka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 22:40:30 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:59694 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab0EGCk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 22:40:29 -0400
Message-ID: <4BE37D98.3000001@linux.vnet.ibm.com>
Date: Thu, 06 May 2010 19:40:24 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Carl Love <carll@us.ibm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       stephane eranian <eranian@googlemail.com>
Subject: Re: [BUG] perf_events: PERF_FORMAT_GROUP not working correctly when
 monitoring another task
References: <4BDF8118.3090200@linux.vnet.ibm.com> <1273160566.5605.404.camel@twins>  <4BE321F8.1050309@linux.vnet.ibm.com> <1273177360.1642.280.camel@laptop>
In-Reply-To: <1273177360.1642.280.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2010 01:22 PM, Peter Zijlstra wrote:
> On Thu, 2010-05-06 at 13:09 -0700, Corey Ashford wrote:
>> The patch works with the test case I provided, but for some reason it
>> breaks the normal operation of the libpfm4 "task" utility.  If I put
>> more than one event in a group, I get zero counts on all but the first
>> event.  That's even if I don't use the PERF_FORMAT_GROUP option.
>
> Bugger,.. weird though, I can't see how it would affect the state before
> the counters get detached from their context (exit() / close()).
>
>> So something appears to be messed up.  I will see if I can construct an
>> arch-independent test case which demonstrates the problem.
>
> That would be awesome, thanks!
>

Ok, it was pilot error.  We had made a few changes to the "task" program 
to expand its capabilities and introduced a couple of bugs at the same time.

Unfortunately, I have one remaining mystery.  The default behavior of 
task is to create groups, without the PERF_FORMAT_GROUP flag set, and 
then read up the counts and time enabled/running values for each counter 
in the group after the measurement has occurred.

Well, for some reason I haven't been able to figure out, all but first 
event in the group have their time running and time enable values set to 
zero, but their counts are non-zero.

If I replicate this setup with the show_fg_bug test case I posted, the 
time running and enabled values are correct for each counter.

The enabled and running flag bits are set for every event which is 
opened (in both show_fg_bug and task)... so I don't know what the 
difference would be.

If anything springs to mind there as to how I might be getting zero 
enabled/running values passed back from the kernel, I'd be very 
interested to know.

Otherwise, I will keep poking at it till I find the bug in task, or 
something I can point at in the kernel.

Thanks,

- Corey
