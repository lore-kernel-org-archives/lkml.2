Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab2KRXvK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 18:51:10 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:8335 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752700Ab2KRXvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 18:51:08 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlkJACVzqVB5LbWp/2dsb2JhbABFhTe3JYZTgQmCHgEBBScTHCMQCAMOCi4UJQMhE4d7Aw61SA2JVBSLN2mFDQOVe5BEgwM
Date: Mon, 19 Nov 2012 10:51:05 +1100
From: Dave Chinner <david@fromorbit.com>
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: xfs@oss.sgi.com, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: Hang in XFS reclaim on 3.7.0-rc3
Message-ID: <20121118235105.GT14281@dastard>
References: <CAPVoSvSM9=hictqwT2rzZA-fU_XSwd-_FRzW_J+HQYj7iohTWQ@mail.gmail.com>
 <20121029222613.GU29378@dastard>
 <CAPVoSvQATjAVu-D477mrr6K9d0FeY7sH27cH-zNBYMJcRoUY0Q@mail.gmail.com>
 <CAPVoSvRks32ZM7n6U8but-vEj622TEFqAFdxXqS_6mRxyv=0Ew@mail.gmail.com>
 <CAPVoSvSKn2FuBhMF+3U1ueuEzBqL4CFTYFGXqGczTa42PgMjRw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPVoSvSKn2FuBhMF+3U1ueuEzBqL4CFTYFGXqGczTa42PgMjRw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2012 at 04:29:22PM +0100, Torsten Kaiser wrote:
> On Sun, Nov 18, 2012 at 11:24 AM, Torsten Kaiser
> <just.for.lkml@googlemail.com> wrote:
> > On Tue, Oct 30, 2012 at 9:37 PM, Torsten Kaiser
> > <just.for.lkml@googlemail.com> wrote:
> >> I will keep LOCKDEP enabled on that system, and if there really is
> >> another splat, I will report back here. But I rather doubt that this
> >> will be needed.
> >
> > After the patch, I did not see this problem again, but today I found
> > another LOCKDEP report that also looks XFS related.
> > I found it twice in the logs, and as both were slightly different, I
> > will attach both versions.
> 
> > Nov  6 21:57:09 thoregon kernel: [ 9941.104353] 3.7.0-rc4 #1 Not tainted
> > Nov  6 21:57:09 thoregon kernel: [ 9941.104355] inconsistent
> > {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
> > Nov  6 21:57:09 thoregon kernel: [ 9941.104430]        CPU0
> > Nov  6 21:57:09 thoregon kernel: [ 9941.104431]        ----
> > Nov  6 21:57:09 thoregon kernel: [ 9941.104432]   lock(&(&ip->i_lock)->mr_lock);
> > Nov  6 21:57:09 thoregon kernel: [ 9941.104433]   <Interrupt>
> > Nov  6 21:57:09 thoregon kernel: [ 9941.104434]
> > lock(&(&ip->i_lock)->mr_lock);
> > Nov  6 21:57:09 thoregon kernel: [ 9941.104435]
> > Nov  6 21:57:09 thoregon kernel: [ 9941.104435]  *** DEADLOCK ***
> 
> Sorry! Copied the wrong report. Your fix only landed in -rc5, so my
> vanilla -rc4 did (also) report the old problem again.
> And I copy&pasted that report instead of the second appearance of the
> new problem.

Can you repost it with line wrapping turned off? The output simply
becomes unreadable when it wraps....

Yeah, I know I can put it back together, but I've got better things
to do with my time than stitch a couple of hundred lines of debug
back into a readable format....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
