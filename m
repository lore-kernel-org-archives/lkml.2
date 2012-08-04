Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab2HDAFi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 20:05:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51043 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab2HDAFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 20:05:36 -0400
Date: Fri, 3 Aug 2012 17:05:31 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Sasha Levin <levinsasha928@gmail.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@elte.hu, ebiederm@xmission.com, aarcange@redhat.com,
        ericvh@gmail.com, netdev@vger.kernel.org
Subject: Re: [RFC v2 1/7] hashtable: introduce a small and naive hashtable
Message-ID: <20120804000531.GP15477@google.com>
References: <20120803171515.GH15477@google.com>
 <501C407D.9080900@gmail.com>
 <20120803213017.GK15477@google.com>
 <501C458E.7050000@gmail.com>
 <20120803214806.GM15477@google.com>
 <501C4E92.1070801@gmail.com>
 <20120803222339.GN15477@google.com>
 <CA+55aFyOst4c3WHbPVbYkSBdBmLJUui5OvoVOh5AuPMnigwnEA@mail.gmail.com>
 <20120803223634.GO15477@google.com>
 <CA+55aFwTa_kYgmFwoWa6hwAAM6=2xTgQQf-vEx_gCzpEMnxodQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwTa_kYgmFwoWa6hwAAM6=2xTgQQf-vEx_gCzpEMnxodQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Aug 03, 2012 at 04:47:47PM -0700, Linus Torvalds wrote:
> On Fri, Aug 3, 2012 at 3:36 PM, Tejun Heo <tj@kernel.org> wrote:
> >
> > I suppose you mean unsized.  I remember this working.  Maybe I'm
> > confusing it with zero-sized array.  Hmm... gcc doesn't complain about
> > the following.  --std=c99 seems happy too.
> 
> Ok, I'm surprised, but maybe it's supposed to work if you do it inside
> another struct like that, exactly so that you can preallocate things..

Yeah, I think the rule is var array should be the last member of any
given struct definition.  Once a struct is defined, its alignment and
size are fixed and it behaves like any other struct.

> Or maybe it's just a gcc bug. I do think this all is way hackier than
> Sasha's original simple code that didn't need these kinds of games,
> and didn't need a size member at all.
> 
> I really think all the extra complexity and overhead is just *bad*.
> The first simple version was much nicer and likely generated better
> code too.

The size member could have performance impact in extreme cases.  If
we're looking for something simple & fast, maybe just pass in @size as
argument and be done with it?

Thanks.

-- 
tejun
