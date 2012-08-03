Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658Ab2HCVoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 17:44:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35588 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab2HCVoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 17:44:19 -0400
Date: Fri, 3 Aug 2012 14:44:14 -0700
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@elte.hu, ebiederm@xmission.com, aarcange@redhat.com,
        ericvh@gmail.com, netdev@vger.kernel.org
Subject: Re: [RFC v2 1/7] hashtable: introduce a small and naive hashtable
Message-ID: <20120803214414.GL15477@google.com>
References: <1344003788-1417-1-git-send-email-levinsasha928@gmail.com>
 <1344003788-1417-2-git-send-email-levinsasha928@gmail.com>
 <20120803171515.GH15477@google.com>
 <501C407D.9080900@gmail.com>
 <20120803213017.GK15477@google.com>
 <501C4471.4090706@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501C4471.4090706@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Sasha.

On Fri, Aug 03, 2012 at 11:36:49PM +0200, Sasha Levin wrote:
> On 08/03/2012 11:30 PM, Tejun Heo wrote:
> The function definition itself is just a macro, for example:
> 
> 	#define MM_SLOTS_HASH_CMP(mm_slot, obj) ((mm_slot)->mm == (obj))

It seems like it would make things more difficult to follow and
error-prone.  I'd definitely prefer just using functions.

> As an alternative, what do you think about simplifying that to be
> just a 'cond' instead of a function? Something like:
> 
> 	hash_get(&mm_slots_hash, mm, struct mm_slot, hash, mm);
> 
> In that case, the last param ("mm") will get unrolled to a condition like this:
> 
> 	if ((obj)->mm == key)
> 
> Which will be simple and easy for the user.

It seems a bit too magical(tm) to me. ;)

> The only reason I want to keep this interface is that most cases
> I've stumbled so far were easy short comparisons of a struct member
> with the key, and I don't want to make them more complex than they
> need to be. I probably will switch hash_get() to use
> hash_for_each_possible() as well, which will cut down on how
> hash_get() is a separate case.

I can understand that but I think the benefit we're talking about is a
bit too miniscule to matter and to have two different interfaces.
What do others think?

Thanks.

-- 
tejun
