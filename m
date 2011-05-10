Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932416Ab1EJIOK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 04:14:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12525 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab1EJIOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 04:14:07 -0400
Date: Tue, 10 May 2011 13:43:53 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, David Zeuthen <zeuthen@gmail.com>,
        Martin Pitt <martin.pitt@ubuntu.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] cdrom: always check_disk_change() on open
Message-ID: <20110510081353.GB22655@amit-x200.redhat.com>
References: <20110406121920.GC4142@mtj.dyndns.org>
 <20110429060200.GA5107@amit-x200.redhat.com>
 <4DBA73B6.6040603@kernel.dk>
 <20110510064247.GA16436@amit-x200.redhat.com>
 <4DC8ECDC.5080106@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC8ECDC.5080106@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 10 May 2011 [09:44:28], Jens Axboe wrote:
> On 2011-05-10 08:42, Amit Shah wrote:
> > On (Fri) 29 Apr 2011 [10:15:50], Jens Axboe wrote:
> >> On 2011-04-29 08:57, Amit Shah wrote:
> >>> On (Wed) 06 Apr 2011 [05:20:09], Tejun Heo wrote:
> >>>> cdrom_open() called check_disk_change() after the rest of open path
> >>>> succeeded which leads to the following bizarre behavior.
> >>>>
> >>>> * After media change, if the device opened without O_NONBLOCK,
> >>>>   open_for_data() naturally fails with -ENOMEDIA and
> >>>>   check_disk_change() is never called.  The media is known to be gone
> >>>>   and the open failure makes it obvious to the userland but device
> >>>>   invalidation never happens.
> >>>>
> >>>> * But if the device is opened with O_NONBLOCK, all the checks are
> >>>>   bypassed and cdrom_open() doesn't notice that the media is not there
> >>>>   and check_disk_change() is called and invalidation happens.
> >>>>
> >>>> There's nothing to be gained by avoiding calling check_disk_change()
> >>>> on open failure.  Common cases end up calling check_disk_change()
> >>>> anyway.  All we get is inconsistent behavior.
> >>>>
> >>>> Fix it by moving check_disk_change() invocation to the top of
> >>>> cdrom_open() so that it always gets called regardless of how the rest
> >>>> of open proceeds.
> >>>>
> >>>> Signed-off-by: Tejun Heo <tj@kernel.org>
> >>>> Reported-by: Amit Shah <amit.shah@redhat.com>
> >>>> Tested-by: Amit Shah <amit.shah@redhat.com>
> >>>
> >>> Ping?
> >>>
> >>> Also, please mark this for stable-2.6.38.
> >>
> >> Done, added for 2.6.39 and marked stable for 2.6.38.
> > 
> > Ping again.  Don't see this yet in Linus's git tree.
> 
> It was added for 2.6.40 and marked for stable.

OK, Thanks.

		Amit
