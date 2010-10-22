Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752401Ab0JVCFO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 22:05:14 -0400
Received: from mga01.intel.com ([192.55.52.88]:14485 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750975Ab0JVCFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 22:05:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.58,221,1286175600"; 
   d="scan'208";a="619165299"
Subject: Re: [PATCH -v3 5/6] x86, NMI, treat unknown NMI as hardware error
From: Huang Ying <ying.huang@intel.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>,
        "peterz@infradead.org" <peterz@infradead.org>
In-Reply-To: <20101022014955.GP19090@redhat.com>
References: <1286606987-19879-1-git-send-email-ying.huang@intel.com>
	 <1286606987-19879-5-git-send-email-ying.huang@intel.com>
	 <20101011212006.GB23882@redhat.com> <1287555157.3026.21.camel@yhuang-dev>
	 <20101020141558.GB19090@redhat.com> <1287623643.19320.40.camel@yhuang-dev>
	 <20101021023135.GA12086@redhat.com> <1287638251.19320.190.camel@yhuang-dev>
	 <20101021141002.GI19090@redhat.com>
	 <20101021154543.GD21695@basil.fritz.box>
	 <20101022014955.GP19090@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Oct 2010 10:05:10 +0800
Message-ID: <1287713110.2862.54.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-22 at 09:49 +0800, Don Zickus wrote:
> On Thu, Oct 21, 2010 at 05:45:44PM +0200, Andi Kleen wrote:
> > On Thu, Oct 21, 2010 at 10:10:02AM -0400, Don Zickus wrote:
> > > On Thu, Oct 21, 2010 at 01:17:31PM +0800, Huang Ying wrote:
> > > > > > But there is some general rules for unknown NMI. We think unknown NMI is
> > > > > > hardware error notification on all systems except systems with broken
> > > > > > hardware or software bugs, stone age machines. Do you agree with that?
> > > > > 
> > > > > Nope.  In my experiences, most of our customers are still running
> > > > > pre-Nehalem boxes, therefore most unknown NMIs are from broken hardware or
> > > > > bad firmware (at least in the bugzillas I deal with).
> > > > 
> > > > It seems that we have different point of view for reason of unknown NMI.
> > > > Should broken hardware be seen as hardware error?
> > > 
> > > Well, do you have an alternative way to handle broken hardware?  Broken
> > > hardware has generated NMIs, sometimes if I am lucky SERRs.  The ones that
> > > generate SERRs can be filtered through a different path, but what about
> > > the ones that don't?
> > > 
> > 
> > Don, AFAIK you're saying the same thing as Ying: an unknown NMI is 
> > a hardware error.
> > 
> > The reason the hardware does that is that it wants to tell us:
> > 
> > "I lost track of an error. There is corrupted data somewhere in the system.
> > Please stop, don't do anything that could consume that data. S.O.S."
> > 
> > The correct answer for that is panic.
> 
> After re-reading Huang's patch, I am starting to understand what you mean
> by broken hardware.  Basically you are trying to distinguish between
> legacy systems that were 'broken' in the sense they would randomly send
> uknown NMIs for no good reason, hence the 'Dazed and confused' messages
> and hardware errors on more modern systems that say, 'Hardware error,
> panicing check your BIOS for more info' (or whatever).

Yes.

> So Huang's patch was sort of acting like a switch.  On legacy systems use
> 'Dazed and confused' for unknown NMIs.  Whereas on whitelisted modern
> systems use a more relavant 'Check BIOS for error' message.  Is that
> right?

In fact we want to go panic and 'check BIOS for error, contact your
hardware vendor' for all systems. But as you said, there are some
'broken hardware' randomly send unknown NMIs for no good reason. So a
white list is used for them. And not all pre-Nehalem machines are
'broken' in fact.

> That's why you guys are complaining that registering a die_notifier would
> be silly?

I think whether going die_notifier or unknown_nmi_error() depends on it
is general or specific for some hardware. Do you agree with that?

Best Regards,
Huang Ying


