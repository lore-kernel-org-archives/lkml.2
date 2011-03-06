Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab1CFDVI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 22:21:08 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46849 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab1CFDVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 22:21:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZJpW2bjqeuAofZ1vHqUzYR6+jXX77O2yK480V0z2sQYsH2zG1MEMhIggblvoFjIc5+
         9p2aUQ0Krw18J7WlqPwKOIGlp/Ub1jaNn4FCRJxCY65Vw7G+QJ1O4lJ69RzW1qLjA2kc
         Z5a84euDt7aOraOIYZXDu8ZUxpmSAwUuAJcco=
Message-ID: <4D72FD96.6020702@gmail.com>
Date: Sat, 05 Mar 2011 19:20:54 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101220 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: <IRQ> [<ffffffff810c9204>] ? __alloc_pages_nodemask+0x622/0x696
References: <AANLkTikaLb_xan2ePfo9JCZ1w7RZ76wF8NUT2tYr0ZD=@mail.gmail.com> <alpine.DEB.2.00.1103051847100.8779@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1103051847100.8779@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2011 06:50 PM, David Rientjes wrote:
> On Sat, 5 Mar 2011, Justin Mattock wrote:
>
>> [  339.787008] SLUB: Unable to allocate memory on node -1 (gfp=0x20)
>> [  339.787008]   cache: kmalloc-8192, object size: 8192, buffer size:
>> 8264, default order: 3, min order: 2
>> [  339.787008]   kmalloc-8192 debugging increased min order, use
>> slub_debug=O to disable.
>> [  339.787008]   node 0: slabs: 181, objs: 543, free: 0
>> [  339.790575] skbuff alloc of size 3904 failed
>> [  339.823775] swapper: page allocation failure. order:2, mode:0x4020
>> [  339.823781] Pid: 0, comm: swapper Not tainted 2.6.38-rc7-00143-gd1b152c #7
>> [  339.823783] Call Trace:
>> [  339.823786]<IRQ>   [<ffffffff810c9204>] ? __alloc_pages_nodemask+0x622/0x696
>> [  339.823811]  [<ffffffffa015a077>] ? ath_rxbuf_alloc+0x29/0x9a [ath]
>> [  339.823815]  [<ffffffff810f67cf>] ? new_slab+0x7b/0x1c6
>> [  339.823819]  [<ffffffffa015a077>] ? ath_rxbuf_alloc+0x29/0x9a [ath]
>> [  339.823823]  [<ffffffff810f6dd6>] ? T.925+0x163/0x29c
>> [  339.823827]  [<ffffffff810c4ecc>] ? mempool_destroy+0xf/0x17
>> [  339.823832]  [<ffffffffa015a077>] ? ath_rxbuf_alloc+0x29/0x9a [ath]
>> [  339.823836]  [<ffffffff810f895a>] ? __kmalloc_track_caller+0xfe/0x190
>>
>
> Order-2 atomic allocations are always going to be difficult since we can't
> do synchronous compaction or reclaim, but I'd try the suggestion shown
> above: boot with slub_debug=O or disable slub debugging so that
> kmalloc-8192 is actually order-1 like it should be.
>

alright! I will leave that setting on in the boot options to see if this 
happens again.

Justin P. Mattock
