Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab2FEQFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 12:05:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:48619 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab2FEQFT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 12:05:19 -0400
Message-ID: <1338912312.2749.6.camel@twins>
Subject: Re: git bisect and perf
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Stephane Eranian <eranian@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Tue, 05 Jun 2012 18:05:12 +0200
In-Reply-To: <1338912052.2749.2.camel@twins>
References: <4FCE25C6.2080601@gmail.com> <1338912052.2749.2.camel@twins>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 18:00 +0200, Peter Zijlstra wrote:
> On Tue, 2012-06-05 at 09:29 -0600, David Ahern wrote:
> > I am trying find out when (ie. which commit) the pebs feature
> > actually 
> > started working on a westmere system
> 
> What do you mean with working? The whole cycles:pp thing is magic and
> unrelated to 'regular' PEBS stuff. .35 would indeed be the version we
> introduced PEBS support and it should actually work.
> 
> But if you're looking for the cycles:pp stuff (commit 7639dae0ca1)
> that's .38-rc1-ish.

So on kernels pre that commit you could still do: 

  perf record -e r108000c0:pp

and get the same effect. Its just that after that commit r3c:pp will be
magically translated to the above.

And just to be complete (as Stephane always needs to point out) event 3c
and 108000c0 aren't fully identical, they differ in that one counts
while idle and the other doesn't (but I forgot which way around).

Luckily not a lot of people care about profiling idle time.
