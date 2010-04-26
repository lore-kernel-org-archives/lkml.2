Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab0DZWeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 18:34:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752355Ab0DZWeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 18:34:16 -0400
Date: Mon, 26 Apr 2010 15:33:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: swapping when there's a free memory
Message-Id: <20100426153333.93c03e98.akpm@linux-foundation.org>
In-Reply-To: <20100425071349.GA1275@ucw.cz>
References: <alpine.DEB.1.10.1004220248280.19246@artax.karlin.mff.cuni.cz>
	<20100425071349.GA1275@ucw.cz>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Apr 2010 09:13:49 +0200
Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > I captured this output of vmstat. The machine was freeing cache and 
> > swapping out pages even when there was a plenty of free memory.
> > 
> > The machine is sparc64 with 1GB RAM with 2.6.34-rc4. This abnormal 
> > swapping happened during running spadfsck --- a fsck program for a custom 
> > filesystem that caches most reads in its internal cache --- so it reads 
> > buffers and allocates memory at the same time.
> > 
> > Note that sparc64 doesn't have any low/high memory zones, so it couldn't 
> > be explained by filling one zone and needing to allocate pages in it.
> 
> Fragmented memory + high-order allocation?

Yeah, could be.  I wonder which slab/slub/slob implementation you're
using, and what page sizes it uses for dentries, inodes, etc.  Can you
have a poke in /prob/slabinfo?


> > This abnormal behavior doesn't happen everytime, it happend about twice 
> > for many spadfsck attempts.
> 
> ...yep, that would be random.

