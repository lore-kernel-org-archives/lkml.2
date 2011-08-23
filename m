Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755046Ab1HWWBV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:01:21 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37073 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab1HWWBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:01:16 -0400
Date: Tue, 23 Aug 2011 23:00:56 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
Message-ID: <20110823220056.GK3895@n2100.arm.linux.org.uk>
References: <20110823151936.GM9232@opensource.wolfsonmicro.com> <201108232351.55432.rjw@sisk.pl> <CAOS58YNUSn2eVLDLzqKmrtL7M5tSetkhZ1ODecLK54NSDnZVAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOS58YNUSn2eVLDLzqKmrtL7M5tSetkhZ1ODecLK54NSDnZVAA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 11:53:42PM +0200, Tejun Heo wrote:
> Hello,
> 
> On Tue, Aug 23, 2011 at 11:51 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >> and the boot runs very slowly.  Reverting the series merged in 56f0be
> >> appears to resolve the issue,
> >
> > In fact, the patch from:
> >
> > https://patchwork.kernel.org/patch/1083602/
> >
> > is sufficient to make the calltrace go away.
> 
> Yes, that's true but the added might_sleep() discovered an actual bug
> here, so I still think it's better to keep it there.
> 
> If proper fix is difficult, I think doing something like if
> (!in_atomic()) try_to_freeze() with big fat warning explaining what's
> broken and how it should be fixed should do it for now if the proper
> fix is gonna take some time. That way, we document what's broken where
> it's broken and get to keep the useful debugging annotation.

How does that solve it?  IRQs disabled from assembly, which doesn't touch
the preempt counter.
