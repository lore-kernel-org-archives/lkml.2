Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab0EXQVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 12:21:39 -0400
Received: from relay1.sgi.com ([192.48.179.29]:48277 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757721Ab0EXQVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 12:21:36 -0400
Date: Mon, 24 May 2010 11:21:24 -0500
From: Russ Anderson <rja@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Borislav Petkov <bp@amd64.org>, "Luck, Tony" <tony.luck@intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       "Young, Brent" <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>, Ingo Molnar <mingo@elte.hu>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>, rja@sgi.com
Subject: Re: Hardware Error Kernel Mini-Summit
Message-ID: <20100524162124.GB7145@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <4BF2392A.9040409@jp.fujitsu.com> <4BF2C3D1.10009@redhat.com> <1274204560.17703.82.camel@Joe-Laptop.home> <20100518185305.GA23921@elte.hu> <987664A83D2D224EAE907B061CE93D53C61D1C57@orsmsx505.amr.corp.intel.com> <20100518191802.GG25224@aftab> <m1k4r0c0y7.fsf@fess.ebiederm.org> <20100518222832.GJ22675@basil.fritz.box> <m1wrv0zo9q.fsf@fess.ebiederm.org> <20100519090323.GA18073@basil.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100519090323.GA18073@basil.fritz.box>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 11:03:24AM +0200, Andi Kleen wrote:
> Hi Eric,
> 
> > I'm not ready to believe the average person that is running linux
> > is too stupid to understand the difference between a hardware
> > error and a software error.
> 
> Experience disagrees with you (that is not sure about average,
> but at least there's a significant portion) 
> 
> Also again today there are other reasons for it.

I agree with Andi.  While there are a wire range of users, the
vast majority know little about the hardware they are running
on.  Even in commercial settings, where users/admins are better
educated, there is little time to do detailed error analysis.

The more errors are detected/analyzed/corrected/recovered, the
better it is for everyone.

 
> > > Really to do anything useful with them you need trends
> > > and automatic actions (like predictive page offlining)
> > 
> > Not at all, and I don't have a clue where you start thinking
> > predictive page offlining makes the least bit of sense.  Broken
> > or even weak bits are rarely the common reason for ECC errors.
> 
> There are various studies that disagree with you on that.

Having the infrastructure to automatically off-line pages
is a good thing.  The details of where to set the predictive
threshold likely will be hardware specific (different DIMM
types failing at different rates).  It needs to be adjustable.

> > > A log isn't really a good format for that
> > 
> > A log is a fine format for realizing you have a problem.  A
> 
> A low steady rate of corrected errors on a large system
> is expected.  In fact if you look at the memory error log.
> of a large system (towards TBs) it nearly always has some 
> memory related events.

Yes, there are certainly examples of that.  

> In this case a log is not really useful. What you need
> is useful thresholds and a good summary.

The larger the system the more important a good summary is.

> > - Errors that occur frequently. That is broken hardware of one time or
> >   another.  I want to know about that so I can schedule down time to replace
> >   my memory before I get an uncorrected ECC error.  Errors of this kind
> >   are likely happening frequently enough as to impact performance.
> 
> Same issue here: if something is truly broken it floods
> you with errors.
> 
> First this costs a lot of time to process and it does not 
> actually tell you anything useful because most errors in a flood
> are similar.
> 
> Basically you don't care if you have 100 or 1000 errors, 
> and you definitely don't want all the of the errors filling up
> your disk and using up your CPU.
> 
> Again a threshold with an action is much more useful here.

Yes, good points.

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
