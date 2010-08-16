Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab0HPPoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 11:44:17 -0400
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:4862 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754233Ab0HPPoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 11:44:16 -0400
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host o7GFhm6w016524
Subject: Re: [PATCH] perf tools: Don't use brace expansion.
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Kusanagi Kouichi <slash@ac.auone-net.jp>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20100816152914.GC13095@ghostprotocols.net>
References: <20100816124101.1829415C039@msa104.auone-net.jp>
	 <1281967761.17267.6.camel@thorin> <1281969043.1926.1469.camel@laptop>
	 <1281970478.17267.12.camel@thorin>
	 <20100816152914.GC13095@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 17:43:47 +0200
Message-ID: <1281973427.17267.16.camel@thorin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-DCC-dcc1-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 12:29 -0300, Arnaldo Carvalho de Melo wrote:
> Em Mon, Aug 16, 2010 at 04:54:38PM +0200, Bernd Petrovitsch escreveu:
> > On Mon, 2010-08-16 at 16:30 +0200, Peter Zijlstra wrote:
> > > On Mon, 2010-08-16 at 16:09 +0200, Bernd Petrovitsch wrote:
> > > > > -$(shell sh -c 'mkdir -p $(OUTPUT)scripts/{perl,python}/Perf-Trace-Util/' 2> /dev/null)
> > > > > -$(shell sh -c 'mkdir -p $(OUTPUT)util/{ui/browsers,scripting-engines}/' 2> /dev/null)
> 
> > > > The other solution is to use standard-make features like in
> > > > mkdir -p $(foreach d,ui/browsers scripting-engines,$(OUTPUT)util/$(d)/) 2> /dev/null
> 
> > > > Is there actually a specific reason for the 
> > > > $(shell sh -c '...')
> > > > around?
> > > > It looks superflous.
> 
> > > I think the reason is is that nobody who touched that file really knew
> > > make all that well. Your version looks fine to me.
> 
> > Ah, the reason is that they are not part of a rule but on the top-level
> > (and thus always executed).
> 
> So it worked by luck! /me runs :-P

IMHO it's not really luck with GNU-make.

> More seriously, so there is a reason for that to be like that and you're
> not aware of any other shorter or more convenient way of achieving that

One (obvious) alternative is to have rules triggering on the
non-existence of these directories.

> goal, right?

Hmm, I'm not a "perf person". Which are the sufficient use-cases/tests
that one can do to play around with the Makefile?

`make -C tools/perf` is probably not enough.

Any hints anyone?

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

