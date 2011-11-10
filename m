Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934982Ab1KJOzH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 09:55:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59764 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933896Ab1KJOzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 09:55:01 -0500
Date: Thu, 10 Nov 2011 15:53:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Bombe <aeb@debian.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] perf merge breaks resume from standby, bisected
Message-ID: <20111110145319.GB29614@elte.hu>
References: <20111101173847.GA4142@amos.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111101173847.GA4142@amos.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Bombe <aeb@debian.org> wrote:

> I found that resuming from suspend to memory stopped working with the
> recent merges to mainline after 3.1. I have observed different modes of
> failure even with the same version. Most often I just get the blinking
> caps/scroll lock LEDs on the keyboard and no video output.
> 
> Sometimes I get the normal text output from a resume ending with an oops
> dump. It has been mostly NULL pointer dereferences, but I think there
> was a scheduling in atomic context at one time. I have a photo of the
> NULL deref on the latest kernel attached, according to gdb the IP points
> to the return statement of the event_sched_out() function.
> 
> Anyway, I bisected the problem down to 144060f "perf: Add PM notifiers
> to fix CPU hotplug races". The hardware is a Core 2 Duo E8500 on an Asus
> P5Q, config attached.

v3.2-rc1 should have this resolved, the commit got reverted.

Thanks,

	Ingo
