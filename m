Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab0HAGtq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 02:49:46 -0400
Received: from swm.pp.se ([212.247.200.143]:54969 "EHLO uplift.swm.pp.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751203Ab0HAGtp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 02:49:45 -0400
Date: Sun, 1 Aug 2010 08:49:43 +0200 (CEST)
From: Mikael Abrahamsson <swmike@swm.pp.se>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Arjan van de Ven <arjan@infradead.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
In-Reply-To: <alpine.DEB.1.10.1008010812450.24755@uplift.swm.pp.se>
Message-ID: <alpine.DEB.1.10.1008010838430.24755@uplift.swm.pp.se>
References: <20100731175841.GA9367@linux.vnet.ibm.com> <20100731215214.2543c07e@infradead.org> <20100801054816.GI2470@linux.vnet.ibm.com> <alpine.DEB.1.10.1008010812450.24755@uplift.swm.pp.se>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
Organization: People's Front Against WWW
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Aug 2010, Mikael Abrahamsson wrote:

> it's just that mobile (low power) wasn't the intended target of the 
> application when it was written, and this commonly shows.

I have another aspect I just thought about. I work for a telephony 
company. We provide Internet connectivity throught various means, DSL, 
Ethernet to the Home, mobile etc.

For ETTH and DSL, network usage is pretty straight forward, you send 
packets, they get delivered pretty quickly with low marginal cost per 
packet. For mobile, this is not quite so simple. Mobile networks are 
designed for terminal/UE (user equipment) to use low power, so they go 
down in low power state after a while. Let's take the case of 3G/HSPA:

After a short while (second) of idleness (no packets being sent), the 
mobile network negotiates away the high speed resources (the one that 
enables multimegabit/s transfers) and tries to give it to someone else. 
After approximately 30 seconds, the terminal goes to "idle", meaning it 
has no network resources at all. Next time it wants to send something (or 
the network wants to deliver something to it), network resources need to 
be negotiated again. This can take 1-2 seconds and uses battery power of 
course. It also consumes resources in the operator network (because 
mobility control units need to talk to base stations, tunnels need to be 
re-negotiated etc).

Anyhow, my point is that not only is there a benefit in having multiple 
applications wake up at the same time for power reasons within the device, 
there is also a point in having coordination of their network access. If a 
device is running 3 IM programs at the same time, it'd be beneficial if 
they were coordinated in their communication with their Internet servers. 
Same goes for the "check for new email" application. If they all were 
optimized to only wake up the network connectivity once every 180 seconds 
instead of doing it when the individual application felt like it, power 
and other resources would be saved by all involved parties.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
