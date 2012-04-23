Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab2DWK4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:56:44 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:49183
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754585Ab2DWK4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:56:42 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zz936eK1432N98dKzz1202hzzz2dh668h839h944hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2XIED-01-ARK-02
X-M-MSG: 
Date: Mon, 23 Apr 2012 12:56:34 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, <mingo@elte.hu>,
        David Ahern <dsahern@gmail.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Subject: Re: [BUG] perf stat: useless output for raw events with new event
 parser
Message-ID: <20120423105634.GV9747@erda.amd.com>
References: <CABPqkBQJU2vYLbr-=qjkpG=sB8n-8aXJ3QkWcASzy5h4rtFAig@mail.gmail.com>
 <1335178132.28150.117.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1335178132.28150.117.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.04.12 12:48:52, Peter Zijlstra wrote:
> On Mon, 2012-04-23 at 12:45 +0200, Stephane Eranian wrote:
> > Hi,
> > 
> > With the new event parser, one can express raw events field by field:
> > 
> > $ perf stat -e cpu/event=0x3c,umask=0x0/,cpu/event=0xc5,umask=0x0/ noploop 1
> > 
> > The problem with this is that the output of perf stat becomes useless:
> > 
> > $ perf stat -e cpu/event=0x3c,umask=0x0/,cpu/event=0xc5,umask=0x0/ noploop 1
> > noploop for 1 seconds
> > 
> >  Performance counter stats for 'noploop 1':
> > 
> >         2395038678 pmu
> >             10787 pmu
> >                        ^^^^^^
> >        1.000802603 seconds time elapsed
> 
> Yeah, I already complained about that.. Jolsa proposed adding a name=
> parameter so you could explicitly name your events. I think I've seen a
> patch adding that, but can't atm seem to locate it.

"pmu" is always useless, because we have multiple pmus in one system
and don't know which pmu is meant. So the events name should be close
(maybe exactly) to what the -e option says instead of "pmu".

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

