Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758767Ab1DNNkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 09:40:06 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41206 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab1DNNkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 09:40:04 -0400
Date: Thu, 14 Apr 2011 09:39:58 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
X-X-Sender: nico@xanadu.home
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, lkml <linux-kernel@vger.kernel.org>,
        Dima Zavin <dmitriyz@google.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>,
        =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2] Common struct clk implementation, v14
In-Reply-To: <20110414120904.GH1611@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.00.1104140920110.24613@xanadu.home>
References: <1299134429.100626.661279191478.0.gpush@pororo> <1302754859.2767.30.camel@pororo> <20110414100048.GB1611@n2100.arm.linux.org.uk> <1302776705.28876.113.camel@pasglop> <20110414103200.GF1611@n2100.arm.linux.org.uk> <alpine.LFD.2.00.1104140751220.24613@xanadu.home>
 <20110414120904.GH1611@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011, Russell King - ARM Linux wrote:

> On Thu, Apr 14, 2011 at 07:59:58AM -0400, Nicolas Pitre wrote:
> > Quoting Linus:
> > 
> > | Umm. The whole "number of lines of code" thing has become a total red
> > | herring.
> > | 
> > | THAT IS NOT WHY I STARTED TO COMPLAIN!
> > | 
> > | The reason I point out the number of lines of code is because it's one
> > | of the more obvious _symptoms_ of the problem.
> > 
> > So we need to work on infrastructure, and the clock API is exactly that.  
> > Obviously adding it will increase the number of lines of code initially, 
> > but eventually this will help _reduce_ them, and more importantly it 
> > will allow for the reduction of mindless duplication of code that was 
> > identified as being the actual problem causing maintenance pain.
> 
> Adding it without anyone using it doesn't solve anything.  We need
> people to commit to producing patches to use it for the next merge
> window.

People are simply waiting for the API to hit some upstream tree (like 
yours) before committing to it.  You would be in a much better position 
if those patches are in your tree, so that you can tell people: "Here's 
the Git branch with the API in it, so now I'm expecting patches to 
convert clock users to it".

> And if you think its not about lines of code - grab the current linux-next
> tree and look at the diff between v2.6.39-rc1 and master for arch/arm, and
> then tell me whether using LOC is unreasonable given the patch content.

I might have a look later.  However it is clear that the ARM tree will 
_never_ be as small as, say, X86 or even PPC given the indisputable 
amount of hardware variations within the ARM landscape that is not to be 
seen anywhere else.  Until the ARM ecosystem converge towards a single 
whole-system architecture we won't be able to match X86 in terms of code 
reduction.  Anyone thinking otherwise is living in a different universe.

However we can and must do better in consolidation work in order to make 
the tree more maintainable of course.  _That_ is the real issue and 
_that_ is what the ARM tree sucks at.  The fact that this consolidation 
work might reduce the size of the ARM code is only a side effect, not 
the primary goal.  So let's not get too hung up about LOC but focus on 
improving the infrastructure instead.


Nicolas
