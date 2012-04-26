Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab2DZOpb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 10:45:31 -0400
Received: from db3ehsobe001.messaging.microsoft.com ([213.199.154.139]:52608
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751416Ab2DZOp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 10:45:29 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz936eK1432N98dKzz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M33CZI-01-IYE-02
X-M-MSG: 
Date: Thu, 26 Apr 2012 16:45:14 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, <mingo@elte.hu>,
        David Ahern <dsahern@gmail.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [BUG] perf stat: useless output for raw events with new event
 parser
Message-ID: <20120426144514.GB18810@erda.amd.com>
References: <CABPqkBQJU2vYLbr-=qjkpG=sB8n-8aXJ3QkWcASzy5h4rtFAig@mail.gmail.com>
 <1335178132.28150.117.camel@twins>
 <CABPqkBQ2w3RLRwq3fsaJQ_L=_=H+5kounBeuxUv_fk1ksimTOQ@mail.gmail.com>
 <1335436031.13683.6.camel@twins>
 <20120426131220.GB5046@erda.amd.com>
 <1335450273.13683.76.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1335450273.13683.76.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.04.12 16:24:33, Peter Zijlstra wrote:
> On Thu, 2012-04-26 at 15:12 +0200, Robert Richter wrote:
> > On 26.04.12 12:27:11, Peter Zijlstra wrote:
> > > Furthermore, once we have a common format, we could even ask Intel/AMD
> > > (and other vendors) to provide their data in this format.
> > 
> > I don't think that can be done with a reasonable effort. 
> 
> I'm thinking you mis-understand, all we're talking about is a copy of
> your event list (BKDG Fam 10h Rev 3.48, section 3.14) in a usable
> format.

If it is not more complex than for libpfm4 am fine with it. I was
worried about describing pmu capabilities in sysfs which can better be
done with pmu specific code, once we know on which pmu we run.

> Its an aid to simplify constructing raw events, nothing more.
> 
> When I want to use funny events I'm staring at the Intel-SDM/AMD-BKDG
> anyway and I find writing:
> 
>   cpu/event=0x4e2,umask=0xf8/
> 
> A lot easier than:
> 
>   r40000f8e2

It is totally ok to have parser support for this. I simply do not see
why we need to put the encoding into sysfs. We somehow know on which
hardware we run and the parser should already know how to setup the
syscall. So parsing the above finally ends in calling of something
like:

 setup_event_for_some_pmu(event, 0x4e2, 0xf8);

We don't need any description of bit masks in sysfs for this.

> So I'd be perfectly ok with adding something
> like /sys/bus/events/device/*/name or so.

Yes, something like this could be added to let userland know about the
pmu.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

