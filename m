Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab2JPMwl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 08:52:41 -0400
Received: from mail.unix-scripts.info ([46.21.114.223]:40200 "EHLO
	mail.unix-scripts.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754151Ab2JPMw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 08:52:29 -0400
Date: Tue, 16 Oct 2012 14:52:25 +0200
From: Laurent CARON <lcaron@unix-scripts.info>
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>
Subject: Re: Strange crash on Dell R720xd
Message-ID: <20121016145039.eizeigon@trusted.unix-scripts.info>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
	Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>
References: <20121015213522.kaiyahro@trusted.unix-scripts.info>
 <20121016090353.GB7428@liondog.tnic>
 <20121016112301.lavahnga@trusted.unix-scripts.info>
 <20121016124825.GA8509@x1.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121016124825.GA8509@x1.osrc.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2012 at 02:48:25PM +0200, Borislav Petkov wrote:
> On Tue, Oct 16, 2012 at 11:26:01AM +0200, Laurent CARON wrote:
> > On Tue, Oct 16, 2012 at 11:03:53AM +0200, Borislav Petkov wrote:
> > > That's:
> > > 
> > >                 BUG_ON(async_tx_test_ack(depend_tx) || txd_next(depend_tx) ||
> > > 			txd_parent(tx));
> > > 
> > > but probably the b0rkage happens up the stack. And this __raid_run_ops
> > > is probably starting the whole TX so maybe we should add
> > > linux-raid@vger.kernel.org to CC. Added.
> > 
> > 
> > Hi,
> > 
> > The machines seem stable after disabling I/O AT DMA at the BIOS level.
> 
> That's a good point because the backtrace goes through I/O AT DMA so it
> could very well be the culprit. Let's add some more people to Cc.
> 
> Vinod/Dan, here's the BUG_ON Laurent is hitting:
> 
> http://marc.info/?l=linux-kernel&m=135033064724794&w=2
> 
> and it has ioat2_tx_submit_unlock in the backtrace. Disabling ioat dma
> in the BIOS makes the issue disappear so ...
> 
> > > What is that "r510" thing in the kernel version? You have your patches
> > > ontop? If yes, please try reproducing this with a kernel.org kernel
> > > without anything else ontop.
> > 
> > My kernel is vanilla from Kernel.org. The -r510 string is because I
> > tried it on a -r510 also.
> 
> Ok, good.
> 
> > > Also, it might be worth trying plain 3.6 to rule out a regression
> > > introduced in the stable 3.6 series.
> > 
> > I tried 3.5.x, 3.6, 3.6.1, 3.6.2 with exactly the same results.
> > 
> > For now, I did create more volumes, rsync lors of data over the network
> > to the disks with no crashs (after disabling I/O AT DMA).
> 
> And when you do this with ioat dma enabled, you get the bug, right? So
> it is reproducible...?

It is 100% reproductible. The only "nondeterministic" point is the time
it takes to have the machine crash.


