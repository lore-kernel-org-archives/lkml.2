Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757773Ab1KKAr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 19:47:58 -0500
Received: from infernal.debian.net ([87.230.26.131]:41750 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336Ab1KKAr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 19:47:57 -0500
Date: Fri, 11 Nov 2011 01:47:52 +0100
From: Andreas Bombe <aeb@debian.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] perf merge breaks resume from standby, bisected
Message-ID: <20111111004752.GA4412@amos.fritz.box>
References: <20111101173847.GA4142@amos.fritz.box>
 <20111110145319.GB29614@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111110145319.GB29614@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 10, 2011 at 03:53:20PM +0100, Ingo Molnar wrote:
> 
> * Andreas Bombe <aeb@debian.org> wrote:
> 
> > I found that resuming from suspend to memory stopped working with the
> > recent merges to mainline after 3.1. I have observed different modes of
> > failure even with the same version. Most often I just get the blinking
> > caps/scroll lock LEDs on the keyboard and no video output.
> > 
> > Sometimes I get the normal text output from a resume ending with an oops
> > dump. It has been mostly NULL pointer dereferences, but I think there
> > was a scheduling in atomic context at one time. I have a photo of the
> > NULL deref on the latest kernel attached, according to gdb the IP points
> > to the return statement of the event_sched_out() function.
> > 
> > Anyway, I bisected the problem down to 144060f "perf: Add PM notifiers
> > to fix CPU hotplug races". The hardware is a Core 2 Duo E8500 on an Asus
> > P5Q, config attached.
> 
> v3.2-rc1 should have this resolved, the commit got reverted.

Thanks, but I already knew since I saw that thread. FWIW, the revert did
fix the problem.

-- 
Andreas Bombe
