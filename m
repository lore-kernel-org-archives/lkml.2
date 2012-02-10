Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760224Ab2BJVNC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 16:13:02 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42730 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994Ab2BJVNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 16:13:00 -0500
Date: Fri, 10 Feb 2012 13:12:55 -0800
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jens Axboe <axboe@kernel.dk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Bug in disk event polling
Message-ID: <20120210211255.GK19392@google.com>
References: <20120210204652.GJ19392@google.com>
 <Pine.LNX.4.44L0.1202101557280.1281-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1202101557280.1281-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alan.

On Fri, Feb 10, 2012 at 04:03:51PM -0500, Alan Stern wrote:
> None of those resets above should have occurred.  They are the result
> of trying to recover from the failure of a TEST UNIT READY command.

Thanks for the log.  Yeah, I was just thinking about libata and
wondering why it would break that badly.

> > > I have verified that changing all occurrences of system_nrt_wq in 
> > > block/genhd.c to system_freezable_wq fixes the bug.  However this may 
> > > not be the way you want to solve it; you may prefer to have a freezable 
> > > non-reentrant work queue.
> > 
> > Please feel free to send out a patch to fix the issue. :)
> 
> Is there a real reason for using system_nrt_wq?  Are you okay with just
> switching over to system_freezable_wq?

I think it should be nrt.  It assumes that no one else is running it
concurrently; otherwise, multiple CPUs could jump into
disk->fops->check_events() concurrently which can be pretty ugly.

Thanks.

-- 
tejun
