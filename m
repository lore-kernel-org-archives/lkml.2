Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753170Ab0CSIl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 04:41:27 -0400
Received: from mail2.shareable.org ([80.68.89.115]:53597 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab0CSIlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 04:41:25 -0400
Date: Fri, 19 Mar 2010 08:40:48 +0000
From: Jamie Lokier <jamie@shareable.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Stefani Seibold <stefani@seibold.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Kreuzer, Michael (NSN - DE/Ulm)" <michael.kreuzer@nsn.com>,
       linux-mtd@lists.infradead.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] fix MTD CFI/LPDDR flash driver huge latency bug
Message-ID: <20100319084048.GA1670@shareable.org>
References: <1267894137.18869.0.camel@wall-e> <20100312142344.174bd46f.akpm@linux-foundation.org> <20100312233820.GH6491@shareable.org> <1268483744.6339.25.camel@wall-e> <20100315030338.GR6491@shareable.org> <1268633754.6012.4.camel@wall-e.seibold.net> <20100315142421.GB15133@shareable.org> <1268987355.4028.33.camel@macbook.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268987355.4028.33.camel@macbook.infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> Rather than pulling a number our of our posterior like "every 256 bytes"
> which might _really_ screw up performance of some architectures' memcpy
> routines, I suspect we might want the platform to provide an optimised
> "sleepable_memcpy" function which does it at whatever interval is
> appropriate for the memcpy routine in use. Or magically makes it
> preemptable. Or uses a DMA engine. Or whatever.
>
> I wonder where else we could use such a function...

The posterior number isn't great, although I don't see how it would
really harm memcpy performance to check current->need_resched even
quite often.

In this instance, the speed depends on the flash which can be as much
as 100x slower than RAM - that's the particular situation where it
might be most useful to split the copies.

Other uses of sleepable_memcpy you may be thinking of could be
operating on RAM only, so the number should be 100x larger for them.

In other words, "whatever interval is appropriate for memcpy" does not
exist, and could not be hard-coded into sleepable_memcpy.  It's
whatever interval is appropriate for the particular memory being
copied, so it would have to be a parameter.

-- Jamie
