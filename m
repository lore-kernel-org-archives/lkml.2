Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab1DNWkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 18:40:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52069 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753994Ab1DNWkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 18:40:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [linux-pm] freezer: should barriers be smp ?
Date: Fri, 15 Apr 2011 00:40:39 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.1104141104160.2487-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1104141104160.2487-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104150040.39274.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, April 14, 2011, Alan Stern wrote:
> On Wed, 13 Apr 2011, Mike Frysinger wrote:
> 
> > > On Wed, Apr 13, 2011 at 18:49, Rafael J. Wysocki wrote:
> 
> > > In my opinion is an architecture problem, not the freezer code problem.
> > 
> > OK, we have a patch pending locally which populates all barriers with
> > this logic, but based on my understanding of things, that didnt seem
> > correct.  i guess i'm reading too much into the names ... i'd expect
> > the opposite behavior where "rmb" is only for UP needs while "smp_rmb"
> > is a rmb which additionally covers SMP.
> 
> You are misinterpreting the names and the concepts, both.
> 
> First, you need to understand that memory barriers are needed only for
> purposes of synchronizing between two different entities capable of
> accessing memory (obviously it's not necessary to synchronize an entity
> with itself).  One of those entities is always a CPU, of course; the
> other entity could be a DMA-capable device or it could be another CPU.
> 
> A device driver might need to use memory barriers even on a UP
> platform, because it might need to synchronize the CPU with the device
> it is driving.
> 
> But core kernel code is concerned only with CPUs.  Therefore on UP 
> systems, core kernel code (such as the freezer) never needs to use 
> memory barriers.
> 
> That's the difference between rmb() and smp_rmb().  rmb() _always_ 
> generates a memory barrier, so it should be used only in device 
> drivers.  smp_rmb() generates a memory barrier only if CONFIG_SMP is 
> enabled; otherwise it merely generates a compiler barrier.
> 
> In the freezer, there is no reason to use rmb() and wmb().  It should 
> use smp_rmb() and smp_wmb().

OK, I think you're right, but that's because rmb() and wmb() cause too much
overhead to happen.

Thanks,
Rafael
