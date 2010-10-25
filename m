Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574Ab0JYHFb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 03:05:31 -0400
Received: from www.tglx.de ([62.245.132.106]:52253 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab0JYHFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 03:05:30 -0400
Date: Mon, 25 Oct 2010 09:04:53 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Nick Piggin <npiggin@kernel.dk>
cc: Christoph Hellwig <hch@infradead.org>, Andi Kleen <andi@firstfloor.org>,
        Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] fs: Introduce per-bucket inode hash locks
In-Reply-To: <alpine.LFD.2.00.1010250638250.14160@localhost6.localdomain6>
Message-ID: <alpine.LFD.2.00.1010250900530.3583@localhost6.localdomain6>
References: <20101016075703.GO19147@amd> <20101016161642.GC16861@infradead.org> <20101016171213.GC3240@amd> <20101017004610.GB29677@dastard> <20101017022539.GA3317@amd> <87iq0za32l.fsf@basil.nowhere.org> <20101018162105.GB9571@infradead.org> <20101019070057.GA7770@amd>
 <20101019165044.GA13531@infradead.org> <alpine.LFD.2.00.1010241728510.11642@localhost6.localdomain6> <20101024211735.GB3137@amd> <alpine.LFD.2.00.1010250638250.14160@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Oct 2010, Thomas Gleixner wrote:
> On Mon, 25 Oct 2010, Nick Piggin wrote:
> > Although a sane locking macro and structure like I had, would perfectly
> > allow you to switch locks in a single place just the same.
> 
> And a locking macro/structure is better in self documenting than a
> helper function which was proposed by Christoph?

Independently of what data structure you folks agree on, we really do
_NOT_ want to have open coded bit_spin_*lock() anywhere in the code.

As I said before, aside of RT it's a basic requirement to switch bit
spinlocks to real ones for lockdep debugging.

Thanks,

	tglx
