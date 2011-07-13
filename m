Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab1GMUne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 16:43:34 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:50113 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751231Ab1GMUnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 16:43:33 -0400
X-Sasl-enc: yEQWJr21YW0LyA7PcddQz7zKvOZrZknT8oVaR6+p2NR/ 1310589811
Date: Wed, 13 Jul 2011 22:41:43 +0200
From: Greg KH <greg@kroah.com>
To: David Howells <dhowells@redhat.com>
Cc: geert@linux-m68k.org, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH] FS-Cache: Fix bounds check
Message-ID: <20110713204143.GC23159@kroah.com>
References: <CAMuHMdUA7+j-hQuvu7g5kCZX1nqwPtR+mwhPP1nmxfkmCxfKmg@mail.gmail.com>
 <20110713115518.29995.29712.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110713115518.29995.29712.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 12:55:18PM +0100, David Howells wrote:
> __fscache_uncache_all_inode_pages() has a loop that goes through page index
> numbers go up to (loff_t)-1.  This is incorrect.  The limit should be
> (pgoff_t)-1 as on a 32-bit machine the pgoff_t is smaller than loff_t.
> 
> On m68k the following error is observed:
> 
> fs/fscache/page.c: In function '__fscache_uncache_all_inode_pages':
> fs/fscache/page.c:979: warning: comparison is always false due to
> limited range of data type
> 
> [Should there be a PGOFF_T_MAX constant defined?]
> 
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  fs/fscache/page.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
