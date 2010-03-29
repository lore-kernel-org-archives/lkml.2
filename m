Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0C2UJl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:09:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:36973 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753509Ab0C2UJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:09:38 -0400
Date: Mon, 29 Mar 2010 22:09:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu,
       Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/2] perf: Use LBR for machine/oops debugging
Message-ID: <20100329200934.GF20695@one.firstfloor.org>
References: <20100329122021.765109681@chello.nl> <87bpe7qnrg.fsf@basil.nowhere.org> <1269872059.12097.338.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269872059.12097.338.camel@laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 04:14:19PM +0200, Peter Zijlstra wrote:
> On Mon, 2010-03-29 at 15:08 +0200, Andi Kleen wrote:
> > Peter Zijlstra <a.p.zijlstra@chello.nl> writes:
> > 
> > > The LBRs are relatively cheap to keep enabled and provide some history
> > > to OOPSen, also some CPUs are reported to keep them over soft-reset,
> > > which allows us to use them to debug things like tripple faults.
> > >
> > > Therefore introduce a boot option: lbr_debug=on, which always enable
> > > the LBRs and will print the LBRs on CPU init and die().
> > 
> > 
> > die is too late. they will only contain the oops code then.
> 
> We do an lbr_off() in oops_begin(), or is there a better/earlier place
> we can do that?

I had an old patch in the P4 era (slightly different but larger LBRs) which
saved them all early in the exception handlers and then dumped
them from the buffer. That's early enough that you only miss one or two.

The problem is that it's somewhat more expensive, the MSR reads
are not cheap and they will slow down all your page faults.

I checked, but I can't find the old patch anymore. Could be probably
redone. 

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
