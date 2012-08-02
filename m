Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab2HBKAH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 06:00:07 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49457 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754122Ab2HBKAF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 06:00:05 -0400
Message-ID: <501A4FC1.8040907@gmail.com>
Date: Thu, 02 Aug 2012 12:00:33 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120730 Thunderbird/14.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, josh@joshtriplett.org
Subject: Re: [RFC 1/4] hashtable: introduce a small and naive hashtable
References: <1343757920-19713-1-git-send-email-levinsasha928@gmail.com> <1343757920-19713-2-git-send-email-levinsasha928@gmail.com> <20120731182330.GD21292@google.com> <50197348.9010101@gmail.com> <20120801182112.GC15477@google.com> <50197460.8010906@gmail.com> <20120801182749.GD15477@google.com> <50197E4A.7020408@gmail.com> <20120801202432.GE15477@google.com> <5019B0B4.1090102@gmail.com> <20120801224556.GF15477@google.com>
In-Reply-To: <20120801224556.GF15477@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2012 12:45 AM, Tejun Heo wrote:
> On Thu, Aug 02, 2012 at 12:41:56AM +0200, Sasha Levin wrote:
>> How would your DEFINE_HASHTABLE look like if we got for the simple
>> 'struct hash_table' approach?
> 
> I think defining a different enclosing anonymous struct which the
> requested number of array entries and then aliasing the actual
> hash_table to that symbol should work.  It's rather horrible and I'm
> not sure it's worth the trouble.

I agree that this is probably not worth the trouble.

At the moment I see two alternatives:

1. Dynamically allocate the hash buckets.

2. Use the first bucket to store size. Something like the follows:

	#define HASH_TABLE(name, bits)	\
        	struct hlist_head name[1 << bits + 1];

	#define HASH_TABLE_INIT (bits) ({name[0].next = bits});

And then have hash_{add,get} just skip the first bucket.


While it's not a pretty hack, I don't see a nice way to avoid having to dynamically allocate buckets for all cases.
