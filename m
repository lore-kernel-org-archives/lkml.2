Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759874Ab2BJSjT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 13:39:19 -0500
Received: from casper.infradead.org ([85.118.1.10]:34998 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab2BJSjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 13:39:18 -0500
Subject: Re: [v7 0/8] Reduce cross CPU IPI interference
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Chris Metcalf <cmetcalf@tilera.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
In-Reply-To: <CAOtvUMfE3xpwmRKnFPTsstr3SuUG7SnpWn5eomEQzkap4_nfrg@mail.gmail.com>
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com>
	 <1327591185.2446.102.camel@twins>
	 <CAOtvUMeAkPzcZtiPggacMQGa0EywTH5SzcXgWjMtssR6a5KFqA@mail.gmail.com>
	 <20120201170443.GE6731@somewhere.redhat.com>
	 <CAOtvUMc8L1nh2eGJez0x44UkfPCqd+xYQASsKOP76atopZi5mw@mail.gmail.com>
	 <4F2AAEB9.9070302@tilera.com>
	 <CAOtvUMfE3xpwmRKnFPTsstr3SuUG7SnpWn5eomEQzkap4_nfrg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Feb 2012 19:39:08 +0100
Message-ID: <1328899148.25989.38.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-02-05 at 13:46 +0200, Gilad Ben-Yossef wrote:
> > /*
> >  * Cause all memory mappings to be populated in the page table.
> >  * Specifying this when entering dataplane mode ensures that no future
> >  * page fault events will occur to cause interrupts into the Linux
> >  * kernel, as long as no new mappings are installed by mmap(), etc.
> >  * Note that since the hardware TLB is of finite size, there will
> >  * still be the potential for TLB misses that the hypervisor handles,
> >  * either via its software TLB cache (fast path) or by walking the
> >  * kernel page tables (slow path), so touching large amounts of memory
> >  * will still incur hypervisor interrupt overhead.
> >  */
> > #define DP_POPULATE     0x8
> 
> hmm... I've probably missed something, but doesn't this replicate
> mlockall (MCL_CURRENT|MCL_FUTURE) ? 

Never use mlockall() its a sign you're doing it wrong, also his comment
seems to imply MCL_FUTURE isn't required.

