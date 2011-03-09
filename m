Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab1CIRMf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 12:12:35 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58126 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060Ab1CIRMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 12:12:34 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=29Q6NhLeR-UA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=m0bHr2FCAAAA:8 a=meVymXHHAAAA:8 a=6oPwBEXRCwoeqw0caCUA:9 a=CYJX26LP3rmwg_Dh3T4A:7 a=7RvehDSMBE_RWTT0-lpUv1MhAPEA:4 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Revert "irq: Add tracepoint to softirq_raise" - microblaze
 build
From: Steven Rostedt <rostedt@goodmis.org>
To: monstr@monstr.eu
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4D77B267.3020307@monstr.eu>
References: <4D77708F.1000800@monstr.eu>
	 <1299689179.15854.255.camel@gandalf.stny.rr.com>
	 <4D77B267.3020307@monstr.eu>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 09 Mar 2011 12:12:28 -0500
Message-ID: <1299690748.15854.264.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-09 at 18:01 +0100, Michal Simek wrote:
> Steven Rostedt wrote:
> > On Wed, 2011-03-09 at 13:20 +0100, Michal Simek wrote:
> >> Hi Frederic,
> >>
> >> I have compiled ftrace support for Microblaze and I have reached a compilation failure.
> >>
> >> I bisected it and I found that
> >> "irq: Add tracepoint to softirq_raise"
> >> (sha1:2bf2160d8805de64308e2e7c3cd97813cb58ed2f)
> >> caused it.
> >>
> >> I also found one thread which could be related.
> >> http://kerneltrap.org/mailarchive/linux-kernel/2010/9/8/4616941
> >>
> >> It is likely any missing header or so.
> >>
> >> Do you know what can be wrong?
> >>
> >> Thanks,
> >> Michal
> >>
> >>
> >> [ALL  ]   CC      kernel/trace/power-traces.o
> >> [ALL  ] In file included from 
> >> /mnt/projects/petalinux-v1.00-devel/software/linux-2.6.x/arch/microblaze/include/asm/irq.h:15,
> > 
> > Is there a reason that arch/microblaze/include/asm/irq.h includes
> > "linux/interrupt.h"?
> 
> Yep, it is. I tried to add some headers not remove them.


Do you mean it is not needed? And removing it fixes the problem?

> 
> Thanks,
> Michal
> 
> P.S.: Do you want to create proper patch? If not, I will do it.

I rather not add patches to systems that I can't build, boot and test.

If removing the header works, just add a:

Suggested-by: Steven Rostedt <rostedt@goodmis.org>

Thanks,

-- Steve



