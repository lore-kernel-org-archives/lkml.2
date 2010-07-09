Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab0GIPNO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 11:13:14 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:49187 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757199Ab0GIPNL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 11:13:11 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=MBwUKclTgnixAxK11o+d6LW5K04P60ZXKI6qFX0XNVZIHYSsm2gkQv22/JA+nESd92/nDh7guJ+KhPnBbOELnm9ckTKwtNWg7Y8pySKBz4i2SPCttRMSSTFle45P2dT5;
Date: Fri, 9 Jul 2010 08:12:39 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Network Development <netdev@vger.kernel.org>,
       Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux PM List <linux-pm@lists.linux-foundation.org>,
       Linux SCSI List <linux-scsi@vger.kernel.org>,
       Linux Wireless List <linux-wireless@vger.kernel.org>,
       DRI <dri-devel@lists.sourceforge.net>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Shawn Starr <shawn.starr@rogers.com>,
       Dave Airlie <airlied@redhat.com>,
       "David S. Miller" <davem@davemloft.net>,
       Patrick McHardy <kaber@trash.net>, Jens Axboe <axboe@kernel.dk>,
       Enrico Bandiello <enban@postal.uv.es>,
       Norbert Preining <preining@logic.at>
Subject: Re: 2.6.35-rc4-git3: Reported regressions from 2.6.34
Message-ID: <20100709081239.4eb8fddd@virtuousgeek.org>
In-Reply-To: <AANLkTiknnzWyVpqnPCpyiEVHLgkewd0zaGzLInABRe2G@mail.gmail.com>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera>
	<AANLkTiknnzWyVpqnPCpyiEVHLgkewd0zaGzLInABRe2G@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Jul 2010 18:34:25 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16307
> > Subject         : i915 in kernel 2.6.35-rc3, high number of wakeups
> > Submitter       : Enrico Bandiello <enban@postal.uv.es>
> > Date            : 2010-06-26 16:57 (13 days old)
> > Message-ID      : <4C26317A.5070309@postal.uv.es>
> > References      : http://marc.info/?l=linux-kernel&m=127757403404259&w=2  
> 
> I don't think anybody noticed this one. Jesse?

Oh I hadn't seen that...  Enrico, can you bisect this issue?  It could
be some spurious hotplug events or possibly a stuck vblank interrupt...

> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16265
> > Subject         : Why is kslowd accumulating so much CPU time?
> > Submitter       : Theodore Ts'o <tytso@mit.edu>
> > Date            : 2010-06-09 18:36 (30 days old)
> > First-Bad-Commit: http://git.kernel.org/linus/fbf81762e385d3d45acad057b654d56972acf58c
> > Message-ID      : <E1OMQ88-0002a1-Gb@closure.thunk.org>
> > References      : http://marc.info/?l=linux-kernel&m=127610857819033&w=4  
> 
> Dave, Jesse?

I haven't looked at the switchable graphics stuff, hopefully Dave has
an idea here.

> Fixed by commit f4985dc714d7.
> 
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16228
> > Subject         : BUG/boot failure on Dell Precision T3500 (pci/ahci_stop_engine)
> > Submitter       : Brian Bloniarz <phunge0@hotmail.com>
> > Date            : 2010-06-16 17:57 (23 days old)
> > Handled-By      : Bjorn Helgaas <bjorn.helgaas@hp.com>  
> 
> This has a butt-ugly suggested patch that certainly won't be applied.
> I saw the thread, but lost sight of it. Jesse, did that end up with
> some resolution?

I'll follow up with Yinghai, we were pretty clear about what we wanted
from that patch.

> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16179
> > Subject         : 2.6.35-rc2 completely hosed on intel gfx?
> > Submitter       : Norbert Preining <preining@logic.at>
> > Date            : 2010-06-06 11:55 (33 days old)
> > Message-ID      : <20100606115534.GA9399@gamma.logic.tuwien.ac.at>
> > References      : http://marc.info/?l=linux-kernel&m=127582534931581&w=2  
> 
> Hmm. That one is the vt.c bug coupled with another problem, which in
> turn got opened as a separate bugzilla entry:
> 
>    http://bugzilla.kernel.org/show_bug.cgi?id=16252
> 
> which in turn then got closed. I dunno.

Yeah, this is weird.  Norbert, do you still see this?  Have you tried
to bisect it?


-- 
Jesse Barnes, Intel Open Source Technology Center
