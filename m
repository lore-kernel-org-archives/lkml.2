Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab1HVPeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 11:34:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27333 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752594Ab1HVPeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 11:34:21 -0400
Date: Mon, 22 Aug 2011 11:34:08 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: hch@infradead.org, peterz@infradead.org, davej@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: hugetlb locking bug.
Message-ID: <20110822153408.GG2270@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 2:19 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>>
>> (Warning: whitespace damage and TOTALLY UNTESTED)
>
> Gaah. That won't work. Or rather, it probably may work, but while
> working it will spam the logs with that
> 
>     WARN_ON(!(inode->i_state & I_NEW));
> 
> thing from unlock_new_inode.
> 
> So the sane thing to do would be apparently one of
> 
>  (a) ignore the whole thing, and just accept the false lockdep warning.
> 
>       which I'd be willing to do, but it might be hiding some real
> ones, so we probably shouldn't.
> 
>  (b) just remove that WARN_ON(), and use the one-liner I suggested
> 
>  (c) extract the "set directory i_mutex key" logic into a new helper
> function for the case of filesystems like hugetlbfs that don't want to
> use unlock_new_inode() for one reason or another.
> 
> Personally, I don't have any really strong preferences and would
> probably just go for (b) to keep the patch small and simple. Anybody?

Sorry to revive an old thread, but we've seen this reported by something
other than Dave's crazy fuzzer tool now [1].

It seems solution (a) wound up winning just because nobody chased it
further.  Is that what we want to stick with, and just close similar
reports as "false warning", or should option (c) eventually get
implemented?

josh

[1] https://bugzilla.redhat.com/show_bug.cgi?id=730998
