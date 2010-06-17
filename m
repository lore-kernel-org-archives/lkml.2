Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933055Ab0FQQUE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 12:20:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:51451 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932996Ab0FQQUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 12:20:00 -0400
X-Authority-Analysis: v=1.1 cv=zLGBfXKW/yOQN1c4qTdQUWouaSiWOaUUjRgOJi1LSJI= c=1 sm=0 a=PrpqVr8aNvUA:10 a=ood2b7iyd8MA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=AtQ9L6JIVOK_BfpNVJ0A:9 a=xNj9nlK_Z7vfbqB0lsUA:7 a=QPC8KTwRNsl5omXUIhMC5lR4BQoA:4 a=PUjeQqilurYA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 1/2] perf: Add persistent events
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Borislav Petkov <bp@amd64.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
       Borislav Petkov <bp@alien8.de>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100617134357.GA6115@kryptos.osrc.amd.com>
References: <20100528143311.GB9710@elte.hu>
	 <1275059860.27810.9635.camel@twins>
	 <20100528155719.GA10141@kryptos.osrc.amd.com>
	 <1275070030.1645.362.camel@laptop>
	 <20100603134301.GA30880@kryptos.osrc.amd.com>
	 <20100603173242.GD29202@ghostprotocols.net>
	 <20100614192514.GA7803@kryptos.osrc.amd.com>
	 <20100614210116.GA26716@ghostprotocols.net>
	 <20100614212426.GA19915@liondog.tnic>
	 <20100615010201.GA27077@ghostprotocols.net>
	 <20100617134357.GA6115@kryptos.osrc.amd.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 17 Jun 2010 12:19:57 -0400
Message-ID: <1276791597.3556.118.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-17 at 15:43 +0200, Borislav Petkov wrote:

> > One of the goals at least I have with pursuing this path is to separate
> > out everything that is not strictly 'perf' into things that can be reused
> > by other tools, like yours.
> 
> I'm still splitting perf/util into a more or less generic lib.
> Now, I want to reuse as much code as possible and am parsing
> the "mce:mce_record" tracepoint using parse_events(). However,
> this means that I have to push the not-so-generic perf bits
> like util/parse-events.c into the lib. Which, in turn, pulls in
> util/trace-event* etc.

Note, I have a separate generic library in trace-cmd that has the
parsing of trace events as its own library now.

This is the code that started trace-event-parse.c.

It has evolved quite a bit since then. You can get the code from:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git

The files are parse-events.c and parse-events.h. As well as some
filtering code: parse-filter.c.

It creates a libparsevent library.

I've been meaning to update the perf stuff with it, but just have not
had the time. Seems that what you are doing might be a good fit for it.

-- Steve


