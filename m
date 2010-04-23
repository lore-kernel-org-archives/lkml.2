Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897Ab0DWP2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 11:28:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46496 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756259Ab0DWP2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 11:28:46 -0400
Date: Fri, 23 Apr 2010 08:27:02 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Josef Bacik <josef@redhat.com>
cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, randy.dunlap@oracle.com
Subject: Re: [PATCH] cleanup block based fiemap
In-Reply-To: <20100423151857.GD2351@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1004230825481.3739@i5.linux-foundation.org>
References: <20100423144420.GC2351@localhost.localdomain> <alpine.LFD.2.00.1004230753480.3739@i5.linux-foundation.org> <20100423151857.GD2351@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 23 Apr 2010, Josef Bacik wrote:
> 
> __generic_block_fiemap is called by generic_block_fiemap which takes the
> i_mutex.  The only reason we have __generic_block_fiemap is because gfs2 needs
> to do its own locking magic before we go calling get_block.  The idea is that
> the file size doesn't change while we're doing this.

Ok, maybe just a comment then..

> As for reading the size several times, I can read it once and store it in a
> local variable if you prefer, but theres no way to know if len is smaller than
> the size or not, which is why I'm constantly doing i_size_read().  If thats what
> you would prefer I can do that, just let me know.

.. or a comment _and_ a "read size once into a variable". Not a big deal, 
it just wasn't entirely clear to me and I hadn't checked the callchain.

> > Issue #2: "blk_to_logical(inode, 0)"? WTF? Since when has shifting zero 
> > ever resulted in anything interesting or relevant? There's at least two of 
> > those things.
> > 
> 
> Umm, yeah I'm sorry?  I have no idea why I did that.  I think its because I was
> getting the logical offset of the first block + size, which is just stupid
> because the logical offset is 0, so all I can say is I'm sorry that me a year
> ago was alot dumber than me now :).  Thanks,

Ok, fix that, and I think the patch will be a clear improvement.

		Linus
