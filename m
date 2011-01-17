Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab1AQRhy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 12:37:54 -0500
Received: from casper.infradead.org ([85.118.1.10]:33511 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418Ab1AQRhx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 12:37:53 -0500
Subject: Re: [PATCH] powerpc: perf: Fix frequency calculation for
 overflowing counters
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Scott Wood <scottwood@freescale.com>
Cc: Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110117113250.48098aaa@udp111988uds.am.freescale.net>
References: <20110117161742.5feb3761@kryten>
	 <20110117113250.48098aaa@udp111988uds.am.freescale.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 17 Jan 2011 18:38:01 +0100
Message-ID: <1295285881.30950.218.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-17 at 11:32 -0600, Scott Wood wrote:
> > diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
> > index 5674807..ab6f6be 100644
> > --- a/arch/powerpc/kernel/perf_event.c
> > +++ b/arch/powerpc/kernel/perf_event.c
> > @@ -1212,6 +1212,7 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
> >                       if (left <= 0)
> >                               left = period;
> >                       record = 1;
> > +                     event->hw.last_period = event->hw.sample_period;
> >               }
> >               if (left < 0x80000000LL)
> >                       val = 0x80000000LL - left;

> Does perf_event_fsl_emb.c need this as well (it has almost the same
> record_and_restart code)? 

I would think so.
