Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752730Ab2CHHfN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 02:35:13 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59618 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487Ab2CHHfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 02:35:07 -0500
Date: Thu, 8 Mar 2012 08:34:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Peter Seebach <peter.seebach@windriver.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Anton Blanchard <anton@samba.org>, paulus@samba.org, dsahern@gmail.com,
        fweisbec@gmail.com, yanmin_zhang@linux.intel.com, emunson@mgebm.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf: Incorrect use of snprintf results in SEGV
Message-ID: <20120308073454.GD20784@elte.hu>
References: <20120307114249.44275ca3@kryten>
 <20120307010904.GE5656@infradead.org>
 <20120306192912.59811e3e@wrlaptop>
 <20120307203725.GA4333@elte.hu>
 <1331153964.11248.362.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331153964.11248.362.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2012-03-07 at 21:37 +0100, Ingo Molnar wrote:
> >         size_needed = snprintf_size(...);
> 
> This would require 3 passes over the fmt+args, first to find 
> the allocated size is insufficient, 2nd to compute the size, 
> 3rd to fill buffer.

No. The 1% case would use this separate API with its quirky 
return value. snprintf_size() works like today's snprintf, it's 
just *named* clearly to signal that it returns something not 
quite intuitive and results in bugs even in code that *tries* to 
be aware of the corner cases.

> Whereas with the current "creative" API only 2 passes are 
> needed.
> 
> I can imagine that back in the day of small memory and small 
> CPU this was deemed important enough.
> 
> Anyway, its all moot, this API exists and has been out in the 
> wild for several decades now, its not like we can actually 
> change it :-)

Of course it is moot - I am not arguing for a change in the API.

But the self-justification, as outlined in the mail I replied 
to, is brutally wrong, and nowhere in this discussion did I see 
the important notion mentioned that the *common case matters* - 
so maybe reading this will keep others from committing the same 
mistake, with newly introduced APIs.

Thanks,

	Ingo
