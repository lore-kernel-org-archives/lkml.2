Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754859Ab0H3Mob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:44:31 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:53522 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754612Ab0H3Mo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:44:28 -0400
X-SpamScore: -2
X-BigFish: VPS-2(ze80izbb2cK1432N98dNzz1202hzzz32i2a8h5bem5bfn61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L7YTXX-01-F8S-02
X-M-MSG: 
Date: Mon, 30 Aug 2010 14:41:58 +0200
From: Robert Richter <robert.richter@amd.com>
To: Matt Fleming <matt@console-pimps.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 2/4] sh: Accessor functions for the sh_pmu state
Message-ID: <20100830124158.GY22783@erda.amd.com>
References: <cover.1282848651.git.matt@console-pimps.org>
 <f259830dbccb084d27d127676b979d9cb502e36f.1282848651.git.matt@console-pimps.org>
 <20100827134301.GL22783@erda.amd.com>
 <20100827191745.GA7258@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100827191745.GA7258@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: ausb3extmailp02.amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.08.10 15:17:45, Matt Fleming wrote:

> > > --- a/arch/sh/kernel/perf_event.c
> > > +++ b/arch/sh/kernel/perf_event.c
> > > @@ -60,6 +60,19 @@ static inline int sh_pmu_initialized(void)
> > >  }
> > >  
> > >  /*
> > > + * Return the number of events for the current sh_pmu.
> > > + */
> > > +int sh_pmu_num_events(void)
> > > +{
> > > +	return sh_pmu->num_events;
> > > +}
> > > +
> > > +const char *sh_pmu_name(void)
> > > +{
> > > +	return sh_pmu->name;
> > > +}

> > This accessor functions should be generic for all architectures.
> 
> This isn't going to work. ARM uses an integer ID whereas SH uses a
> string name. This is specific to an architecture and making it generic
> would probably involve some abstraction layer.

Perf should provide the interface to detect the number of counters
(btw. *num_events is wrong) and the name of the pmu. The information
is part of perf and thus the functions accessing it should be part of
perf too, not oprofile.

We also need generic functions, because we want to have a generic
oprofile-perf driver.

I don't see that this is hard to implement. We could add function
stubs returning an error or invalid value using the __weak attribute
and implement it for those architectures where we need it.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

