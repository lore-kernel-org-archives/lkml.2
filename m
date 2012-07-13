Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030579Ab2GMQcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 12:32:55 -0400
Received: from usindpps06.hds.com ([207.126.252.19]:58187 "EHLO
	usindpps06.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030551Ab2GMQcw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 12:32:52 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "'mingo@elte.hu' (mingo@elte.hu)" <mingo@elte.hu>,
        "vnagarnaik@google.com" <vnagarnaik@google.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: RE: [PATCH]trace,x86: add x86 irq vector tracepoints
Thread-Topic: [PATCH]trace,x86: add x86 irq vector tracepoints
Thread-Index: Ac1ZaobLbFE8rfeBT8yS2HRcq0u5JgBpe++AAX2QufAACnE8gAAHGorg
Date: Fri, 13 Jul 2012 16:32:04 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D40F08E421@USINDEM101.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D401AA07@USINDEM103.corp.hds.com>
 <1341521053.21574.22.camel@gandalf.stny.rr.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D40F08E359@USINDEM101.corp.hds.com>
 <alpine.LFD.2.02.1207131727430.32033@ionos>
In-Reply-To: <alpine.LFD.2.02.1207131727430.32033@ionos>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.43.113]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.260,0.0.0000
 definitions=2012-07-13_05:2012-07-13,2012-07-13,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0 spamscore=0
 ipscore=0 suspectscore=1 phishscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=6.0.2-1203120001
 definitions=main-1207130152
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> > > > +DECLARE_EVENT_CLASS(irq_vector,
> > > > +
> > > > +	TP_PROTO(int irq),
> > > > +
> > > > +	TP_ARGS(irq),
> > > > +
> > > > +	TP_STRUCT__entry(
> > > > +		__field(	int,	irq	)
> 
> Shouldn't this be vector?
> 

Ok. I will change it to vector.

> > > > +DEFINE_EVENT(irq_vector, nmi_entry, DEFINE_EVENT(irq_vector,
> > > > +nmi_exit, DEFINE_EVENT(irq_vector, local_timer_entry,
> > > > +DEFINE_EVENT(irq_vector, local_timer_exit,
> > > > +DEFINE_EVENT(irq_vector, reschedule_entry,
> > > > +DEFINE_EVENT(irq_vector, reschedule_exit,
> > > > +DEFINE_EVENT(irq_vector, call_function_entry,
> > > > +DEFINE_EVENT(irq_vector, call_function_exit,
> > > > +DEFINE_EVENT(irq_vector, call_function_single_entry,
> > > > +DEFINE_EVENT(irq_vector, call_function_single_exit,
> > > > +DEFINE_EVENT(irq_vector, irq_work_entry, DEFINE_EVENT(irq_vector,
> > > > +irq_work_exit, DEFINE_EVENT(irq_vector, invalidate_tlb_entry,
> > > > +DEFINE_EVENT(irq_vector, invalidate_tlb_exit,
> 
> So this set is pretty generic and applicable across architectures. Good.
>

Thanks.
 
> > > > +DEFINE_EVENT(irq_vector, error_apic_entry,
> > > > +DEFINE_EVENT(irq_vector, error_apic_exit,
> > > > +DEFINE_EVENT(irq_vector, thermal_apic_entry,
> > > > +DEFINE_EVENT(irq_vector, thermal_apic_exit,
> > > > +DEFINE_EVENT(irq_vector, threshold_apic_entry,
> > > > +DEFINE_EVENT(irq_vector, threshold_apic_exit,
> > > > +DEFINE_EVENT(irq_vector, spurious_apic_entry,
> > > > +DEFINE_EVENT(irq_vector, spurious_apic_exit,
> > > > +DEFINE_EVENT(irq_vector, x86_platform_ipi_entry,
> > > > +DEFINE_EVENT(irq_vector, x86_platform_ipi_exit,
> 
> That part is x86 specific. If we go that route, we'll end up with gazillions of arch specific vectors sooner than later.
> 
> Either we find better and more widely applicable names for them, if there are similar functionalities on other architectures available,
> or 

I'm not familiar with other architectures...

>we should have a single generic tracepoint for those which cannot be be mapped to anything useful shared across architectures.
> 
> Those x86 specific ones are not really frequently raised vectors, so enabling them all won't affect performance and readability of the
> traces too much.

OK. I will unify these to a single tracepoint.
"x86_irq_vector" or so?

Seiji
