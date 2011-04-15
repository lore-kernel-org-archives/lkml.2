Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756284Ab1DOPe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 11:34:29 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:25202 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386Ab1DOPe1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 11:34:27 -0400
MIME-Version: 1.0
Message-ID: <36009196-0fe9-43f2-8d16-4cc58232195f@default>
Date: Fri, 15 Apr 2011 08:32:21 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>
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
Subject: RE: [PATCH V8 4/8] mm/fs: add hooks to support cleancache
References: <20110414211732.GA27761@ca-server1.us.oracle.com>
 <BANLkTimEbtY8F6bpsfhfQ770ao9Hn7Spww@mail.gmail.com>
 <83ef8b69-f041-43e6-a5a9-880ff3da26f2@default
 20110415081054.79a164d3.akpm@linux-foundation.org>
In-Reply-To: <20110415081054.79a164d3.akpm@linux-foundation.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6550.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DA86514.0112:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> On Fri, 15 Apr 2011 07:47:57 -0700 (PDT) Dan Magenheimer
> <dan.magenheimer@oracle.com> wrote:
> 
> > Hi Minchan --
> >
> > > Before I suggested a thing about cleancache_flush_page,
> > > cleancache_flush_inode.
> > >
> > > what's the meaning of flush's semantic?
> > > I thought it means invalidation.
> > > AFAIC, how about change flush with invalidate?
> >
> > I'm not sure the words "flush" and "invalidate" are defined
> > precisely or used consistently everywhere in computer
> > science, but I think that "invalidate" is to destroy
> > a "pointer" to some data, but not necessarily destroy the
> > data itself.   And "flush" means to actually remove
> > the data.  So one would "invalidate a mapping" but one
> > would "flush a cache".
> >
> > Since cleancache_flush_page and cleancache_flush_inode
> > semantically remove data from cleancache, I think flush
> > is a better name than invalidate.
> >
> > Does that make sense?
> 
> nope ;)
> 
> Kernel code freely uses "flush" to refer to both invalidation and to
> writeback, sometimes in confusing ways.  In this case,
> cleancache_flush_inode and cleancache_flush_page rather sound like they
> might write those things to backing store.

OK, I guess I am displaying my kernel-newbie-ness... though,
in this case, writeback of a cleancache page to backing store
doesn't make much sense either (since cleancache pages are
by definition "clean").

I'm happy to rename the hooks, though will probably not
repost a V9 unless/until more substantive changes collect...
unless someone considers this an unmergeable offense.

Thanks for the feedback, Minchan and Andrew!
Dan
