Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab1DQWVM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 18:21:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51512 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641Ab1DQWVG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 18:21:06 -0400
Date: Mon, 18 Apr 2011 08:20:52 +1000
From: NeilBrown <neilb@suse.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [Bug #32982] Kernel locks up a few minutes after boot
Message-ID: <20110418082052.07476d4a@notabene.brown>
In-Reply-To: <20110418070711.12dd5cc1@notabene.brown>
References: <OlQwC5HnRsN.A.ULB.OGuqNB@chimera>
	<_H4l51C1wXN.A.yDC.yGuqNB@chimera>
	<BANLkTimeaHwBiZoz=isCM=qtBxoxaBqDUw@mail.gmail.com>
	<BANLkTi=1jO73DXDTD50bVpU82qphVKmRCw@mail.gmail.com>
	<20110418070711.12dd5cc1@notabene.brown>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Apr 2011 07:07:11 +1000 NeilBrown <neilb@suse.de> wrote:

> On Sun, 17 Apr 2011 20:37:39 +0200 Bart Van Assche <bvanassche@acm.org> wrote:
> 
> > On Sun, Apr 17, 2011 at 7:03 PM, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > > On Sun, Apr 17, 2011 at 5:57 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > This message has been generated automatically as a part of a summary report
> > > > of recent regressions.
> > > >
> > > > The following bug entry is on the current list of known regressions
> > > > from 2.6.38.  Please verify if it still should be listed and let the tracking team
> > > > know (either way).
> > > >
> > > >
> > > > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=32982
> > > > Subject         : Kernel locks up a few minutes after boot
> > > > Submitter       : Bart Van Assche <bart.vanassche@gmail.com>
> > > > Date            : 2011-04-10 19:55 (8 days old)
> > >
> > > Is this machine running a RAID5 setup or something like that?
> > >
> > > There is a known interaction with the new block layer plugging code
> > > and MD. The "hung task" report in that bugzilla looks very much like
> > > that issue. And you do have "root=/dev/md0", so clearly there's some
> > > md thing going on.
> > >
> > > And bisecting might not work all that well for it, because I suspect
> > > it ends up being very much a matter of IO patterns how it triggers.
> > >
> > > Neil supposedly has a patch for it, but I haven't seen it yet. Neil, Jens?
> > 
> > (converted top-posting into bottom-posting)
> > 
> > Hello Linus,
> > 
> > On the system on which bug #32982 has been triggered md0, md1 and md2
> > have been configured as two-disk RAID1 (mirroring).
> 
> If any of those have write-intent bitmaps then I definitely know what the
> problem is and I'll be posting patches later today (probably not much later).
> 

Actually it won't be today.  The new block device plugging is still unusable
for MD - so I won't be able to fix this until that gets sorted out.

NeilBrown
