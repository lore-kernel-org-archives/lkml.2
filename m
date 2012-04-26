Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736Ab2DZPjw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:39:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:54318 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757569Ab2DZPjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:39:45 -0400
Message-ID: <1335454772.13683.101.camel@twins>
Subject: Re: [BUG] perf stat: useless output for raw events with new event
 parser
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, mingo@elte.hu,
        David Ahern <dsahern@gmail.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>
Date: Thu, 26 Apr 2012 17:39:32 +0200
In-Reply-To: <20120426144514.GB18810@erda.amd.com>
References: <CABPqkBQJU2vYLbr-=qjkpG=sB8n-8aXJ3QkWcASzy5h4rtFAig@mail.gmail.com>
	 <1335178132.28150.117.camel@twins>
	 <CABPqkBQ2w3RLRwq3fsaJQ_L=_=H+5kounBeuxUv_fk1ksimTOQ@mail.gmail.com>
	 <1335436031.13683.6.camel@twins> <20120426131220.GB5046@erda.amd.com>
	 <1335450273.13683.76.camel@twins> <20120426144514.GB18810@erda.amd.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-04-26 at 16:45 +0200, Robert Richter wrote:
> It is totally ok to have parser support for this. I simply do not see
> why we need to put the encoding into sysfs. We somehow know on which
> hardware we run and the parser should already know how to setup the
> syscall. So parsing the above finally ends in calling of something
> like:
> 
>  setup_event_for_some_pmu(event, 0x4e2, 0xf8);
> 
> We don't need any description of bit masks in sysfs for this. 

Its the kernel side decoding perf_event_attr, so it seems sensible to
also describe this encoding from the kernel.

Currently we mostly match the hardware encoding, but there's no strict
requirement to do so, we can already see some of that with the extra_reg
stuff, perf_event_attr::config1 can mean different things depending on
the event.

Keeping all this information in two places just seems like asking for it
to get out of sync.

