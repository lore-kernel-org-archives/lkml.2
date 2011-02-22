Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab1BVXH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 18:07:26 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37067 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751165Ab1BVXHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 18:07:25 -0500
Date: Tue, 22 Feb 2011 23:07:24 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: john stultz <johnstul@us.ibm.com>
Cc: rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Subject: Re: [rtc-linux] [PATCH 04/10] RTC: Cleanup
	rtc_class_ops->read_alarm()
Message-ID: <20110222230724.GK31611@opensource.wolfsonmicro.com>
References: <1298343333.4222.36.camel@work-vm> <1298362178.4222.57.camel@work-vm> <20110222181647.GA25569@opensource.wolfsonmicro.com> <1298404268.9215.39.camel@work-vm> <20110222200046.GD31611@opensource.wolfsonmicro.com> <1298406174.9215.71.camel@work-vm> <20110222210522.GG31611@opensource.wolfsonmicro.com> <1298409673.9215.84.camel@work-vm> <20110222213319.GI31611@opensource.wolfsonmicro.com> <1298412634.9215.110.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298412634.9215.110.camel@work-vm>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 02:10:34PM -0800, john stultz wrote:

> Although For me, I see multiplexing events becoming too useful a bit of
> functionality to offload to a userland API. Especially since there might
> be conflicting approaches to the userland coordination (Want to open a
> file? There's one call you have to make. Want to draw a on the screen?
> Well, there's X or fb or maybe wayland, etc).

Of course one can equally make the argument that this sort of
multiplexing decision is policy and the multiple independant
ideas for how it should work suggests we shouldn't be picking something
for them.  I don't feel *that* strongly about it, though.

> Now, your observation about the behavior of persistence over reboots is
> a interesting corner-case that I overlooked. And I do want to address
> that as best we can, but I think it is an unreasonable expectation for
> applications to have, given that much common hardware doesn't support
> it.

What would probably help here if we're going to keep this support in
would be to make the current state and perhaps also the underlying
hardware features more discoverable.  That way userspace can preserve
the state when shutting down if it wants to.
