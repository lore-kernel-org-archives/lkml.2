Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab3ADMf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 07:35:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751410Ab3ADMfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 07:35:54 -0500
Date: Fri, 4 Jan 2013 07:35:34 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Ed Cashin <ecashin@coraid.com>
Cc: Jens Axboe <axboe@kernel.dk>,
        "mitko@banksoft-bg.com" <mitko@banksoft-bg.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-team@fedoraproject.org" <kernel-team@fedoraproject.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Oops on aoe module removal
Message-ID: <20130104123534.GB27554@hansolo.jdub.homelinux.org>
References: <50E5910E.7060606@kernel.dk>
 <50E591CD.40802@kernel.dk>
 <D2D8353E-8DE1-44A2-BB7F-3FE1E2E794FB@coraid.com>
 <50E5A51C.3030800@kernel.dk>
 <32456405-00CA-43EC-A17A-28452C217A7F@coraid.com>
 <ffc5cf0d1e3273770b65bc7de4a4851e@coraid.com>
 <50E5DFE4.5020007@kernel.dk>
 <EE162567-A6C8-4C4E-B96F-5366C8DDDCB1@coraid.com>
 <6333449B-1F90-4772-A04A-79E123A8A20D@coraid.com>
 <20130103210046.GA27554@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130103210046.GA27554@hansolo.jdub.homelinux.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 04:00:46PM -0500, Josh Boyer wrote:
> On Thu, Jan 03, 2013 at 02:50:46PM -0600, Ed Cashin wrote:
> > >>> The blk_alloc_queue has already done a bdi_init, so do not bdi_init again in
> > >>> aoeblk_gdalloc.
> > >>> 
> > >>> The patch below applies to v3.5.6, with its v47 aoe driver.  On my system it
> > >>> eliminates the list_del corruption messages.
> > >> 
> > >> Since the patch doesn't apply to current -git, does the problem not
> > >> exist there?
> > > 
> > > The original post is about an older kernel with the v47 aoe driver.  The current mainline has a v81 aoe driver, so the patch for v3.5.6 isn't expected to apply to the mainline.
> > > 
> > > I'm currently investigating the state of the mainline with relation to this issue.
> > 
> > I don't see the extra call to bdi_init in aoe driver v81 in the mainline git tree, and
> > I don't see the symptoms under discussion, either, when performing the same 
> > test steps.
> > 
> > Kernels with aoe v47 can use the patch I just posted.
> > 
> > I'm going to go through the stable kernels and check, but I believe kernels after
> > v47 but before commit 0a41409c5180 should apply the fix in 0a41409c5180:
> > 
> >   commit 0a41409c518083133e79015092585d68915865be
> >   Author: Ed Cashin <ecashin@coraid.com>
> >   Date:   Mon Dec 17 16:03:58 2012 -0800
> >   
> >       aoe: remove vestigial request queue allocation
> > 
> > Josh, can you confirm that the patch I posted in this thread today works for 
> > your customer?
> 
> Sure.  I'll get a test kernel built with that patch and ask them to
> test.

Dimitar confirmed in the bug that the kernel I built with the patch no
longer oopses on rmmod.  Thanks for the quick turn around!

josh
