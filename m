Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab0EZWCn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 18:02:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37115 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752996Ab0EZWCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 18:02:40 -0400
Date: Wed, 26 May 2010 23:09:43 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Florian Mickler <florian@mickler.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100526230943.6f5e5b37@lxorguk.ukuu.org.uk>
In-Reply-To: <20100526215409.33296d94@schatten.dmk.lab>
References: <20100526171106.0e44a736@schatten.dmk.lab>
	<alpine.LFD.2.00.1005261829540.2995@localhost.localdomain>
	<20100526215409.33296d94@schatten.dmk.lab>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > suspend blockers are completely backwards as they basically disable
> > the kernels ability to do resource management.
> 
> I don't think this is a defect in the approach but the point of it. 

I think it's both. It's the point of it, and that itself is a defect. Its
designed wrongly.

> drivers code is needed anyway. What looses the kernel by implementing
> suspend blockers, and later a more finegrained approach and mapping the
> userspace part of suspend blockers on that finegrained approach later
> on?

The Linux approach is to do the job right. That means getting the
interface right and so it works across all the interested parties (or as
close as we can get).

> >   - how much delay of wakeups is tolerated (missing interface)
> 
> Doesn't solve the segregation problem and is probably overkill for most
> applications. I see this as an orthogonal thing (i.e. not
> affecting this merge). 

The key question that matters for suspend management is 'what wakeup
delay is tolerated'. So it's absolutely fundamental.

> True. But I wouldnt say, that it is the linux kernel who should force
> this politics onto its users.

This is the Linux way of doing things. It's like the GPL and being
shouted at by Linus. They are things you accept when you choose to take
part. Google chose to use Linux, if they want a feature upstream then the
way you get it there is to figure out how to solve the real problem and
make *everyone* (within reason) happy.

We now have suggestions how to do the job properly so the right thing is
probably to go and explore those suggestions not merge crap.

Merging crap won't help anyway. The rest of the kernel community can
still simply stonewall those interfaces, and a volunteer community has
ways of dealing with abuse of process, notably by simply not getting
around to, or implementing things directly contrary to the crap bits.

So it's not even in the interest of people to play political games. Even
if you get away with in the short term the people who rely on the junk
will end up out on a limb and holding the baby when the crap hits the fan
(see reiserfs)

Alan
