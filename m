Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab0I3Mdy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 08:33:54 -0400
Received: from casper.infradead.org ([85.118.1.10]:37696 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab0I3Mdx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 08:33:53 -0400
Subject: Re: [PATCH] perf, x86: catch spurious interrupts after disabling
 counters
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>, Don Zickus <dzickus@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, "gorcunov@gmail.com" <gorcunov@gmail.com>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "andi@firstfloor.org" <andi@firstfloor.org>
In-Reply-To: <AANLkTimeAbm6eHsf++-5OO6ba9zDYehw=W_zfbi+2Z=g@mail.gmail.com>
References: <20100910155659.GD13563@erda.amd.com>
	 <20100911094157.GA11521@elte.hu> <20100911114404.GE13563@erda.amd.com>
	 <20100911124537.GA22850@elte.hu> <20100912095202.GF13563@erda.amd.com>
	 <20100913143713.GK13563@erda.amd.com> <20100914174132.GN13563@erda.amd.com>
	 <20100915162034.GO13563@erda.amd.com> <20100924000234.GO26290@redhat.com>
	 <20100924031834.GP26290@redhat.com> <20100924100345.GE13563@erda.amd.com>
	 <AANLkTimeAbm6eHsf++-5OO6ba9zDYehw=W_zfbi+2Z=g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 30 Sep 2010 14:33:38 +0200
Message-ID: <1285850018.2144.48.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-09-24 at 15:38 +0200, Stephane Eranian wrote:
> > I don't like the approach of disabling all counters in the nmi
> > handler. First, it stops counting and thus may falsify
> > measurement. Second, it introduces much overhead doing a rd-/wrmsrl()
> > for each counter.
> >
> But that's exactly what is going on the Intel side. PMU is stopped on interrupt.
> An argument for this is that you don't necessarily want to monitor across
> the PMU handler, i.e., the overhead you introduce.

Right, its really a question of what you want to measure. I prefer not
to measure the measuring itself, things are hard enough to interpret
already.

Then again, the Intel stuff has a real handy way to disable the whole
PMU, unlike the AMD bits where you need to iterate each counter
individually.
