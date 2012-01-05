Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab2AEPck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 10:32:40 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49594 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932552Ab2AEPci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 10:32:38 -0500
Date: Thu, 5 Jan 2012 07:32:33 -0800
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Revoking filesystems [was Re: Sysfs attributes racing with
 unregistration]
Message-ID: <20120105153233.GA11934@google.com>
References: <m1boqietiv.fsf@fess.ebiederm.org>
 <Pine.LNX.4.44L0.1201051001360.1434-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1201051001360.1434-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 05, 2012 at 10:13:31AM -0500, Alan Stern wrote:
> I don't have a clear idea of what's involved (in particular, how to go
> from a block_device structure to a mounted filesystem).  But the place
> to do it would probably be block/genhd.c:invalidate_partition().  Ted
> can tell you if there's a better alternative.
> 
> > Do you know how hard it is to detect at mount time if a block device
> > might be hot-plugable?  We can always use a mount option here and
> > make userspace figure it out, but being to have a good default would
> > be nice.
> 
> I don't think it's possible to tell if a device is hot-unpluggable.  
> For example, the device itself might not be removable from its parent, 
> but the parent might be hot-unpluggable.  You'll probably have to 
> assume that every device can potentially be unplugged, one way or 
> another.
> 
> Also, even devices that aren't hot-unpluggable can fail.  The end 
> result should be pretty much the same.

Ummm.... I could be missing something but filesystems need to be able
to deal with partial device failures (ie. some block can't be read)
and hot-unplug or handling full failure is a logical extension of
that.  That's how it already works, so I don't really think that is a
particularly good application for the revoke mechanism.

Thanks.

-- 
tejun
