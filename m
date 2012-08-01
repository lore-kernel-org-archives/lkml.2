Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab2HAUYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 16:24:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39461 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab2HAUYh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 16:24:37 -0400
Date: Wed, 1 Aug 2012 13:24:32 -0700
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com
Subject: Re: [RFC 1/4] hashtable: introduce a small and naive hashtable
Message-ID: <20120801202432.GE15477@google.com>
References: <1343757920-19713-1-git-send-email-levinsasha928@gmail.com>
 <1343757920-19713-2-git-send-email-levinsasha928@gmail.com>
 <20120731182330.GD21292@google.com>
 <50197348.9010101@gmail.com>
 <20120801182112.GC15477@google.com>
 <50197460.8010906@gmail.com>
 <20120801182749.GD15477@google.com>
 <50197E4A.7020408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50197E4A.7020408@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2012 at 09:06:50PM +0200, Sasha Levin wrote:
> Using a struct makes the dynamic case much easier, but it complicates the static case.
> 
> Previously we could create the buckets statically.
> 
> Consider this struct:
> 
> struct hash_table {
> 	u32 bits;
> 	struct hlist_head buckets[];
> };
> 
> We can't make any code that wraps this to make it work properly
> statically allocated nice enough to be acceptable.

I don't know.  Maybe you can create an anonymous outer struct / union
and play symbol trick to alias hash_table to its member.  If it is
gimped either way, I'm not sure whether it's really worthwhile to
create the abstraction.  It's not like we're saving a lot of
complexity.

Thanks.

-- 
tejun
