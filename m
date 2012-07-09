Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab2GINzH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 09:55:07 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:25625 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753527Ab2GINzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 09:55:05 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: cnix.m8VM1l3TuT7Rf2iHOpmYNbdXJ42dxjfK7Zz0alpgyf
 nrroaAw8zUqhdoNdyl1FtXp2VCzH5DP6EffiWqpgnUdbsDL7J96ppXR0U22g
 jeFR.hdY2FKr7fJ3SYZwzAZdu2oM9YDJ35xtgrRtzm5TcHtlB6oCsfJLOy.q
 CgohU26muPQDSxScDJ1z7cFDTTEcHLv8JmvKwJ1F9RO5x3kyqVr7CJsgncht
 Fvnq0HfSqkkUpS0ynSZIK3vTXbwK4XSz6DWayIa20bbOdDWuw4hvZ3QueiI6
 nnWdwnkjkbLSw0d91oIQ0fyEsIUj.lHp2KmgI6i6KTViazcLX4Ly7u730l8E
 qiOplDPvaA8LFZw1JITI_17vQ5LEs1tmaDdzf8auSIy3iADV8tQjoLnrRf29
 Y
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 9 Jul 2012 08:55:02 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: JoonSoo Kim <js1304@gmail.com>
cc: Fengguang Wu <fengguang.wu@intel.com>,
        Vegard Nossum <vegard.nossum@gmail.com>,
        Pekka Enberg <penberg@kernel.org>,
        Linux Memory Management List <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: __GFP_FS allocations with IRQs disabled
 (kmemcheck_alloc_shadow)
In-Reply-To: <CAAmzW4OD2_ODyeY7c1VMPajwzovOms5M8Vnw=XP=uGUyPogiJQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1207090853450.27519@router.home>
References: <20120708040009.GA8363@localhost> <CAAmzW4OD2_ODyeY7c1VMPajwzovOms5M8Vnw=XP=uGUyPogiJQ@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jul 2012, JoonSoo Kim wrote:

> 2012/7/8 Fengguang Wu <fengguang.wu@intel.com>:
> > Hi Vegard,
> >
> > This warning code is triggered for the attached config:
> >
> > __lockdep_trace_alloc():
> >         /*
> >          * Oi! Can't be having __GFP_FS allocations with IRQs disabled.
> >          */
> >         if (DEBUG_LOCKS_WARN_ON(irqs_disabled_flags(flags)))
> >                 return;
> >
> > Where the irq is possibly disabled at the beginning of __slab_alloc():
> >
> >         local_irq_save(flags);
>
> Currently, in slub code, kmemcheck_alloc_shadow is always invoked with
> irq_disabled.
> I think that something like below is needed.

Or you could move the kmem_check_enabled section to occur before the irq
is disabled.
