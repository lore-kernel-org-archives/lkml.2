Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab0I2UDv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 16:03:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32847 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755136Ab0I2UDu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 16:03:50 -0400
Date: Wed, 29 Sep 2010 16:03:23 -0400
From: Don Zickus <dzickus@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [tip:perf/urgent] perf, x86: Catch spurious interrupts after
 disabling counters
Message-ID: <20100929200323.GC26290@redhat.com>
References: <AANLkTi=WYU2=4Hu7tb+TSrhJw9K9du19_KjMcG3ij=qn@mail.gmail.com>
 <20100929150140.GK13563@erda.amd.com>
 <20100929151253.GL13563@erda.amd.com>
 <20100929152745.GC9440@lenovo>
 <AANLkTikvYreYiyCbGeG02j+r4dWVLRH7BqeeG9O=VTNN@mail.gmail.com>
 <20100929154528.GD9440@lenovo>
 <AANLkTinkqTXXD5fMUYTT4zrRD6YoTi_G+uOA5CsOgxtT@mail.gmail.com>
 <20100929170924.GR13563@erda.amd.com>
 <20100929181207.GW26290@redhat.com>
 <AANLkTimp=+1GzBOYaUZWtDF6teGt6FZe+RTpb9fAyOyd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimp=+1GzBOYaUZWtDF6teGt6FZe+RTpb9fAyOyd@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 09:42:26PM +0200, Stephane Eranian wrote:
> On Wed, Sep 29, 2010 at 8:12 PM, Don Zickus <dzickus@redhat.com> wrote:
> > Robert,
> >
> > I think you missed Stephane's point.  Say for example, kgdb is being used
> > while we are doing stuff with the perf counter (and say kgdb's handler is
> > a lower priority than perf; which isn't true I know, but let's say):
> >
> Yes, exactly my point. The reality is you cannot afford to have false positive
> because you may starve another subsystem from an important notification.
> 
> I think it boils down to whether or not we need an error message (Dazed) in
> case no subsystem claimed the NMI. If you were to just silently consume the
> NMI when no subsystem claims it, then you would not have these issues.
> 
> What Don has done is use a heuristic which gets activated when a PMU
> interrupt handler signals that more than one counter have overflowed. His
> claim is that this situation is likely to trigger back-to-back.

Actually its Robert's heuristic. :-)

> 
> The reason this heuristic works is because it waits until ALL the subsystems
> have seen the notification before it declares that the NMI was PMU spurious.
> To do that is uses the DIE_NMI_UNKNOWN callchain. Handler on this chain
> get call last, after all subsystems have seen the notification once. I believe
> that is the only way to safely "consume" a "spurious" NMI and avoid
> the 'Dazed' message. Anything else runs the risks of starving the other
> subsystems.

I agree.

Cheers,
Don
