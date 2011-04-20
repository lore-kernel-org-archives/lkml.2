Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab1DTN3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 09:29:08 -0400
Received: from cantor.suse.de ([195.135.220.2]:58482 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754922Ab1DTN3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 09:29:05 -0400
Date: Wed, 20 Apr 2011 15:29:03 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39-rc4 BUG: unable to handle kernel NULL pointer dereference
 at  0000000c IP: cfq_insert_request+0x1d/0x3f5
Message-ID: <20110420132903.GA13554@tiehlicka.suse.cz>
References: <20110420125824.GA3507@tiehlicka.suse.cz>
 <4DAEDBEB.7060904@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DAEDBEB.7060904@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 20-04-11 15:13:15, Jens Axboe wrote:
> On 2011-04-20 14:58, Michal Hocko wrote:
> > Hi,
> > I am not able to boot with the current git tree
> > (2.6.39-rc4-00089-g2f666bc). 2.6.39-rc3 boots just fine.
> > 
> > The backtrace [1] looks really messy.
> > 
> > I have seen a similar backtrace at https://lkml.org/lkml/2011/3/25/169
> > and tried the patch from https://lkml.org/lkml/2011/3/25/173 but it
> > didn't help. The backtrace looks similar (much smaller) but the machine
> > ends up dead as well with unbalanced preempt counter[2].
> > 
> > The config is attached.
> > 
> > Is this a known problem?
> > 
> > ---
> > * [1] backtrace with the current git tree (2f666bc)
> > 
> > [   31.207283] BUG: unable to handle kernel NULL pointer dereference at 0000000c
> > NULL pointer dereference[   31.207540] IP: at 0000000c
> > [   31.207540] IP: [<c028dece>] cfq_insert_request+0x1d/0x3f5
> > [   31.207720] *pde = 00000000  [<c028dece>] cfq_insert_request+0x1d/0x3f5
> > NULL pointer dereference[   31.207720] *pde = 00000000
> >  at 0000000c
> > [   31.207888] Oops: 0000 [#1]
> > PREEMPT [   31.207540] IP:[   31.207888] Oops: 0000 [#1] SMP PREEMPT DEBUG_PAGEALLOC [<c028dece>] cfq_insert_request+0x1d/0x3f5
> > SMP DEBUG_PAGEALLOC[   31.207720] *pde = 00000000
> > [   31.207888] Oops: 0000 [#1] PREEMPT [   31.208186] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/queue/scheduler
> 
> Ahh hang on, this may be a good clue. Does your boot scripts change the
> IO scheduler?

Good one...
Yes, I have:
echo deadline > /sys/block/sda/queue/scheduler
in /etc/rc.local

I am able to boot after I remove it. This is the first time I have seen
"last sysfs file" being useful.
Still want me to test the patch from the other email?
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
