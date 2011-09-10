Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607Ab1IJRR7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 13:17:59 -0400
Received: from christianhoffmann.info ([88.175.101.52]:44602 "EHLO
	christianhoffmann.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933553Ab1IJRR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 13:17:59 -0400
Message-ID: <4E6B9BC1.4060000@christianhoffmann.info>
Date: Sat, 10 Sep 2011 19:17:53 +0200
From: Christian Hoffmann <email@christianhoffmann.info>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Josh Boyer <jwboyer@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: scheduling while atomic: swapper/0/0x10000002
References: <4E6B6624.1000406@christianhoffmann.info> <CA+5PVA4nRVN0cia9R49=T5xy1inxQLSjDcv1yn4+UFppufRiYA@mail.gmail.com>
In-Reply-To: <CA+5PVA4nRVN0cia9R49=T5xy1inxQLSjDcv1yn4+UFppufRiYA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2011 06:44 PM, Josh Boyer wrote:
> On Sat, Sep 10, 2011 at 9:29 AM, Christian Hoffmann
> <email@christianhoffmann.info>  wrote:
>> Hi,
>>
>> I can see the following bug report in the kernel 3.1 rc5 dmesg:
>>
>> [    0.000008] BUG: scheduling while atomic: swapper/0/0x10000002
>> [    0.000012] Modules linked in:
>> [    0.000015] Pid: 0, comm: swapper Not tainted 3.1.0-rc5-ch+ #2
>> [    0.000017] Call Trace:
>> [    0.000024]  [<ffffffff81052cb6>] __schedule_bug+0x66/0x70
>> [    0.000028]  [<ffffffff8160329d>] schedule+0x99d/0x9b0
>> [    0.000032]  [<ffffffff81cf22b5>] ? pidmap_init+0x9f/0xdf
>> [    0.000035]  [<ffffffff8105cc7a>] __cond_resched+0x2a/0x40
>> [    0.000038]  [<ffffffff81603541>] _cond_resched+0x31/0x40
>> [    0.000041]  [<ffffffff8115fb63>] kmem_cache_alloc_trace+0x53/0x160
>> [    0.000043]  [<ffffffff81cf22b5>] pidmap_init+0x9f/0xdf
>> [    0.000046]  [<ffffffff81cd9b8a>] start_kernel+0x333/0x3c8
>> [    0.000049]  [<ffffffff81cd9347>] x86_64_start_reservations+0x132/0x136
>> [    0.000051]  [<ffffffff81cd944c>] x86_64_start_kernel+0x101/0x110
>
> Paul McKenney has a patch that solves this oops.  You can find it here:
>
> http://marc.info/?l=linux-kernel&m=131537669921538&w=2
>
> We had discussed getting this into 3.1, but apparently that didn't
> happen (yet?).  I thought it had been sent upstream with my tested-by,
> but I don't see it included in Linus' tree.

Hi,

the patch up there doesn't seem to apply cleanly to 3.1 rc5, as it 
misses the rename done in "[PATCH tip/core/rcu 23/55] rcu: Simplify 
quiescent-state accounting" 
(http://marc.info/?l=linux-kernel&m=131537654621392&w=2).

Kind regards,
Chris
