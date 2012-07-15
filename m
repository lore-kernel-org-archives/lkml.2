Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab2GOTJp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 15:09:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44415 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab2GOTJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 15:09:38 -0400
Message-ID: <5003156B.2090301@canonical.com>
Date: Sun, 15 Jul 2012 12:09:31 -0700
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, WANG Cong <xiyou.wangcong@gmail.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: x86/mm: Limit 2/4M size calculation to x86_32
References: <5000259D.9020303@canonical.com> <CAE9FiQUxRyVLu-sgrQ-GtRye=CqGHcf9=WA-omz1s5GrxofrJg@mail.gmail.com>
In-Reply-To: <CAE9FiQUxRyVLu-sgrQ-GtRye=CqGHcf9=WA-omz1s5GrxofrJg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2012 11:12 AM, Yinghai Lu wrote:
> On Fri, Jul 13, 2012 at 6:41 AM, Stefan Bader
> <stefan.bader@canonical.com> wrote:
>> I was bisecting a problem on 64bit where any attempt to cause a crash kernel to
>> boot would hang. The bisect ended up on commit 722bc6b (x86/mm: Fix the size
>> calculation of mapping tables) and somehow, looking at the calling function and
>> the ranges printed on boot, I think the calculations should only be done in the
>> 32bit case.
>>
>> On 64bit:
>> [    0.000000] init_memory_mapping: [mem 0x00000000-0x77e87fff]
>> [    0.000000]  [mem 0x00000000-0x77dfffff] page 2M
>> [    0.000000]  [mem 0x77e00000-0x77e87fff] page 4k
>>
>> Attached patch would fix this if you agree with it. Thanks.
>
> it does not look like for the hang for your system. maybe just because
> it change a bit memblock allocation layout.
>
The hang is merely the effect of limited memory getting even more limited and 
running out of it while trying to uncompress your initramfs and/or kernel is not 
helping.

> can you please post whole boot log that is working and not?
>
I am traveling this week and have no access to the machine. But basically you 
can see the issue relatively simple. As 64bit does not have the first 2/4M area 
as 4k pages. So with the current state of the patch this would allocate extra 
space of about 3MB for the first range  (about 1.9GB).
Again the problem is not something bad going on beyond the fact that it wastes 
memory and it just happens to be more than it used to be, so the memory set 
aside for getting it to boot suddenly failed to be enough.

-Stefan
> Thanks
>
> Yinghai
>


