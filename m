Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab1ECOaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 10:30:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:51849 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab1ECOaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 10:30:15 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=cRt4VtBUuUMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=7afOGtRE0KZHYKlb7yQA:9 a=TX9z20eZsevYSsbjCSsA:7 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC patch 29/32] trace event asoc remove semicolons
From: Steven Rostedt <rostedt@goodmis.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <20110503140647.GA29665@Krystal>
References: <20110502211123.163877033@efficios.com>
	 <20110502213216.050459585@efficios.com>
	 <20110503132138.GL1762@opensource.wolfsonmicro.com>
	 <20110503140647.GA29665@Krystal>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 03 May 2011 10:30:12 -0400
Message-ID: <1304433012.25414.2391.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-05-03 at 10:06 -0400, Mathieu Desnoyers wrote:

> This depends on a preliminary ftrace cleanup patch I just forwarded to
> you. LKML has eaten that patch due to too many CC. [ insert favorite
> expression of frustration here ]. But I think the best way to proceed
> would be to get a Acked-by from you and let Steven pull the patch
> through the tracing tree.

Sure, we can do that (for the semi-colon clean up).

> 
> > 
> > > +#ifndef _TRACE_ASOC_DEF_
> > > +#define _TRACE_ASOC_DEF_
> > > +
> > >  struct snd_soc_jack;
> > >  struct snd_soc_codec;
> > >  struct snd_soc_card;
> > >  struct snd_soc_dapm_widget;
> > >  
> > > +#endif /* _TRACE_ASOC_DEF_ */
> > 
> > This is an unrelated change and should be split out.  Frankly I'm not
> > that this is an improvement anyway, the struct declarations aren't going
> > to do any harm...
> 
> Yes, this change is related, because these declarations will cause harm.
> The structure declaration cannot be put within an array declaration,
> because then they won't be simply "ignored": they will try to declare
> structures within an array, which is not valid. This is why I did this
> change in the same patch.

No, Mark is right in this case. This IS a separate change, and deserves
a separate patch. This patch is to remove the semi-colons. This change
should be separated out and stated it is for the array. In fact, you
should probably have two different patch sets. One for the semi-colon
clean up, which I'm fine with. And another set that does more to the
patch, like this change. If I do the array change and find that it
doesn't help much, I wont want this change. But I'm willing to keep the
semi-colon change.

Yes, when I convert ftrace and perf to use arrays, then this will be
needed, but it is not needed for this series. I haven't looked at the
other patches yet (besides the first one), but if you have more of this
in other patches, please remove it. You can make another patch set that
I can use before the ftrace/perf updates.

-- Steve


