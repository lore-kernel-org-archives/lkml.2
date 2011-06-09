Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab1FIMJr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 08:09:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359Ab1FIMJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 08:09:45 -0400
Date: Thu, 9 Jun 2011 08:09:28 -0400
From: Don Zickus <dzickus@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        huang ying <huang.ying.caritas@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
Message-ID: <20110609120928.GR8162@redhat.com>
References: <4DCF7413.4070704@gmail.com>
 <4DD07959.4030608@intel.com>
 <20110516190310.GH31888@redhat.com>
 <4DD20A2F.604@intel.com>
 <20110517142427.GL31888@redhat.com>
 <20110517163847.GF24805@tassilo.jf.intel.com>
 <20110517175707.GP31888@redhat.com>
 <20110517181859.GA25937@tassilo.jf.intel.com>
 <20110517190738.GH29881@redhat.com>
 <4DD622A5.9030902@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD622A5.9030902@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 04:13:25PM +0800, Huang Ying wrote:
> Hi, Don,
> 
> On 05/18/2011 03:07 AM, Don Zickus wrote:
> > On Tue, May 17, 2011 at 11:18:59AM -0700, Andi Kleen wrote:
> >>> Random thought, in the Firmware first mode of HEST (which is the only way
> >>> GHES records get produced??), does an SCI happen first to jump into the
> >>> firmware for processing, then an NMI?
> >>
> >> Either that or there is a separate service processor which handles it.
> >> Presumably it depends a lot on the particular system.
> > 
> > Ah interesting.  I was going to suggest somehow setting a bit when an SCI
> > comes in and check that bit in the unknown NMI path as a possible hint
> > that the NMI might be related to HEST (sorta how we flag unknown NMIs in
> > the perf code).
> > 
> > It was just an idea.  Obviously a service processor will make that more
> > difficult. :-)
> 
> Hmm, what's the conclusion?  Do you think unknown NMI should be seen as
> hardware error?  At least on some white listed machines?

I still sorta have the opinion that a hardware error should be able be
recognizable either through a GHES record or a bit in the southbridge.
Whereas an unknown NMI is something lost and has no owner as the result of
either a buggy NMI handler or an unimplemented NMI handler.

Yeah, I can see hardware errors coming in through an unknown NMI but to me
(from what I am reading about with APEI/GHES) is those should be trapped
by the firmware and if they aren't then the firmware is broken.  In those
cases it should be up to the OEM to provide proper firmware (even certify
them) to allow the proper experience, which includes being properly
trapped by an NMI handler.

Perhaps I am a bit naive in my belief but I am a little nervous panicing
all the time on unknown NMIs when we are still chasing missed perf NMIs on
a loaded box.

Cheers,
Don

