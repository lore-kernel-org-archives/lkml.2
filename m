Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab0D0BjT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 21:39:19 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33640 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab0D0BjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 21:39:17 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 27 Apr 2010 10:35:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pavel Machek <pavel@ucw.cz>,
       Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: swapping when there's a free memory
Message-Id: <20100427103517.ae0658cf.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100426153333.93c03e98.akpm@linux-foundation.org>
References: <alpine.DEB.1.10.1004220248280.19246@artax.karlin.mff.cuni.cz>
	<20100425071349.GA1275@ucw.cz>
	<20100426153333.93c03e98.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Apr 2010 15:33:33 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Sun, 25 Apr 2010 09:13:49 +0200
> Pavel Machek <pavel@ucw.cz> wrote:
> 
> > Hi!
> > 
> > > I captured this output of vmstat. The machine was freeing cache and 
> > > swapping out pages even when there was a plenty of free memory.
> > > 
> > > The machine is sparc64 with 1GB RAM with 2.6.34-rc4. This abnormal 
> > > swapping happened during running spadfsck --- a fsck program for a custom 
> > > filesystem that caches most reads in its internal cache --- so it reads 
> > > buffers and allocates memory at the same time.
> > > 
> > > Note that sparc64 doesn't have any low/high memory zones, so it couldn't 
> > > be explained by filling one zone and needing to allocate pages in it.
> > 
> > Fragmented memory + high-order allocation?
> 
> Yeah, could be.  I wonder which slab/slub/slob implementation you're
> using, and what page sizes it uses for dentries, inodes, etc.  Can you
> have a poke in /prob/slabinfo?
> 
And please /proc/buddyinfo and /proc/zoneinfo when the system is swappy.

Thanks,
-Kame

> 
> > > This abnormal behavior doesn't happen everytime, it happend about twice 
> > > for many spadfsck attempts.
> > 
> > ...yep, that would be random.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

