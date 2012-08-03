Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599Ab2HCVaZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 17:30:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44759 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab2HCVaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 17:30:22 -0400
Date: Fri, 3 Aug 2012 14:30:17 -0700
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@elte.hu, ebiederm@xmission.com, aarcange@redhat.com,
        ericvh@gmail.com, netdev@vger.kernel.org
Subject: Re: [RFC v2 1/7] hashtable: introduce a small and naive hashtable
Message-ID: <20120803213017.GK15477@google.com>
References: <1344003788-1417-1-git-send-email-levinsasha928@gmail.com>
 <1344003788-1417-2-git-send-email-levinsasha928@gmail.com>
 <20120803171515.GH15477@google.com>
 <501C407D.9080900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501C407D.9080900@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Aug 03, 2012 at 11:19:57PM +0200, Sasha Levin wrote:
> > Is this supposed to be embedded in struct definition?  If so, the name
> > is rather misleading as DEFINE_* is supposed to define and initialize
> > stand-alone constructs.  Also, for struct members, simply putting hash
> > entries after struct hash_table should work.
> 
> It would work, but I didn't want to just put them in the union since
> I feel it's safer to keep them in a separate struct so they won't be
> used by mistake,

Just use ugly enough pre/postfixes.  If the user still accesses that,
it's the user's fault.

> >> +static void hash_init(struct hash_table *ht, size_t bits)
> >> +{
> >> +	size_t i;
> > 
> > I would prefer int here but no biggie.
> 
> Just wondering, is there a particular reason behind it?

It isn't a size and using unsigned when signed suffices seems to cause
more headache than helps anything usually due to lack of values to use
for exceptional conditions (usually -errno or -1).

> > As opposed to using hash_for_each_possible(), how much difference does
> > this make?  Is it really worthwhile?
> 
> Most of the places I've switched to using this hashtable so far (4
> out of 6) are using hash_get(). I think that the code looks cleaner
> when you an just provide a comparison function instead of
> implementing the iteration itself.
>
> I think hash_for_for_each_possible() is useful if the comparison
> condition is more complex than a simple comparison of one of the
> object members with the key - there's no need to force it on all the
> users.

I don't know.  What's the difference?  In terms of LOC, it might even
not save any thanks to the extra function definition, right?  I don't
think it's saving enough complexity to justify a separate rather
unusual interface.

Thanks.

-- 
tejun
