Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab2ACRfK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 12:35:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35161 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250Ab2ACRfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 12:35:06 -0500
Date: Tue, 3 Jan 2012 09:35:00 -0800
From: Tejun Heo <tj@kernel.org>
To: Hugh Dickins <hughd@google.com>, Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH block/for-3.3/core] block: an exiting task should be
 allowed to create io_context
Message-ID: <20120103173500.GB31746@google.com>
References: <20111222154427.89b245c7.akpm@linux-foundation.org>
 <20111222234639.GS17084@google.com>
 <20111223004244.GU17084@google.com>
 <alpine.LSU.2.00.1112232058550.3225@eggly.anvils>
 <20111225010238.GA6013@htj.dyndns.org>
 <alpine.LSU.2.00.1112280010550.1398@eggly.anvils>
 <20111228164836.GP17712@google.com>
 <alpine.LSU.2.00.1112280939390.3320@eggly.anvils>
 <CAOS58YOzUcZz41+H+7dk5FteHy+Ufrtpk9dvdPqX6eie-GHi0Q@mail.gmail.com>
 <20111228211918.GA3516@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111228211918.GA3516@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Happy new year, guys.

On Wed, Dec 28, 2011 at 01:19:18PM -0800, Tejun Heo wrote:
> > On Wed, Dec 28, 2011 at 9:50 AM, Hugh Dickins <hughd@google.com> wrote:
> > > "It's the tmpfs swapping test that I've been running, with variations,
> > > for years.  System booted with mem=700M and 1.5G swap, two repetitious
> > > make -j20 kernel builds (of a 2.6.24 kernel: I stuck with that because
> > > the balance of built to unbuilt source grows smaller with later kernels),
> > > one directly in a tmpfs, the other in a 1k-block ext2 (that I drive with
> > > ext4's CONFIG_EXT4_USE_FOR_EXT23) on /dev/loop0 on a 450MB tmpfs file."
> > >
> > > I doubt much of that (quoted from an older mail to someone else about
> > > one of the many other bugs it's found) is relevant: maybe just plenty
> > > of file I/O and swapping.
> > 
> > Plain -j4 build isn't triggering anything.  I'll try to replicate the condition.
> 
> It's not too reliable but I can reproduce it with -j 22 allmodconfig
> build inside qemu w/ 512M of memory.  I'll try to find out what's
> going on.

I misread the code, the problem is empty cfqq on the cfq prio tree.  I
don't think this is caused by recent io_context changes.  It looks
like somebody is forgetting to remove cfqq from the dispatch prio tree
after emptying a cfqq by removing a request from it.  Jens, any ideas?

Thanks.

-- 
tejun
