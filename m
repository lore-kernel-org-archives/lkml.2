Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab1G2UYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 16:24:19 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44141 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752156Ab1G2UYR convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 16:24:17 -0400
X-Sasl-enc: tTntE6DV5bj/k33NRiAFyvkV/ECwmo+1smD7BJKNYqPJ 1311971054
References: <20110729153207.17af3085@notabene.brown> <4E324DB4.7060600@fastmail.fm> <1311921035.7845.10.camel@edumazet-laptop> <4E3258E1.6020000@fastmail.fm> <20110729164553.GJ23194@fieldses.org>
Message-Id: <15F25127-70B3-4B42-86DA-E73629C4FE2B@fastmail.fm>
From: Greg Banks <gnb@fastmail.fm>
To: "J. Bruce Fields" <bfields@fieldses.org>
In-Reply-To: <20110729164553.GJ23194@fieldses.org>
Content-Type: text/plain;
	charset=utf-8;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 8BIT
X-Mailer: iPhone Mail (7C144)
Mime-Version: 1.0 (iPhone Mail 7C144)
Subject: Re: [PATCH] sunrpc: use better NUMA affinities
Date: Sat, 30 Jul 2011 06:24:09 +1000
Cc: Eric Dumazet <eric.dumazet@gmail.com>, NeilBrown <neilb@suse.de>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Sent from my iPhone

On 30/07/2011, at 2:45, "J. Bruce Fields" <bfields@fieldses.org> wrote:

> On Fri, Jul 29, 2011 at 04:53:21PM +1000, Greg Banks wrote:
>> On 29/07/11 16:30, Eric Dumazet wrote:
>>> Le vendredi 29 juillet 2011 à 16:05 +1000, Greg Banks a écrit :
>>>> On 29/07/11 15:32, NeilBrown wrote:
>>>>
>>>> I seem to remember coming to the conclusion that Jeff eventually
>>>> addressed this problem...am I misremembering or did something  
>>>> regress?
>>>>
>>> Currently, all nfsd kthreads use memory for their kernel stack and
>>> various initial data from a _single_ node, even if you use
>>> sunrpc.pool_mode=pernode  (or percpu)
>>
>> That's just plain broken and I'm very pleased to see you fix it.
>
> Should I take that as a "Reviewed-by"?

If you like.

>
>> [...] In ToT
>> svc_pool_map_set_cpumask() is called *after* kthread_create() and
>> applies to the child thread, *after* it's stack has been allocated
>> on the wrong node.  In the working SGI code,
>> svc_pool_map_set_cpumask() is called by the parent node on itself
>> *before* calling kernel_thread() or doing any of the data structure
>> allocations, thus ensuring that everything gets allocated using the
>> default memory allocation policy, which on SGI NFS servers was
>> globally tuned to be "node-local".
>
> OK, so would it be enough to just move the svc_pool_map_set_cpumask()
> back a few lines, or do we want Eric's approach, in order to have
> something that will work better with other memory allocation policies?
>

Relying on global policy was easy but not a great idea, I prefer  
Eric's approach of doing it explicitly.

Greg.
>>
