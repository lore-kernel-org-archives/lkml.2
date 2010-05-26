Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab0EZNAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 09:00:23 -0400
Received: from verein.lst.de ([213.95.11.210]:57204 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753578Ab0EZNAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 09:00:20 -0400
Date: Wed, 26 May 2010 15:00:13 +0200
From: Christoph Hellwig <hch@lst.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Hellwig <hch@lst.de>, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86-32: always use irq stacks
Message-ID: <20100526130013.GA641@lst.de>
References: <20100526110923.GA28414@lst.de> <alpine.LFD.2.00.1005261446290.2995@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1005261446290.2995@localhost.localdomain>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 02:47:07PM +0200, Thomas Gleixner wrote:
> On Wed, 26 May 2010, Christoph Hellwig wrote:
> 
> > 
> > IRQ stacks provide much better safety against unexpected stack use from
> > interrupts, at the minimal downside of slightly higher memory usage.
> > Enable irq stacks also for the default 8k stack to minimize the problem
> > of stack overflows through interrupt activity.
> > 
> > This is what x86-64 and various other architectures already do.
> 
> We got rid of nested interrupts, so is this really a concern anymore ?

Yes, especially for deep storage stacks anything that can come in
unexpectedly from IRQ context is quite harmful.  It's a really cheap
way to avoid that indeterminism.

