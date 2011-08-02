Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1HBBai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 21:30:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36675 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753309Ab1HBBae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 21:30:34 -0400
Date: Tue, 2 Aug 2011 02:30:27 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Josef Bacik <josef@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Jan Kara <jack@suse.cz>
Subject: Re: [Regression] Commit 02c24a82187d5a628c68edfe71ae60dc135cd178
 breaks s2disk
Message-ID: <20110802013027.GJ2203@ZenIV.linux.org.uk>
References: <201108020147.01136.rjw@sisk.pl>
 <201108020217.48952.rjw@sisk.pl>
 <CA+55aFxPAowBwgK7JqN0uH-ytvg+BKdE3yBGF0z_6kNDNcOYcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxPAowBwgK7JqN0uH-ytvg+BKdE3yBGF0z_6kNDNcOYcQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 03:22:02PM -1000, Linus Torvalds wrote:
> On Mon, Aug 1, 2011 at 2:17 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > Well, I'm not sure if the patch below is the right fix, but it evidently makes
> > s2disk work for me again.
> 
> Looks right to me.
> 
> The only issue is whether we should use "db_mapping->i_mapping" or
> "file->f_mapping". I think they are the same for block devices.
> 
> Al?

Applied (in file->f_mapping variant; it is equal to bdev->bd_mapping,
but what's wrong with using ->f_mapping here?)

> Also, what about some of the other fsync things that apparently
> weren't updated to write back page caches. ps3flash_fsync? Others?

ps3flash, IIRC, doesn't go through page cache on read and write...
If anything, we probably have instances that bother with pagecache
for no reason...
