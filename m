Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300Ab1ILQn1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 12:43:27 -0400
Received: from christianhoffmann.info ([88.175.101.52]:49912 "EHLO
	christianhoffmann.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1ILQn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 12:43:26 -0400
Message-ID: <4E6E36A5.2030702@christianhoffmann.info>
Date: Mon, 12 Sep 2011 18:43:17 +0200
From: Christian Hoffmann <email@christianhoffmann.info>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Lightning/1.0b2 Thunderbird/3.1.13
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Josh Boyer <jwboyer@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: scheduling while atomic: swapper/0/0x10000002
References: <4E6B6624.1000406@christianhoffmann.info> <CA+5PVA4nRVN0cia9R49=T5xy1inxQLSjDcv1yn4+UFppufRiYA@mail.gmail.com> <4E6B9BC1.4060000@christianhoffmann.info> <20110910195820.GC4118@linux.vnet.ibm.com>
In-Reply-To: <20110910195820.GC4118@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2011 09:58 PM, Paul E. McKenney wrote:
> On Sat, Sep 10, 2011 at 07:17:53PM +0200, Christian Hoffmann wrote:
>> On 09/10/2011 06:44 PM, Josh Boyer wrote:
>>> On Sat, Sep 10, 2011 at 9:29 AM, Christian Hoffmann
>>> <email@christianhoffmann.info>   wrote:
>>>> Hi,
>>>>
>>>> I can see the following bug report in the kernel 3.1 rc5 dmesg:
>>>>
>>>> [    0.000008] BUG: scheduling while atomic: swapper/0/0x10000002
>>>> [    0.000012] Modules linked in:
>>>> [    0.000015] Pid: 0, comm: swapper Not tainted 3.1.0-rc5-ch+ #2
>>>> [    0.000017] Call Trace:
>>>> [    0.000024]  [<ffffffff81052cb6>] __schedule_bug+0x66/0x70
>>>> [    0.000028]  [<ffffffff8160329d>] schedule+0x99d/0x9b0
>>>> [    0.000032]  [<ffffffff81cf22b5>] ? pidmap_init+0x9f/0xdf
>>>> [    0.000035]  [<ffffffff8105cc7a>] __cond_resched+0x2a/0x40
>>>> [    0.000038]  [<ffffffff81603541>] _cond_resched+0x31/0x40
>>>> [    0.000041]  [<ffffffff8115fb63>] kmem_cache_alloc_trace+0x53/0x160
>>>> [    0.000043]  [<ffffffff81cf22b5>] pidmap_init+0x9f/0xdf
>>>> [    0.000046]  [<ffffffff81cd9b8a>] start_kernel+0x333/0x3c8
>>>> [    0.000049]  [<ffffffff81cd9347>] x86_64_start_reservations+0x132/0x136
>>>> [    0.000051]  [<ffffffff81cd944c>] x86_64_start_kernel+0x101/0x110
>>>
>>> Paul McKenney has a patch that solves this oops.  You can find it here:
>>>
>>> http://marc.info/?l=linux-kernel&m=131537669921538&w=2
>>>
>>> We had discussed getting this into 3.1, but apparently that didn't
>>> happen (yet?).  I thought it had been sent upstream with my tested-by,
>>> but I don't see it included in Linus' tree.
>>
>> Hi,
>>
>> the patch up there doesn't seem to apply cleanly to 3.1 rc5, as it
>> misses the rename done in "[PATCH tip/core/rcu 23/55] rcu: Simplify
>> quiescent-state accounting"
>> (http://marc.info/?l=linux-kernel&m=131537654621392&w=2).
>
> For 3.1-rc5, you will be wanting this one:
>
> 	https://lkml.org/lkml/2011/8/19/355

Hi,

yes, this applies and makes the stack disappear.

Thanks,
Chris
