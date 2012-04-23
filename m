Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab2DWKzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 06:55:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241Ab2DWKzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 06:55:46 -0400
Date: Mon, 23 Apr 2012 12:55:25 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, mingo@elte.hu,
        David Ahern <dsahern@gmail.com>,
        Robert Richter <robert.richter@amd.com>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>
Subject: Re: [BUG] perf stat: useless output for raw events with new event
 parser
Message-ID: <20120423105525.GC1720@m.brq.redhat.com>
References: <CABPqkBQJU2vYLbr-=qjkpG=sB8n-8aXJ3QkWcASzy5h4rtFAig@mail.gmail.com>
 <1335178132.28150.117.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335178132.28150.117.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 12:48:52PM +0200, Peter Zijlstra wrote:
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

it's waiting in here:
https://lkml.org/lkml/2012/4/15/74

I already talked to Arnaldo and I need to resend this serie,
due to another changes that are yet about to get into tip tree..
Once it's in, I'll resend ;)

jirka
> 
> Jiri?
