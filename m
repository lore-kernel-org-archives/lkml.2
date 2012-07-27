Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999Ab2G0Nm0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 09:42:26 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:32273 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab2G0NmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 09:42:25 -0400
X-IronPort-AV: E=Sophos;i="4.77,667,1336348800"; 
   d="scan'208";a="13735886"
Date: Fri, 27 Jul 2012 14:41:31 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH 02/24] xen/arm: hypercalls
In-Reply-To: <1343395134.6812.162.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1207271431320.26163@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>  <1343316846-25860-2-git-send-email-stefano.stabellini@eu.citrix.com>  <20120726163352.GC9222@phenom.dumpdata.com>  <1343380659.6812.106.camel@zakaz.uk.xensource.com> 
 <alpine.DEB.2.02.1207271350370.26163@kaball.uk.xensource.com> <1343395134.6812.162.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Jul 2012, Ian Campbell wrote:
> > > > Should this comment be by 'privcmd_call'?
> > > 
> > > When we add a 5 argument hypercall I suppose we'll see the required
> > > push/pop of r4 added to this macro too.
> > 
> > For performance and simplicity I would add a second macro that push/pop
> > r4, only required for hypercalls with more than 4 arguments.
> 
> For clarity / documentation purposes it might actually be worthwhile to
> define all of HYPERCALL{0,1,2,3,4} even if the {0,1,2,3} cases are all
> just:
>         #define HYPERCALL0(x) HYPERCALL_SIMPLE(x)

I agree

> > > > > +#define HYPERCALL(hypercall)			\
> > > > > +ENTRY(HYPERVISOR_##hypercall)			\
> > > > > +	mov r12, #__HYPERVISOR_##hypercall;	\
> > > > > +	xen_hvc;							\
> > > > > +	mov pc, lr;							\
> > > > > +ENDPROC(HYPERVISOR_##hypercall)
> > > > > +
> > > > > +                .text
> > > > > +
> > > > > +HYPERCALL(xen_version);
> > > > > +HYPERCALL(console_io);
> > > > > +HYPERCALL(grant_table_op);
> > > > > +HYPERCALL(sched_op);
> > > > > +HYPERCALL(event_channel_op);
> > > > > +HYPERCALL(hvm_op);
> > > > > +HYPERCALL(memory_op);
> > > > > +HYPERCALL(physdev_op);
> > > > > +
> > > > > +ENTRY(privcmd_call)
> > > > > +	stmdb	sp!, {r4}
> > > > > +	mov r12, r0
> > > > > +	mov r0, r1
> > > > > +	mov r1, r2
> > > > > +	mov r2, r3
> > > > > +	ldr r3, [sp, #8]
> > > > > +	ldr r4, [sp, #4]
> > > > > +	xen_hvc
> > > > > +	pop {r4}
> > > 
> > > Why not ldmdb for symmetry?
> > 
> > Yep, I can do that.

Actually it is just ldm or ldmia
