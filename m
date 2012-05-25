Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932525Ab2EYXCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 19:02:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:29985 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751136Ab2EYXCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 19:02:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="144799402"
From: Andi Kleen <andi@firstfloor.org>
To: daniel.santos@pobox.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: Generic Red-Black Trees (status update)
References: <4FC00C50.3000907@att.net>
Date: Fri, 25 May 2012 16:02:41 -0700
In-Reply-To: <4FC00C50.3000907@att.net> (Daniel Santos's message of "Fri, 25
	May 2012 17:48:48 -0500")
Message-ID: <m2fwanlv8u.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Santos <danielfsantos@att.net> writes:

> For anybody that's keeping up with this, I've gone through multiple
> iterations and tests with 9 different gcc versions and concluded that
> the search, insert & remove cores need to be coded in rbtree.h, using
> the traditional interface (i.e., passing struct rb_node & rb_root
> pointers instead of pointers to your specific object types).  The reason
> is that gcc can't handle the cool fully-generic code until 4.6.  In gcc
> 4.5.x, optimization completely breaks expanding the inline functions

Can you post details?

> into huge bloated  monsters.  Also, while I'm re-coding it all, I'm
> adding find_near & insert_near, for more efficient insertion & retrieval
> when you already have a node that should be close to the one you want
> (which is often the case when inserting many objects at once).
>
> So after I'm done with this, I'll start on a new header file (grbtree.h
> probably) using the "grb_" prefix for it's functions that implements the
> gcc 4.6.x+ fully generic & type safe interface, but using cute
> pre-processor tricks for pre-4.6.x compatibility (basically, something
> to consider using once gcc 4.6+ is more widely used).

That doesn't make sense. Either it's used or it's not used,
but if it's available it should work with all compilers.

Otherwise you would end up with drivers or subsystems that
are compiler specific.

It's ok to be somewhat slower or bigger on older compilers.



-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
