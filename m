Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab1JRGiU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 02:38:20 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:39141 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751601Ab1JRGiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 02:38:19 -0400
Message-ID: <4E9D1ED8.3070106@dsn.lapis-semi.com>
Date: Tue, 18 Oct 2011 15:38:16 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: gpio-ml-ioh: Support interrupt function
References: <20111017201058.GA13916@elgon.mountain> <4E9CC93B.4000800@dsn.lapis-semi.com> <alpine.DEB.2.00.1110172251590.4880@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1110172251590.4880@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/10/18 14:56), David Rientjes wrote:
> On Tue, 18 Oct 2011, Tomoya MORINAGA wrote:
>
>>> The linux-next patch 54be566317b6 "gpio-ml-ioh: Support interrupt
>>> function" generates a Sparse warning.
>>>
>>> +               irq_base = irq_alloc_descs(-1, IOH_IRQ_BASE, num_ports[j],
>>> +                                          GFP_KERNEL);
>>>                                              ^^^^^^^^^^
>>>
>>> The last argument should be a NUMA node, not a GFP_ flag.  I'm not
>>> sure what the right fix is.  There are currently 5 callers in my
>>> cscope for this function in linux-next.
>>>
>>> 2 pass GFP_KERNEL which is wrong.
>
> Right, all irq_alloc_descs() allocations are already implicitly
> GFP_KERNEL.
>
>>> 2 pass 0 which maybe should be cpu_to_node(0)?
>>> 1 passes -1 which maybe could be NUMA_NO_NODE?
>>>
>> I can understand your saying.
>> Seeing accepted other drivers, '0' or '-1' is used.
>
> There's actually no guarantee in the kernel that node 0 has memory, so
> unless that is assured in the context then passing 0 would be wrong.
>
>> Focusing on GPIO driver, gpio-pca953x.c uses '-1'.
>>
>
> The slab layer guarantees that passing -1 will allocate on the node that
> is local to the cpu that the code is running on.  Unless there's a
> compelling reason to allocate on a different node, then this is what you
> want to use.
>
> We try not to pass -1 directly, though, we try to use NUMA_NO_NODE
> wherever possible.
 >

Hi, David
Thank you for your information.
I will try to test with '-1'.

After testing with '-1',
I will post the patch for this.

Thanks,
-- 
tomoya
ROHM Co., Ltd.
