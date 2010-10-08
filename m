Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759801Ab0JHVqX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 17:46:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33727 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759776Ab0JHVqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 17:46:22 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Eric Paris <eparis@redhat.com>
Subject: Re: Linux 2.6.36-rc7
Date: Fri, 8 Oct 2010 23:45:44 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org
References: <AANLkTi=LsBNU+O2hqZUcM2nYM_ze6qPq3thwSZBMtY_v@mail.gmail.com> <201010081406.10190.agruen@suse.de> <1286555908.2682.62.camel@localhost.localdomain>
In-Reply-To: <1286555908.2682.62.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010082345.45234.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 October 2010 18:38:28 Eric Paris wrote:
> However, THIS is potentially a real ABI problem and something which
> deals with the interface.  Alan seemed to lean towards pulling the
> syscalls. It is relatively easily solved without changing the interface
> or breaking userspace in 2.6.37.  We use some set of the flags bits as a
> priority (we only use 2 of the 32 bits today so we have plenty) and
> order groups with highest priority first, 0 priority last, and 2+ groups
> with the same priority have unpredictable ordering.  I'd then call
> priorities other than 0 a 2.6.37 feature.  If we do it in flags I think
> that leaves us with say 8 bits and thus 255 priorities.

That's a possibility but it seems quite messy for a brand new system call.  
I'd still pull the system call and work out the few remaining quirkses.

Thanks.

> ------
> 
> I said I wouldn't refute your claims but I can't help myself on one
> account which I think might mislead people.
> 
>  * Some weaknesses in the interface design were only identified and fixed
>    late in the -rc phase, changing the ABI.  There may be more issues, like
>    the priority discussion.  This might leave us with a broken ABI we would
>    need to support forever.
> 
> Between rc2 and rc3 we switched the order and size of a couple of fields
> to help alignment, it did break ABI, but it wasn't an interface failing.
> See: 0fb85621df4f.

See, a weakness, not a failure.  What I said.

The main issue that Andreas Schwab has pointed out (and which also lead to 
this commit) was the packing of the structs which leads to inefficient code, 
though.  This hasn't been fixed but it still can be, in a backwards compatible 
way.

Thanks,
Andreas
