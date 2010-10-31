Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536Ab0JaMYr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 08:24:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:55810 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755425Ab0JaMYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 08:24:44 -0400
Date: Sun, 31 Oct 2010 13:24:37 +0100
From: Jan Kara <jack@suse.cz>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <jens.axboe@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
        gregkh@suse.de
Subject: Re: Sync writeback still broken
Message-ID: <20101031122437.GA6296@quack.suse.cz>
References: <20100212091609.GB1025@kernel.dk>
 <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain>
 <alpine.LSU.2.01.1002131356250.20838@obet.zrqbmnf.qr>
 <20100215144938.GD3434@quack.suse.cz>
 <alpine.LSU.2.01.1002151629380.27775@obet.zrqbmnf.qr>
 <alpine.LSU.2.01.1006271842220.1495@obet.zrqbmnf.qr>
 <alpine.LNX.2.01.1010250115360.16022@obet.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1010250115360.16022@obet.zrqbmnf.qr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 25-10-10 01:41:48, Jan Engelhardt wrote:
> On Sunday 2010-06-27 18:44, Jan Engelhardt wrote:
> >On Monday 2010-02-15 16:41, Jan Engelhardt wrote:
> >>On Monday 2010-02-15 15:49, Jan Kara wrote:
> >>>On Sat 13-02-10 13:58:19, Jan Engelhardt wrote:
> >>>> >> 
> >>>> >> This fixes it by using the passed in page writeback count, instead of
> >>>> >> doing MAX_WRITEBACK_PAGES batches, which gets us much better performance
> >>>> >> (Jan reports it's up from ~400KB/sec to 10MB/sec) and makes sync(1)
> >>>> >> finish properly even when new pages are being dirted.
> >>>> >
> >>>> >This seems broken.
> >>>> 
> >>>> It seems so. Jens, Jan Kara, your patch does not entirely fix this.
> >>>> While there is no sync/fsync to be seen in these traces, I can
> >>>> tell there's a livelock, without Dirty decreasing at all.
> >
> >What ultimately became of the discussion and/or the patch? 
> >
> >Your original ad-hoc patch certainly still does its job; had no need to 
> >reboot in 86 days and still counting.
> 
> I still observe this behavior on 2.6.36-rc8. This is starting to 
> get frustrating, so I will be happily following akpm's advise to 
> poke people.
  Yes, that's a good way :)

> Thread entrypoint: http://lkml.org/lkml/2010/2/12/41
> 
> Previously, many concurrent extractions of tarballs and so on have been 
> one way to trigger the issue; I now also have a rather small testcase 
> (below) that freezes the box here (which has 24G RAM, so even if I'm 
> lacking to call msync, I should be fine) sometime after memset finishes.
  I've tried your test but didn't succeed in freezing my laptop.
Everything was running smooth, the machine even felt reasonably responsive
although constantly reading and writing to disk. Also sync(1) finished in a
couple of seconds as one would expect in an optimistic case.
  Needless to say that my laptop has only 1G of ram so I had to downsize
the hash table from 16G to 1G to be able to run the test and the disk is
Intel SSD so the performance of the backing storage compared to the amount
of needed IO is much in my favor.
  OK, so I've taken a machine with standard rotational drive and 28GB of
ram and there I can see sync(1) hanging (but otherwise the machine looks
OK). Investigating further...

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
