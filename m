Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab0IPOvo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 10:51:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54150 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab0IPOvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 10:51:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lyJICblBC6ZiNcMERt9hVe3fKW1n3Ftz4F/CTk7PaGFEcqqv3nCVlCrvKWiyqQJojm
         Ptvip4JQr+V/FmuhR3CwsOFC5JQkYu5qJwTtqNYroGoK9yKPqG9G3/9hLFhv7RqWEgFv
         aTXu1CS57H8E02rcyeYsfnfXhSPsm2wdZlkl0=
Date: Thu, 16 Sep 2010 16:51:36 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, Don Zickus <dzickus@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>
Subject: Re: [PATCH] perf, x86: catch spurious interrupts after disabling
	counters
Message-ID: <20100916145132.GB5352@nowhere>
References: <20100912095202.GF13563@erda.amd.com> <20100913143713.GK13563@erda.amd.com> <20100914174132.GN13563@erda.amd.com> <20100915162034.GO13563@erda.amd.com> <AANLkTimWoE5XiYSr8jx=RFS5Nb9d4_wWe=c-W3oMj8dH@mail.gmail.com> <20100915203948.GB28455@lenovo> <20100915222712.GU13563@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100915222712.GU13563@erda.amd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 12:27:12AM +0200, Robert Richter wrote:
> > On Wed, Sep 15, 2010 at 10:21:10PM +0200, Stephane Eranian wrote:
> > > When you do perf record foo, it's equivalent to
> > > perf record -e cycles:uk -F 1000 foo
> 
> Yes, thanks.
> 
> I am asking because I have observed up to 4 back-to-back nmis from the
> same counter when enabling an event. The period is not yet adjusted.
> We should avoid those short sampling periods in the beginning and
> better start with too long periods. Didn't look at the implementation
> so far. I know this is not easy to handle because this very much
> depends on the event we measure.
> 
> Maybe we start the counter with a delay and then calculate period =
> duration - delay, later decreasing the delay until the frequency is
> adjusted but keeping the total sampling rate more or less constant.


Yep, IIRC, the first arming is set with a 1 sample period. So that a first
calculation can be made on top of the first triggering event time to get
a better sample period. That avoids the need to start with frequency
nature assumptions for each event.

I doubt that can be worked around easily.

