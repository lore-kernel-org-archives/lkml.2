Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab1HWWNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:13:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58307 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754982Ab1HWWNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:13:42 -0400
Date: Tue, 23 Aug 2011 23:13:14 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
Message-ID: <20110823221314.GL3895@n2100.arm.linux.org.uk>
References: <20110823151936.GM9232@opensource.wolfsonmicro.com> <201108232351.55432.rjw@sisk.pl> <CAOS58YNUSn2eVLDLzqKmrtL7M5tSetkhZ1ODecLK54NSDnZVAA@mail.gmail.com> <20110823220056.GK3895@n2100.arm.linux.org.uk> <CAOS58YNuCbaOsWBfmjSUsXsArZ5ng6c0B30yswFbRAWkho6L6Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOS58YNuCbaOsWBfmjSUsXsArZ5ng6c0B30yswFbRAWkho6L6Q@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 12:08:23AM +0200, Tejun Heo wrote:
> On Wed, Aug 24, 2011 at 12:00 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > How does that solve it?  IRQs disabled from assembly, which doesn't touch
> > the preempt counter.
> 
> Then test something else, be it the IRQ mask bit or some other context.

Thereby entirely preventing threads from being frozen?  You're asking
me to effectively disable suspend/resume on an architecture where it's
heavily used.  That's not a good idea, and would be an out-right
regression.
