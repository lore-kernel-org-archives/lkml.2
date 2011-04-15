Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573Ab1DOPJR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 11:09:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58148 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751537Ab1DOPJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 11:09:15 -0400
Date: Fri, 15 Apr 2011 08:10:54 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Chris Mason <chris.mason@oracle.com>,
        viro@zeniv.linux.org.uk, adilger.kernel@dilger.ca, tytso@mit.edu,
        mfasheh@suse.com, jlbec@evilplan.org, matthew@wil.cx,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, hch@infradead.org,
        ngupta@vflare.org, jeremy@goop.org, JBeulich@novell.com,
        Kurt Hackel <kurt.hackel@oracle.com>, npiggin@kernel.dk,
        Dave Mccracken <dave.mccracken@oracle.com>, riel@redhat.com,
        avi@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>, mel@csn.ul.ie,
        yinghan@google.com, gthelen@google.com, torvalds@linux-foundation.org
Subject: Re: [PATCH V8 4/8] mm/fs: add hooks to support cleancache
Message-Id: <20110415081054.79a164d3.akpm@linux-foundation.org>
In-Reply-To: <83ef8b69-f041-43e6-a5a9-880ff3da26f2@default>
References: <20110414211732.GA27761@ca-server1.us.oracle.com
 BANLkTimEbtY8F6bpsfhfQ770ao9Hn7Spww@mail.gmail.com>
	<83ef8b69-f041-43e6-a5a9-880ff3da26f2@default>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Apr 2011 07:47:57 -0700 (PDT) Dan Magenheimer <dan.magenheimer@oracle.com> wrote:

> Hi Minchan --
> 
> > First of all, thanks for resolving conflict with my patch.
> 
> You're welcome!  As I pointed out offlist, yours was the first
> change in MM that caused any semantic changes to the cleancache
> core hooks patch since before 2.6.18.
>  
> > Before I suggested a thing about cleancache_flush_page,
> > cleancache_flush_inode.
> > 
> > what's the meaning of flush's semantic?
> > I thought it means invalidation.
> > AFAIC, how about change flush with invalidate?
> 
> I'm not sure the words "flush" and "invalidate" are defined
> precisely or used consistently everywhere in computer
> science, but I think that "invalidate" is to destroy
> a "pointer" to some data, but not necessarily destroy the
> data itself.   And "flush" means to actually remove
> the data.  So one would "invalidate a mapping" but one
> would "flush a cache".
> 
> Since cleancache_flush_page and cleancache_flush_inode
> semantically remove data from cleancache, I think flush
> is a better name than invalidate.
> 
> Does that make sense?
> 

nope ;)

Kernel code freely uses "flush" to refer to both invalidation and to
writeback, sometimes in confusing ways.  In this case,
cleancache_flush_inode and cleancache_flush_page rather sound like they
might write those things to backing store.  
