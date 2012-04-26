Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab2DZPjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:39:46 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:47458 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757194Ab2DZPjo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:39:44 -0400
Date: Thu, 26 Apr 2012 11:33:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Lin Ming <mlin@ss.pku.edu.cn>
Cc: Andrew Cooper <Andrew.Cooper3@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/apic: implement io apic read with
 hypercall
Message-ID: <20120426153346.GC26830@phenom.dumpdata.com>
References: <1334913957.2863.1.camel@hp6530s>
 <4F913340.4000202@citrix.com>
 <1334920396.2863.16.camel@hp6530s>
 <1334925508.28331.63.camel@zakaz.uk.xensource.com>
 <20120420164150.GC31062@phenom.dumpdata.com>
 <CAF1ivSamaYzQDwjFqRGrnQ+fCr0D4vLGuG4JRBZ3_GD_y8yY=A@mail.gmail.com>
 <20120423151123.GC24481@phenom.dumpdata.com>
 <CAF1ivSY1GAkqU2gN0P22Tb0pmwagam5UUVMABSgnoH3+C+TY+A@mail.gmail.com>
 <20120424162321.GH3213@phenom.dumpdata.com>
 <CAF1ivSYFp7duSCNb+_5teM83icx1O-rY0YVFm7Laq_JLZuzerw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CAF1ivSYFp7duSCNb+_5teM83icx1O-rY0YVFm7Laq_JLZuzerw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>
> >> unsigned int xen_io_apic_read(unsigned apic, unsigned reg)
> >> {
> >>         struct physdev_apic apic_op;
> >>         int ret;
> >>
> >>         apic_op.apic_physbase = mpc_ioapic_addr(apic);
> >>         apic_op.reg = reg;
> >>         ret = HYPERVISOR_physdev_op(PHYSDEVOP_apic_read, &apic_op);
> >>         if (!ret)
> >>                 return apic_op.value;
> >>
> >>         /* emulate register */
> >>         if (reg == 0x1)
> >>                 return 0x00170020;
> >>         else if (reg == 0x0)
> >>                 return apic << 24;
> >>         else
> >>                 return -1;
> >
> >        return 0xfd;
> 
> Where does this magic number 0xfd come from?
> 
> Both native_io_apic_read and xen_io_apic_read does not return 0xfd on error.

That is correct. But that is what it should have been. Suresh
pointed that out sometime and I managed to lose that part in one of the
commits. The earlier patch of this version did that.

Thought thinking about it this some I am not sure if 0xff is a better
choice... In the end it probably does not matter the slighest.

