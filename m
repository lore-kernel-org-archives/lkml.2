Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935165Ab0EVAGA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 20:06:00 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:52113 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935072Ab0EVAF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 20:05:56 -0400
Date: Sat, 22 May 2010 10:05:51 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PULL REQUEST] Ext2, ext3, and quota updates for 2.6.35-rc1
Message-ID: <20100522000551.GY8120@dastard>
References: <20100521174658.GA10149@quack.suse.cz>
 <20100521184428.GC10149@quack.suse.cz>
 <alpine.LFD.2.00.1005211146160.3689@i5.linux-foundation.org>
 <20100521192456.GE10149@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521192456.GE10149@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 09:24:56PM +0200, Jan Kara wrote:
> On Fri 21-05-10 11:50:15, Linus Torvalds wrote:
> > 
> > 
> > On Fri, 21 May 2010, Jan Kara wrote:
> > >
> > >   Oops, I've just found a bug in one of my ocfs2 fixes. I've fixed that up
> > > so the new diffstat is here:
> > 
> > I already pulled your previous version.
>   OK, I'll push the fix separately.
> 
> > And btw, Jan, I'm getting pretty upset with your apparently cavalier 
> > attitude to filesystems. We've had several bugs lately for some quota or 
> > filesystem "cleanups", which in at least one case caused corrupted 
> > filesystems etc.
>   That ext3 bug was nasty I agree :( I'm now pushing some quota tests to
> XFSQA and setup a machine that runs them. So that should improve a test
> coverage...

The other thing is that all the tests in xfstests can be run with
quota enabled to exercise the code rather than test for correctness.
This is done by running like:

# MOUNT_OPTIONS="-o usrquota,grpquota" ./check -g auto

And that makes all the tests run with user and group quotas enabled
for XFS. However, we might need a bit of help in the mount paths for
filesystems that require a quotaon command before they will run
all the generic tests with quotas enabled.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
