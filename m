Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab0FXL6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 07:58:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35105 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171Ab0FXL6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 07:58:40 -0400
Date: Thu, 24 Jun 2010 13:58:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Ingo Molnar <mingo@elte.hu>, "H.PeterA" <"nvin hpa"@zytor.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] irq_work
Message-ID: <20100624115838.GG578@basil.fritz.box>
References: <1277364453.3947.64.camel@yhuang-dev.sh.intel.com>
 <1277364727.1875.857.camel@laptop>
 <20100624102725.GA578@basil.fritz.box>
 <1277375409.1875.943.camel@laptop>
 <20100624105254.GB578@basil.fritz.box>
 <1277377121.1875.948.camel@laptop>
 <20100624110830.GC578@basil.fritz.box>
 <1277377852.1875.950.camel@laptop>
 <20100624112040.GD578@basil.fritz.box>
 <1277379731.1875.961.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277379731.1875.961.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 01:42:11PM +0200, Peter Zijlstra wrote:
> On Thu, 2010-06-24 at 13:20 +0200, Andi Kleen wrote:
> > Ok so going back to the original self-irq patchkit. Unfortunately the other
> > reviewer hated that. How to get out of that deadlock?
> 
> Well, I didn't like your original patch either.
> 
> What's wrong with going with the patch I posted today? (aside from me
> getting the barriers slightly wrong and not doing the arch
> implementation).

Well it would need to work.

Also I personally didn't see the point of the irq items list because
there's no good way to dynamically allocate it in a NMI, so the window
would be always "fixed size" anyways and you could as well just use 
per cpu data.

That's why for simple self irq I preferred Ying's original patch.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
