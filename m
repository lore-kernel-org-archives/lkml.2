Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755065Ab2BQW33 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 17:29:29 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59841 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755033Ab2BQW31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 17:29:27 -0500
Date: Fri, 17 Feb 2012 23:29:22 +0100
From: Holger Macht <holger@homac.de>
To: Hugh Dickins <hughd@google.com>
Cc: Matthew Garrett <mjg@redhat.com>, Jeff Garzik <jgarzik@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: dock_link_device is oopsy
Message-ID: <20120217222922.GA2741@homac.suse.de>
References: <alpine.LSU.2.00.1202171320590.5994@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1202171320590.5994@eggly.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fr 17. Feb - 13:46:04, Hugh Dickins wrote:
> Matthew,
> 
> A linux-next oops at bootup in dock_link_device() tells me that you
> were not feeling well when you wrote that and dock_unlink_device():
> I hope you're feeling better now and can rewrite them soon.

Andrew Morton experienced a similar problem. What system are you using?
I didn't encounter this problem with the systems I tested with.

Do you actually have a /sys/devices/platform/dock.?/ directory with a
file 'type' that contains 'dock_station'?

> I think my particular problem comes from dock_station_count 0,
> so kmalloc() returns NULL, which you don't check for.  But those
> functions appear to be minor masterpieces of doing things in the
> wrong order, not checking allocation, not freeing resource on failure.
> 
> I'm not attaching a proposed patch because, on that record, I bet when
> you look closer you'll find more wrong that I wouldn't know about.
> 
> Let's hope this isn't diverted into an endless discussion of whether
> you ought to use kaalloc() or kballoc() or ....  me, I'd just like to
> boot, and have put #if 0..#endif around everything in those functions.

Nevertheless, we should check for this error case or make sure we aren't
able to run into it.

Thanks,
 Holger
