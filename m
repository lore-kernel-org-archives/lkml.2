Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab0GVIuL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 04:50:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:53901 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812Ab0GVIuJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 04:50:09 -0400
Date: Thu, 22 Jul 2010 09:50:07 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCHv6 0/9] kill unnecessary SB sync wake-ups + cleanups
Message-ID: <20100722085007.GC903@ZenIV.linux.org.uk>
References: <1278332107-11443-1-git-send-email-dedekind1@gmail.com>
 <1279785280.3044.30.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279785280.3044.30.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 10:54:40AM +0300, Artem Bityutskiy wrote:
> On Mon, 2010-07-05 at 15:14 +0300, Artem Bityutskiy wrote:
> > here is v6 of my SB sync wakups killing patches, v5 may be found:
> > http://marc.info/?l=linux-fsdevel&m=127583599911620&w=2
> > 
> > This is more of a reminder re-send, I did not get any feed-back for
> > v5. Not much changes since v5:
> > 
> > 1. Drop patches which fix race conditions for s_dirty changes WRT actual
> >    write-back - these things are independent and I am planning to go through
> >    that separately.
> > 2. Add "Acked-by" to the btrfs patch.
> > 3. Fold all per-fs patches which introduce SB accessors into one big patch.
> 
> Hi Al,
> 
> you "unofficially" told me that you want to get rid of '->write_super()'
> and 'sync_supers()' should not exist. And FSes which really need
> '->write_super()' should implement that themselves.
> 
> I will try to work on this, but a bit later, after my holidays. But
> could you please:
> 
> 1. confirm that you want to kill '->write_super()' and '->s_dirt'
>    "officially", so that I could refer to this when sending patches

ACK.

> 2. pick up patches 1-6 from this series, this would make my life easier
>    a bit.
> 
> I'm not sure then what do do with:

Will be in for-next tonight.
 
> commit 140236b4b1c749c9b795ea3d11558a0eb5a3a080
> Author: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Date:   Thu Jun 10 13:56:33 2010 +0300
> 
>     VFS: introduce s_dirty accessors
> 
> which Linus merged, but which is now not needed, since you now want me
> to kill '->write_super()' completely. Will you take care of this please?

Once that stuff is done, we'll be able to get rid of those just fine..

FWIW, I'm tempted to add affs_dirty_sb()/affs_clean_sb()/affs_is_clean() and
corresponding helpers for other filesystems in the series and fold conversions
to those into your 1--6; you'll need insertion points for your "schedule
some work" logics whether it's done on per-fs-type basis or globally...
