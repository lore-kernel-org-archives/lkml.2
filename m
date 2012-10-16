Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab2JPU3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 16:29:54 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:43726 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab2JPU3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 16:29:53 -0400
MIME-Version: 1.0
In-Reply-To: <20121015165756.GA11737@redhat.com>
References: <1350242593-17761-1-git-send-email-rabin@rab.in>
 <1350242593-17761-6-git-send-email-rabin@rab.in> <20121015165756.GA11737@redhat.com>
From: Rabin Vincent <rabin@rab.in>
Date: Tue, 16 Oct 2012 22:29:12 +0200
X-Google-Sender-Auth: WhPhEOpYQE5jSmvTBTABnXgVPCs
Message-ID: <CAH+eYFAv=UTZ1gQ5jXq8_ziNy1i3BL9y1bOUWMdTow=i3N0n+g@mail.gmail.com>
Subject: Re: [PATCH 6/9] uprobes: flush cache after xol write
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/15 Oleg Nesterov <oleg@redhat.com>:
> On 10/14, Rabin Vincent wrote:
>> Flush the cache so that the instructions written to the XOL area are
>> visible.
>>
>> Signed-off-by: Rabin Vincent <rabin@rab.in>
>> ---
>>  kernel/events/uprobes.c |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
>> index ca000a9..8c52f93 100644
>> --- a/kernel/events/uprobes.c
>> +++ b/kernel/events/uprobes.c
>> @@ -1246,6 +1246,7 @@ static unsigned long xol_get_insn_slot(struct uprobe *uprobe, unsigned long slot
>>       offset = current->utask->xol_vaddr & ~PAGE_MASK;
>>       vaddr = kmap_atomic(area->page);
>>       arch_uprobe_xol_copy(&uprobe->arch, vaddr + offset);
>> +     flush_dcache_page(area->page);
>>       kunmap_atomic(vaddr);
>
> I agree... but why under kmap_atomic?

No real reason; I'll move it to after the unmap.
