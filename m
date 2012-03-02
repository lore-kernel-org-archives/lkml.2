Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758097Ab2CBBLW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 20:11:22 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58817 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757942Ab2CBBLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 20:11:21 -0500
Date: Fri, 2 Mar 2012 02:11:19 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: .. anybody know of any filesystems that depend on the exact VFS 'namehash' implementation?
Message-ID: <20120302011119.GA22197@one.firstfloor.org>
References: <CA+55aFyv=OKUuAV6pqdmbHeUL7Motsh+n026nWqaT63aEgBjBQ@mail.gmail.com> <m2ipinq16x.fsf@firstfloor.org> <CA+55aFw=wwGD=QLmQgfGm+oZR3UyvKBmXdXj+SJtK6pipCe45A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw=wwGD=QLmQgfGm+oZR3UyvKBmXdXj+SJtK6pipCe45A@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2012 at 05:01:52PM -0800, Linus Torvalds wrote:
> On Thu, Mar 1, 2012 at 4:46 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >
> > There should be generally better modern general hash algorithms around,
> > like murmur, cityhash or snoopy. Perhaps even the fnv we have in tree,
> > but it's somewhat dated by know.
> >
> > They all have larger code, but if it's really that hot it would be worth
> > it.
> 
> The quality of our hash function really doesn't seem to be the issue.

With better I meant mainly faster in cycles.

e.g. CityHash claims upto ~6 bytes/cycle. That's extreme and may need
the SSE versions, but there are non SSE variants e.g. in spooky that are 
somewhat competive.

Are you anywhere near that with your hash function?

Partly they get that from unrolling, but there are also lots of other tricks.

Also BTW if we had better hash functions (in mixing) we could do smaller
hash tables.

-Andi

