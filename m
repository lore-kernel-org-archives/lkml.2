Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894Ab1JXS5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 14:57:10 -0400
Received: from mail.elliptictech.com ([209.217.122.41]:55599 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab1JXS5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 14:57:09 -0400
Date: Mon, 24 Oct 2011 14:57:07 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] kmemleak: Report previously found leaks even after
 an error
Message-ID: <20111024185707.GA3399@elliptictech.com>
References: <20110929105940.10660.76130.stgit@e102109-lin.cambridge.arm.com>
 <20110929110239.10660.95998.stgit@e102109-lin.cambridge.arm.com>
 <20111004174548.GA16209@elliptictech.com>
 <CAHkRjk58zQF4ZxvH4Ex-sUpe9Wmhvt0xo5Juffq=DrpySE556Q@mail.gmail.com>
 <20111004211446.GA19503@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111004211446.GA19503@elliptictech.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-10-04 17:14 -0400, Nick Bowler wrote:
> On 2011-10-04 21:50 +0100, Catalin Marinas wrote:
> > On 4 October 2011 18:45, Nick Bowler <nbowler@elliptictech.com> wrote:
> > > Cool, I'll try this out.  Kmemleak rarely stays alive for more than a
> > > few days on my desktop before shutting itself down due to an allocation
> > > failure, so this should be really handy.
> > 
> > You can have a look at /proc/slabinfo and meminfo and see if there are
> > any really big leaks. In general the kmemleak objects number is higher
> > than the sum of all the other slab objects (but I haven't done any
> > statistics). Hopefully kmemleak doesn't leak memory :) (I should add
> > some simple checks though).
> 
> I don't think the failures that cause kmemleak to shut down in my case
> are actually caused by a memory leak.  The machine is rather old and
> has only 1G of RAM.  I think kmemleak is just failing to allocate during
> a period of real memory pressure.

FWIW, I applied this patch on top of 3.0.7 and I can successfully read
the debugfs entry after kmemleak shuts down.

Thanks,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
