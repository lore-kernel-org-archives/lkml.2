Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab2HAWl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 18:41:29 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39313 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170Ab2HAWl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 18:41:27 -0400
Message-ID: <5019B0B4.1090102@gmail.com>
Date: Thu, 02 Aug 2012 00:41:56 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120730 Thunderbird/14.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com
Subject: Re: [RFC 1/4] hashtable: introduce a small and naive hashtable
References: <1343757920-19713-1-git-send-email-levinsasha928@gmail.com> <1343757920-19713-2-git-send-email-levinsasha928@gmail.com> <20120731182330.GD21292@google.com> <50197348.9010101@gmail.com> <20120801182112.GC15477@google.com> <50197460.8010906@gmail.com> <20120801182749.GD15477@google.com> <50197E4A.7020408@gmail.com> <20120801202432.GE15477@google.com>
In-Reply-To: <20120801202432.GE15477@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2012 10:24 PM, Tejun Heo wrote:
> On Wed, Aug 01, 2012 at 09:06:50PM +0200, Sasha Levin wrote:
>> Using a struct makes the dynamic case much easier, but it complicates the static case.
>>
>> Previously we could create the buckets statically.
>>
>> Consider this struct:
>>
>> struct hash_table {
>> 	u32 bits;
>> 	struct hlist_head buckets[];
>> };
>>
>> We can't make any code that wraps this to make it work properly
>> statically allocated nice enough to be acceptable.
> 
> I don't know.  Maybe you can create an anonymous outer struct / union
> and play symbol trick to alias hash_table to its member.  If it is
> gimped either way, I'm not sure whether it's really worthwhile to
> create the abstraction.  It's not like we're saving a lot of
> complexity.

I must be missing something here, but how would you avoid it?

How would your DEFINE_HASHTABLE look like if we got for the simple 'struct hash_table' approach?

> Thanks.
> 

