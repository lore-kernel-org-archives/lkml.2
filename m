Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab2GIUb6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:31:58 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:52306 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752976Ab2GIUb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:31:57 -0400
Message-ID: <1341865916.6118.25.camel@joe2Laptop>
Subject: Re: 3.5-rc6 printk formatting problem during oom-kill.
From: Joe Perches <joe@perches.com>
To: Kay Sievers <kay@vrfy.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartmann <greg@kroah.com>
Date: Mon, 09 Jul 2012 13:31:56 -0700
In-Reply-To: <1341859731.801.0.camel@mop>
References: <20120709180328.GA4105@redhat.com>
	 <CAPXgP11oP4aKyg=HUNrb3z_ZbPjU+_u338sD6uhxKyJ43Z8sgQ@mail.gmail.com>
	 <1341859731.801.0.camel@mop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-09 at 20:48 +0200, Kay Sievers wrote:
> On Mon, 2012-07-09 at 20:27 +0200, Kay Sievers wrote:
> > On Mon, Jul 9, 2012 at 8:03 PM, Dave Jones <davej@redhat.com> wrote:
> > > I noticed that the format of the oom-killer output seems to have changed, and
> > > now it spews stuff like..
> > >
> > > [49461.758070] lowmem_reserve[]:
> > > [49461.758071]  0
> > > [49461.758071]  2643
> > > [49461.758071]  3878
> > > [49461.758072]  3878
> > > [49461.758072]
> > > [49461.758072] Node 0
> > 
> > > Does the oom-killer code need modifying, or the printk code ?
> > > I know there's been some regressions in this area recently, but this is still
> > > happening on the current tree (8c84bf4166a4698296342841a549bbee03860ac0)
> > 
> > This likely fixes it:
> >   http://git.kernel.org/?p=linux/kernel/git/kay/patches.git;a=blob;f=kmsg-merge-cont.patch;hb=HEAD
> > 
> > Let me check if it does, and if I can reproduce it.
> 
> It looks fine here with the above mentioned patch:
> [    0.000000] lowmem_reserve[]:
> [    0.000000]  0
> [    0.000000]  0
> [    0.000000]  0
> [    0.000000]  0
> [    0.000000] 
> [    0.000000] DMA: 
> [    0.000000] 1*4kB 
> [    0.000000] 0*8kB 
> [    0.000000] 0*16kB 
> [    0.000000] 1*32kB 
> [    0.000000] 2*64kB 
> [    0.000000] 1*128kB 
> [    0.000000] 1*256kB 
> [    0.000000] 0*512kB 
> [    0.000000] 1*1024kB 
> [    0.000000] 1*2048kB 
> [    0.000000] 3*4096kB 
> [    0.000000] = 15908kB
> 
> becomes:
> [    0.000000] lowmem_reserve[]: 0 0 0 0
> [    0.000000] DMA: 1*4kB 0*8kB 0*16kB 1*32kB 2*64kB 1*128kB 1*256kB 0*512kB 1*1024kB 1*2048kB 3*4096kB = 15908kB

Hi Kay.

That single patch doesn't apply cleanly to Linus'
8c84bf4166a4698296342841a549bbee03860ac0

What else is necessary?

Your tree seems to have a collection of random patches.

It might be useful to clone Linus' tree and produce a
branch with all the necessary printk patches in it so
someone else could pull it.

cheers, Joe

