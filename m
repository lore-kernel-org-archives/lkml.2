Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759486Ab0D3TNQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 15:13:16 -0400
Received: from artax.karlin.mff.cuni.cz ([195.113.26.195]:51433 "EHLO
	artax.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758154Ab0D3Q6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:58:41 -0400
Date: Fri, 30 Apr 2010 05:52:38 +0200 (CEST)
From: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: swapping when there's a free memory
In-Reply-To: <20100427103517.ae0658cf.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.1.10.1004300543290.13905@artax.karlin.mff.cuni.cz>
References: <alpine.DEB.1.10.1004220248280.19246@artax.karlin.mff.cuni.cz> <20100425071349.GA1275@ucw.cz> <20100426153333.93c03e98.akpm@linux-foundation.org> <20100427103517.ae0658cf.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-Personality-Disorder: Schizoid
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 27 Apr 2010, KAMEZAWA Hiroyuki wrote:

> On Mon, 26 Apr 2010 15:33:33 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > On Sun, 25 Apr 2010 09:13:49 +0200
> > Pavel Machek <pavel@ucw.cz> wrote:
> > 
> > > Hi!
> > > 
> > > > I captured this output of vmstat. The machine was freeing cache and 
> > > > swapping out pages even when there was a plenty of free memory.
> > > > 
> > > > The machine is sparc64 with 1GB RAM with 2.6.34-rc4. This abnormal 
> > > > swapping happened during running spadfsck --- a fsck program for a custom 
> > > > filesystem that caches most reads in its internal cache --- so it reads 
> > > > buffers and allocates memory at the same time.
> > > > 
> > > > Note that sparc64 doesn't have any low/high memory zones, so it couldn't 
> > > > be explained by filling one zone and needing to allocate pages in it.
> > > 
> > > Fragmented memory + high-order allocation?
> > 
> > Yeah, could be.  I wonder which slab/slub/slob implementation you're
> > using, and what page sizes it uses for dentries, inodes, etc.  Can you
> > have a poke in /prob/slabinfo?

It uses one page-per-slab for dentries and two for inodes. But there was 
certainly no dentry or inode-based load --- the machine runs without X 
with minimum daemons, there is no major background work. There was just a 
process reading 128-kbyte blocks from a raw device and caching them in its 
userspace that triggered this. Can it be that kernel uses high-order 
allocations for reading from a buffer cache?

> And please /proc/buddyinfo and /proc/zoneinfo when the system is swappy.

It happens rarely, I don't know if I catch it at the right time. The 
report I sent, was what I found in a scrollback of vmstat. I didn't catch 
it in real time.

> Thanks,
> -Kame

Mikulas
