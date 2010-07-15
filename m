Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378Ab0GOLwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 07:52:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758235Ab0GOLwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 07:52:03 -0400
Message-ID: <4C3EF644.1070505@redhat.com>
Date: Thu, 15 Jul 2010 19:51:32 +0800
From: Xiaotian Feng <dfeng@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: Mitchell Erblich <erblichs@earthlink.net>
CC: linux-mm@kvack.org, linux-nfs@vger.kernel.org, netdev@vger.kernel.org,
        riel@redhat.com, cl@linux-foundation.org, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, lwang@redhat.com, penberg@cs.helsinki.fi,
        akpm@linux-foundation.org, davem@davemloft.net
Subject: Re: [PATCH -mmotm 12/30] selinux: tag avc cache alloc as non-critical
References: <20100713101650.2835.15245.sendpatchset@danny.redhat> <20100713101906.2835.83443.sendpatchset@danny.redhat> <6E38A74E-B033-4D2A-9620-2A8BDF9E0AD1@earthlink.net>
In-Reply-To: <6E38A74E-B033-4D2A-9620-2A8BDF9E0AD1@earthlink.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 06:55 PM, Mitchell Erblich wrote:
>
> On Jul 13, 2010, at 3:19 AM, Xiaotian Feng wrote:
>
>>  From 6c3a91091b2910c23908a9f9953efcf3df14e522 Mon Sep 17 00:00:00 2001
>> From: Xiaotian Feng<dfeng@redhat.com>
>> Date: Tue, 13 Jul 2010 11:02:41 +0800
>> Subject: [PATCH 12/30] selinux: tag avc cache alloc as non-critical
>>
>> Failing to allocate a cache entry will only harm performance not correctness.
>> Do not consume valuable reserve pages for something like that.
>>
>> Signed-off-by: Peter Zijlstra<a.p.zijlstra@chello.nl>
>> Signed-off-by: Suresh Jayaraman<sjayaraman@suse.de>
>> Signed-off-by: Xiaotian Feng<dfeng@redhat.com>
>> ---
>> security/selinux/avc.c |    2 +-
>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/security/selinux/avc.c b/security/selinux/avc.c
>> index 3662b0f..9029395 100644
>> --- a/security/selinux/avc.c
>> +++ b/security/selinux/avc.c
>> @@ -284,7 +284,7 @@ static struct avc_node *avc_alloc_node(void)
>> {
>> 	struct avc_node *node;
>>
>> -	node = kmem_cache_zalloc(avc_node_cachep, GFP_ATOMIC);
>> +	node = kmem_cache_zalloc(avc_node_cachep, GFP_ATOMIC|__GFP_NOMEMALLOC);
>> 	if (!node)
>> 		goto out;
>>
>> -- 
>> 1.7.1.1
>>
>
> Why not just replace GFP_ATOMIC with GFP_NOWAIT?
>
> This would NOT consume the valuable last pages.

But replace GFP_ATOMIC with GFP_NOWAIT can not prevent avc_alloc_node 
consume reserved pages.

>
> Mitchell Erblich
>> --
>> To unsubscribe from this list: send the line "unsubscribe netdev" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

