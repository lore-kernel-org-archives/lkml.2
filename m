Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab0EaWnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 18:43:43 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:46917 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab0EaWnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 18:43:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NEZpAMpBmJZOAP0ZjhvKBfqRKjqE+7S+OJgmpaLHPDxYjHcfHYqPP83903PXnL1Wnl
         ekAmy3z6tnFpJcmLLd+IfN0fnhTjCRqVpuYQwPEgaV6DW/1VU2eYlX/r1stfMAS8Ahhi
         qc5fqwY/O6va6zG1j0jp5Ns93KDUpK7Ce5XEg=
Date: Mon, 31 May 2010 15:43:55 -0700
From: mark gross <640e9920@gmail.com>
To: Florian Mickler <florian@mickler.org>
Cc: linux-kernel@vger.kernel.org, markgross@thegnar.org, 640e9920@gmail.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Brian Swetland <swetland@google.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       mark.gross@intel.com
Subject: Re: [RFC] lp_events: an lternitive to suspend blocker user mode
 and kernel API
Message-ID: <20100531224355.GD31155@gvim.org>
Reply-To: markgross@thegnar.org
References: <20100530200409.GA21632@gvim.org>
 <20100531095753.4c174f2d@notabene.brown>
 <20100531084356.272f3e1a@schatten.dmk.lab>
 <20100531100545.658a35b7@schatten.dmk.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100531100545.658a35b7@schatten.dmk.lab>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 10:05:45AM +0200, Florian Mickler wrote:
> On Mon, 31 May 2010 08:43:56 +0200
> Florian Mickler <florian@mickler.org> wrote:
> 
> > On Mon, 31 May 2010 09:57:53 +1000
> > Neil Brown <neilb@suse.de> wrote:
> > 
> > > 2/ Rather than tracking wake-events from the hardware up through possibly
> > >    several kernel modules, you go directly from hardware to user-space so each
> > >    event is potentially presented to user-space twice: once as a "wake up
> > >    from low power state" event and once following the normal path (maybe a
> > >    key-press event, maybe a serial-port event, maybe a network receive event).
> > >    I can see that this is a very tempting approach.  It allows all those
> > >    intermediate modules to remain unchanged and that is good.
> > >    However it isn't clear to me that this would be easy for user-space to use
> > >    correctly.
> > >    When an lpe event arrived it would need to wait around for the real event
> > >    to arrive and then process that.  I probably wouldn't wait long, but it
> > >    would be an indeterminate wait, and it might not be  trivial to determine
> > >    if all events that would cause a wake-up have been consumed as a direct
> > >    mapping from lpe event to normal event may not always be possible.
> > >    Maybe this is more of a theoretical problem and in practice it would be
> > >    easy to get it right - I don't have enough concrete experience to be sure.
> > > 
> > >    So: I like the idea of leaving the intermediate layers unchanged, but I'm
> > >    not convinced it would work.
> > 
> > To add to this: Is it a correct assumption
> > that all wake-up events that leave a driver trickle eventually up to
> > userspace?
> > 
> > I think splitting the actual driver product (i.e. keypress or whatever)
> > of a wake-up-event and it's corresponding wake-lock is not possible.
> > Because you would have to _somehow_ map the block back to the product
> > when you consume the product. 
> > 
> > If you want to abstract the blocking from the kernel-code you probably
> > have to introduce an abstract "driver-product" entity where you can do
> > all your blocking associated with the product but hidden from the code
> > that uses the product. (Which I don't think is feasible, because it
> > increases overhead)
> > 
> > Or am I on the wrong track here? 
> 
> I just realized, that you can cancel lpe_blocks via delete_lpe_block(),
> so this is not an issue at all.
> They can be used just like suspend blockers. 
> 
> Also the mapping of lpe_block to "wake event" is the same problem as
> with the suspend_blockers... 
> 
> So I don't think this is a bad idea after all. It decouples the
> suspend_blockers from "suspend" quite nicely. 
> Although it still is only "block" or "no block" and not, as was
> suggested some sort of more fine grained requirement definition.

I attempted to add level's of blocking but I honestly don't see a use
for the levels at the moment.  I'm sure there is some better
genralization possible.

--mgross

 
> Cheers,
> Flo
