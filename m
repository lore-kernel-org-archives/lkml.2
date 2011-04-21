Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab1DUHQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 03:16:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab1DUHQp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 03:16:45 -0400
Date: Thu, 21 Apr 2011 09:16:42 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39-rc4 BUG: unable to handle kernel NULL pointer dereference
 at  0000000c IP: cfq_insert_request+0x1d/0x3f5
Message-ID: <20110421071642.GA3556@tiehlicka.suse.cz>
References: <20110420125824.GA3507@tiehlicka.suse.cz>
 <4DAEDBEB.7060904@fusionio.com>
 <20110420132903.GA13554@tiehlicka.suse.cz>
 <4DAF18DF.9080205@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DAF18DF.9080205@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 20-04-11 19:33:19, Jens Axboe wrote:
> On 2011-04-20 15:29, Michal Hocko wrote:
> > On Wed 20-04-11 15:13:15, Jens Axboe wrote:
> >> On 2011-04-20 14:58, Michal Hocko wrote:
[...]
> >>> [   31.207888] Oops: 0000 [#1] PREEMPT [   31.208186] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/queue/scheduler
> >>
> >> Ahh hang on, this may be a good clue. Does your boot scripts change the
> >> IO scheduler?
> > 
> > Good one...
> > Yes, I have:
> > echo deadline > /sys/block/sda/queue/scheduler
> > in /etc/rc.local
> > 
> > I am able to boot after I remove it. This is the first time I have seen
> > "last sysfs file" being useful.
> > Still want me to test the patch from the other email?
> 
> Is this a new addition to your system? IOW, how certain are you that
> this is a regression that occured between rc3 and rc4?

No, I am setting the scheduler this way for quite some time. If I use it
rc4 explodes while rc3 boots just fine. I am wondering, can this be a
timing issue? I am able to set the scheduler after system settles down
after boot and kde starts.

I am going to bisect, let's see if I can find anything.
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
