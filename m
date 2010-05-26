Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997Ab0EZTyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 15:54:16 -0400
Received: from ist.d-labs.de ([213.239.218.44]:46760 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756695Ab0EZTyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 15:54:14 -0400
Date: Wed, 26 May 2010 21:54:09 +0200
From: Florian Mickler <florian@mickler.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Vitaly Wool <vitalywool@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, felipe.balbi@nokia.com,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100526215409.33296d94@schatten.dmk.lab>
In-Reply-To: <alpine.LFD.2.00.1005261829540.2995@localhost.localdomain>
References: <20100526171106.0e44a736@schatten.dmk.lab>
	<alpine.LFD.2.00.1005261829540.2995@localhost.localdomain>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 May 2010 19:22:16 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> Florian,
> 
> On Wed, 26 May 2010, Florian Mickler wrote:
> >
> > On the other hand, applications can say, they don't need that much
> > power and userspace guaranties and not take a suspend blocker.
> > 
> > This is an option which they currently don't have.
> 
> Wrong. A well coded power aware application is very well able to
> express that in various ways already today. Admittedly it's far from
> perfect, but that can be fixed by adding interfaces which allow the
> power aware coder to express the requirements of his application
> actively, not by avoiding it.

Yeah, but a user can't say: "I don't
know programming, but I had this idea. Here try it out." 
to his friend. Because his friends phone then will crap out.

This is a negative. The phone just doesn't work well. 

A knowledgeable programmer is able to do extra work to enable specific
guarantees. A dummy-throw-away-programmer doesn't want to do
any extra work. 

> 
> suspend blockers are completely backwards as they basically disable
> the kernels ability to do resource management.

I don't think this is a defect in the approach but the point of it. 

> 
> Also they enforce a black and white scheme (suspend or run) on the
> kernel which is stupid, as there are more options to efficiently save
> power than those two. While current android devices might not provide
> them, later hardware will have it and any atom based device has them
> already.

This is true. Nonetheless, in my opinion, implementing the "backwards
approach" in any form (suspend blockers or some other sort of "sane"
interface) is necessary in the long run.  I also believe that Alan's
approach is the more flexible one. But I'm not in a position to judge
on this.

If it really is better and superior, I think userland will switch
over to it, as soon as it is possible to do it. The impact to the
drivers code is needed anyway. What looses the kernel by implementing
suspend blockers, and later a more finegrained approach and mapping the
userspace part of suspend blockers on that finegrained approach later
on?



> 
> So what the kernel needs to know to make better decisions are things
> like:
> 
>   - how much slack can timers have (exisiting interface)

I liked this idea of Arjan, to give some applications infinite timer
slack. But I don't know if it can made work in a "dummy proof" way.
(I.e. it is too complicated to get it right in general, except for the
"infinity" or not kind of tuning)

>   - how much delay of wakeups is tolerated (missing interface)

Doesn't solve the segregation problem and is probably overkill for most
applications. I see this as an orthogonal thing (i.e. not
affecting this merge). 

> 
> and probably some others. That information would allow the kernel to
> make better decisions versus power states, grouping timers, race to
> idle and other things which influence the power consumption based on
> the hardware you are running on.
> 
> > I don't think opportunistic suspend is a policy decision by the kernel.
> > it is something new. Something which currently only the android
> > userspace implements / supports. If you don't want to suspend while
> > looking at the bouncing-cow, you have to take a suspend blocker and
> > make yourself a user-visible power-eater, or don't do 
> > 
> > echo "opportunistic" > /sys/power/policy 
> > 
> > in the first place.
> > 
> > This "optionally being badly written, who cares?" is a new feature the
> > kernel can provide to applications. 
> 
> It's a misfeature which the kernel should not provide at all. It sends
> out the completely wrong message: Hey, we can deal with your crappy
> code, keep on coding that way.

I can't really say anything against that. Or anything in favor of it.  
Except that this is probably a really hard decision for Linus to
make. 

> 
> While this seems to sound cool to certain people in the mobile space,
> it's completely backwards and will backfire in no time. 

Maybe. It is something which seems to not come from the traditional
"linux distribution" model of software deployment, where you have a
party that codes and another party that packages that code. 

It instead is more targeted at the decentralised 3rd-party-app
approach under which windows is suffering.

> The power efficiency of a mobile device is depending on a sane overall
> software stack and not on the ability to mitigate crappy software in
> some obscure way which is prone to malfunction and disappoint users.

True. But I wouldnt say, that it is the linux kernel who should force
this politics onto its users.

> 
> Thanks,
> 
> 	tglx
