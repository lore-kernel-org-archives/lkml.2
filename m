Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab1HYMfu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 08:35:50 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37329 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217Ab1HYMfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 08:35:46 -0400
Date: Thu, 25 Aug 2011 14:35:42 +0200
From: Tejun Heo <tj@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
Message-ID: <20110825123542.GM3286@htj.dyndns.org>
References: <20110823151936.GM9232@opensource.wolfsonmicro.com>
 <201108232351.55432.rjw@sisk.pl>
 <CAOS58YNUSn2eVLDLzqKmrtL7M5tSetkhZ1ODecLK54NSDnZVAA@mail.gmail.com>
 <20110823220056.GK3895@n2100.arm.linux.org.uk>
 <CAOS58YNuCbaOsWBfmjSUsXsArZ5ng6c0B30yswFbRAWkho6L6Q@mail.gmail.com>
 <20110823221314.GL3895@n2100.arm.linux.org.uk>
 <CAOS58YNtQEuke=Ko9J2oNGMECjabzxj=Nrg1o64X1JC3YRmJuw@mail.gmail.com>
 <20110825121416.GB8883@n2100.arm.linux.org.uk>
 <20110825121710.GK3286@htj.dyndns.org>
 <20110825122543.GC8883@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825122543.GC8883@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 25, 2011 at 01:25:43PM +0100, Russell King - ARM Linux wrote:
> No.  Stop bodging and hiding problems.  Anywhere which does this:
> 
> 	local_irq_enable();
> 	do something
> 	local_irq_disable();
> 
> is a bug.  Things are called with IRQs disabled for a reason - randomly
> re-enabling IRQs does not "fix" stuff, it merely introduces subtle bugs
> while hiding warnings of those bugs.
> 
> Please go back and read my response to Mark at the beginning of this
> thread, where I describe why IRQs are disabled here.
> 
> The only solution here is to fix the problem properly, and I'm working
> on a patch to fix the problem I highlighted in my earlier response to
> Mark.  Once we have that problem fixed, we can then (more) safely call
> do_signal() with IRQs enabled.

Arrrrrrrrgghhhhhhhhhhhh, why is communication so difficult with you?
When did I ever suggest that as a proper fix.  ARM is frigging broken
in that path so don't push it over to PM and just deal with it inside
ARM arch code.  For now, we need to make the warning go away until
it's properly fixed so turn off and on IRQ around
get_signal_to_deliver() and mark it with giant FIXME comment.  How
many times did I write that?  I don't know how to make that any
clearer to you.  Gees...

-- 
tejun
