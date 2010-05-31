Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756304Ab0EaOhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 10:37:53 -0400
Received: from stinky.trash.net ([213.144.137.162]:59055 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756242Ab0EaOhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 10:37:51 -0400
Message-ID: <4C03C9BD.2080907@trash.net>
Date: Mon, 31 May 2010 16:37:49 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@medozas.de>
CC: Eric Dumazet <eric.dumazet@gmail.com>, Xiaotian Feng <dfeng@redhat.com>,
       netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
       coreteam@netfilter.org, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH] netfilter: xtables: stackptr should be percpu
References: <1275303998-2435-1-git-send-email-dfeng@redhat.com>  <alpine.LSU.2.01.1005311350580.31799@obet.zrqbmnf.qr> <1275311580.3291.44.camel@edumazet-laptop> <alpine.LSU.2.01.1005311519340.25402@obet.zrqbmnf.qr>
In-Reply-To: <alpine.LSU.2.01.1005311519340.25402@obet.zrqbmnf.qr>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Monday 2010-05-31 15:13, Eric Dumazet wrote:
>> All cpus share a single cache line for their 'stackptr' storage,
>> introduced in commit f3c5c1bfd4
>>
>> This is a stable candidate (2.6.34)
> 
> Stackptr was first introduced for 2.6.35-rcX.
> 
>> +	i->stackptr = alloc_percpu(unsigned int);
>> 	if (i->stackptr == NULL)
>> 		return -ENOMEM;
>> -	memset(i->stackptr, 0, size);
>>
>> 	size = sizeof(void **) * nr_cpu_ids;
>> 	if (size > PAGE_SIZE)
> 
> Are alloc_percpu areas cleared?
> 
> Acked-By: Jan Engelhardt <jengelh@medozas.de>

Applied, thanks.
