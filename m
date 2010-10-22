Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab0JVFYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 01:24:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:32503 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646Ab0JVFYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 01:24:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,221,1286175600"; 
   d="scan'208";a="566368794"
Subject: Re: [PATCH -v3 5/6] x86, NMI, treat unknown NMI as hardware error
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>,
        "peterz@infradead.org" <peterz@infradead.org>
In-Reply-To: <20101022025657.GA10556@redhat.com>
References: <20101011212006.GB23882@redhat.com>
	 <1287555157.3026.21.camel@yhuang-dev> <20101020141558.GB19090@redhat.com>
	 <1287623643.19320.40.camel@yhuang-dev> <20101021023135.GA12086@redhat.com>
	 <1287638251.19320.190.camel@yhuang-dev> <20101021141002.GI19090@redhat.com>
	 <20101021154543.GD21695@basil.fritz.box>
	 <20101022014955.GP19090@redhat.com> <1287713110.2862.54.camel@yhuang-dev>
	 <20101022025657.GA10556@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Oct 2010 13:23:57 +0800
Message-ID: <1287725037.2862.84.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-22 at 10:56 +0800, Don Zickus wrote:
> On Fri, Oct 22, 2010 at 10:05:10AM +0800, Huang Ying wrote:
> > > > > Well, do you have an alternative way to handle broken hardware?  Broken
> > > > > hardware has generated NMIs, sometimes if I am lucky SERRs.  The ones that
> > > > > generate SERRs can be filtered through a different path, but what about
> > > > > the ones that don't?
> > > > > 
> > > > 
> > > > Don, AFAIK you're saying the same thing as Ying: an unknown NMI is 
> > > > a hardware error.
> > > > 
> > > > The reason the hardware does that is that it wants to tell us:
> > > > 
> > > > "I lost track of an error. There is corrupted data somewhere in the system.
> > > > Please stop, don't do anything that could consume that data. S.O.S."
> > > > 
> > > > The correct answer for that is panic.
> > > 
> > > After re-reading Huang's patch, I am starting to understand what you mean
> > > by broken hardware.  Basically you are trying to distinguish between
> > > legacy systems that were 'broken' in the sense they would randomly send
> > > uknown NMIs for no good reason, hence the 'Dazed and confused' messages
> > > and hardware errors on more modern systems that say, 'Hardware error,
> > > panicing check your BIOS for more info' (or whatever).
> > 
> > Yes.
> > 
> > > So Huang's patch was sort of acting like a switch.  On legacy systems use
> > > 'Dazed and confused' for unknown NMIs.  Whereas on whitelisted modern
> > > systems use a more relavant 'Check BIOS for error' message.  Is that
> > > right?
> > 
> > In fact we want to go panic and 'check BIOS for error, contact your
> > hardware vendor' for all systems. But as you said, there are some
> > 'broken hardware' randomly send unknown NMIs for no good reason. So a
> > white list is used for them. And not all pre-Nehalem machines are
> > 'broken' in fact.
> 
> Ok, I think I finally understand what you guys are trying to do.  I also
> can't see a problem with it.  

Thanks.

> Though I think the patch could probably use
> some clean up to make it more clear.  Off the top of my head perhaps a
> function call that sets the variable unknown_nmi_as_hwerr instead of
> setting it explicitly and maybe structuring unknown_nmi() with an if-then
> modern-message; else legacy-message; to possibly make it obvious what the
> code is trying to acheive.

OK. Will do it.

> And yeah I know not all pre-Nehalem machines are broken.  I am usually
> sarcastic when I mention that just because being at IDF last year, I got
> the impression that pre-Nehalem machines were considered the dark ages.
> :-)

Haha

> I am actually curious to know how many x86_64 machines would be considered
> broken?

Don't know either.

> > > That's why you guys are complaining that registering a die_notifier would
> > > be silly?
> > 
> > I think whether going die_notifier or unknown_nmi_error() depends on it
> > is general or specific for some hardware. Do you agree with that?
> 
> Well I am hoping the only general case would be the one you want to use
> now.  Everything else would be specific and require a die_notifier.  I
> mean how many different ways do we want to have a printk/panic in
> unknown_nmi()?

I think this one should be the only one for general unknown NMI
processing.

Best Regards,
Huang Ying


