Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1HAFcY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 01:32:24 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:52875 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752855Ab1HAFcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 01:32:10 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zz936eK1432N98dKzz1202hzzz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LP8I1C-01-2I6-02
X-M-MSG: 
Date: Mon, 1 Aug 2011 07:32:01 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] perf, x86: Implement IBS interrupt handler
Message-ID: <20110801053201.GY4590@erda.amd.com>
References: <1311860812-28748-1-git-send-email-robert.richter@amd.com>
 <1311860812-28748-5-git-send-email-robert.richter@amd.com>
 <1311958726.5890.411.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1311958726.5890.411.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.07.11 12:58:46, Peter Zijlstra wrote:
> On Thu, 2011-07-28 at 15:46 +0200, Robert Richter wrote:
> > +static int __kprobes
> > +perf_ibs_nmi_handler(struct notifier_block *self,
> > +                    unsigned long cmd, void *__args)
> > +{
> > +       struct die_args *args = __args;
> > +       int handled = 0;
> > +
> > +       switch (cmd) {
> > +       case DIE_NMI:
> > +               break;
> > +       default:
> > +               return NOTIFY_DONE;
> > +       }
> > +
> > +       handled += perf_ibs_handle_irq(&perf_ibs_fetch, args->regs);
> > +       handled += perf_ibs_handle_irq(&perf_ibs_op, args->regs);
> > +
> > +       if (!handled)
> > +               return NOTIFY_DONE;
> > +
> > +       inc_irq_stat(apic_perf_irqs);
> > +
> > +       return NOTIFY_STOP;
> > +} 
> 
> So IBS cannot trigger the whole unknown NMI business? Wouldn't ibs_op
> triggering while ibs_fetch just started latch the NMI line, the
> in-progress NMI would handle both, and we then end up with a spare NMI?

Ok, I will run some excessive testing of this. If this turns out to be
a problem I will change the code. Could this be on top of this patch
set then?

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

