Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754879Ab0FXK6s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 06:58:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:46130 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab0FXK6r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 06:58:47 -0400
Subject: Re: [RFC][PATCH] irq_work
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
       "H.PeterA" <"nvin hpa"@zytor.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100624105254.GB578@basil.fritz.box>
References: <1277361791.3947.11.camel@yhuang-dev.sh.intel.com>
	 <1277362073.1875.839.camel@laptop>
	 <1277362243.3947.20.camel@yhuang-dev.sh.intel.com>
	 <1277362680.1875.845.camel@laptop>
	 <1277363069.3947.30.camel@yhuang-dev.sh.intel.com>
	 <1277363993.1875.847.camel@laptop>
	 <1277364453.3947.64.camel@yhuang-dev.sh.intel.com>
	 <1277364727.1875.857.camel@laptop> <20100624102725.GA578@basil.fritz.box>
	 <1277375409.1875.943.camel@laptop>  <20100624105254.GB578@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 24 Jun 2010 12:58:41 +0200
Message-ID: <1277377121.1875.948.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-24 at 12:52 +0200, Andi Kleen wrote:
> > Right, in that case I would very much prefer the simpler thing I
> > proposed over all this softirq stuff, we can have the tick process the
> > callbacks for really broken hardware (perf_events doesn't care since
> > without a lapic there's no pmi anyway).
> 
> Ying's approach will work I think. 

Right, except that I really dislike it, it touches far too much code for
no particular reason.

And I really want hardirq context for perf callbacks, some code actually
relies on it (I used to have the fallback in the timer softirq and that
broke thing at some point).

So I'm really opposed to all the softirq molestation as I see no reason
to do that at all.


