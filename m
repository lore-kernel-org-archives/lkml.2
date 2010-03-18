Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714Ab0CRWEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 18:04:36 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:58821 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab0CRWEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 18:04:34 -0400
X-Greylist: delayed 1474 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Mar 2010 18:04:33 EDT
Date: Fri, 19 Mar 2010 00:40:30 +0300
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: john stultz <johnstul@us.ibm.com>
Cc: Richard Henderson <rth@twiddle.net>, lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Matt Turner <mattst88@gmail.com>
Subject: Re: [RFC][PATCH] Convert alpha to use clocksource
Message-ID: <20100318214030.GA8934@jurassic.park.msu.ru>
References: <1268877702-2236-1-git-send-email-johnstul@us.ibm.com> <4BA23974.5030503@twiddle.net> <1268934923.1855.8.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268934923.1855.8.camel@work-vm>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 10:55:23AM -0700, john stultz wrote:
> On Thu, 2010-03-18 at 07:32 -0700, Richard Henderson wrote:
> > On 03/17/2010 07:01 PM, John Stultz wrote:
> > > Alpha has a tsc like rpcc counter that it uses to manage time.
> > > This can be converted to an actual clocksource instead of utilizing
> > > the arch_gettimeoffset method that is really only there for legacy
> > > systems with no continuous counter.
> > 
> > With 8 seconds or less between roll-overs, do you actually consider
> > this a continuous counter?  I don't.  I suggest this be left alone.
> 
> The timekeeping code handles this (although the shift value I picked may
> need some adjustment - what is the expected counter freq range on
> alpha?). The ACPI PM counter which is very common on x86 is only 24 bits
> and rolls over in ~5 seconds. It works fine.

Yeah, that looks cool. I'm typing this on the 800MHz UP1500 running
2.6.34-rc1 plus your patch, and the timekeeping works fine so far.

Though, even after a glance over the clocksource code, I've not
gotten yet to how one could estimate the "shift" value...
Any hints?

And if I recall correctly, production alphas have been clocked
in the range of 60-1250 MHz.

Ivan.
