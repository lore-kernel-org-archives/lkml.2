Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756278Ab2HATGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 15:06:22 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33984 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754506Ab2HATGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 15:06:21 -0400
Message-ID: <50197E4A.7020408@gmail.com>
Date: Wed, 01 Aug 2012 21:06:50 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120730 Thunderbird/14.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com
Subject: Re: [RFC 1/4] hashtable: introduce a small and naive hashtable
References: <1343757920-19713-1-git-send-email-levinsasha928@gmail.com> <1343757920-19713-2-git-send-email-levinsasha928@gmail.com> <20120731182330.GD21292@google.com> <50197348.9010101@gmail.com> <20120801182112.GC15477@google.com> <50197460.8010906@gmail.com> <20120801182749.GD15477@google.com>
In-Reply-To: <20120801182749.GD15477@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2012 08:27 PM, Tejun Heo wrote:
> On Wed, Aug 01, 2012 at 08:24:32PM +0200, Sasha Levin wrote:
>> On 08/01/2012 08:21 PM, Tejun Heo wrote:
>>> On Wed, Aug 01, 2012 at 08:19:52PM +0200, Sasha Levin wrote:
>>>> If we switch to using functions, we could no longer hide it anywhere
>>>> (we'd need to either turn the buckets into a struct, or have the
>>>> user pass it around to all functions).
>>>
>>> Create an outer struct hash_table which remembers the size?
>>
>> Possible. I just wanted to avoid creating new structs where they're not really required.
>>
>> Do you think it's worth it for eliminating those two macros?
> 
> What if someone wants to allocate hashtable dynamically which isn't
> too unlikely?  I think it's best to stay away from macro tricks as
> much as possible although I gotta admit I fall into the macro trap
> more often than I would like.

Using a struct makes the dynamic case much easier, but it complicates the static case.

Previously we could create the buckets statically.

Consider this struct:

struct hash_table {
	u32 bits;
	struct hlist_head buckets[];
};

We can't make any code that wraps this to make it work properly statically allocated nice enough to be acceptable.


What if when creating the buckets, we actually allocate bits+1 buckets, and use the last bucket not as a bucket but as the bitcount? It looks like a hack but I think it's much nicer than the previous.
