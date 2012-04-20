Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2DTQsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 12:48:37 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:17136 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593Ab2DTQsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 12:48:36 -0400
Date: Fri, 20 Apr 2012 12:43:25 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Lin Ming <mlin@ss.pku.edu.cn>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        Andrew Cooper <Andrew.Cooper3@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen/apic: implement io apic read with
 hypercall
Message-ID: <20120420164325.GD31062@phenom.dumpdata.com>
References: <1334913957.2863.1.camel@hp6530s>
 <4F913340.4000202@citrix.com>
 <1334920396.2863.16.camel@hp6530s>
 <1334925508.28331.63.camel@zakaz.uk.xensource.com>
 <4F915C43.4020207@citrix.com>
 <1334927566.28331.80.camel@zakaz.uk.xensource.com>
 <CAF1ivSaPshQf=BZ1gKLUq1yRF_MWeyjjVWkfv+E_jT+K5CFmAA@mail.gmail.com>
 <1334934367.28331.99.camel@zakaz.uk.xensource.com>
 <1334936364.2863.24.camel@hp6530s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334936364.2863.24.camel@hp6530s>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-CT-RefId: str=0001.0A090206.4F91935B.000B,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 11:39:24PM +0800, Lin Ming wrote:
> On Fri, 2012-04-20 at 16:06 +0100, Ian Campbell wrote:
> > On Fri, 2012-04-20 at 15:50 +0100, Lin Ming wrote:
> > > On Fri, Apr 20, 2012 at 9:12 PM, Ian Campbell <Ian.Campbell@citrix.com> wrote:
> > > > On Fri, 2012-04-20 at 13:53 +0100, Andrew Cooper wrote:
> > > >> >
> > > >> > Under what circumstances can these hypercalls fail? Would a BUG_ON be
> > > >> > appropriate/
> > > >>
> > > >> -EFAULT, -EPERM, anything xsm_apic() could return (which looks only to
> > > >> be -EPERM).
> > > >
> > > > So either the guest has called a hypercall which it is not permitted to
> > > > or it has called it with invalid parameters of one sort or another. Both
> > > > of these would be a code bug in the guest and therefore asserting that
> > > > no failure occurred is reasonable?
> > > >
> > > > What could the caller do with the error other than log it and collapse?
> > > >
> > > >> The call into Xen itself will return 0 as a value if an
> > > >> invalid physbase is passed in the hypercall.
> 
> Just checked ioapic_guest_read.
> It will return -EINVAL if an invalid physbase is passed in.
> 
> > > >
> > > >> So a BUG_ON() is not safe/sensible for domU.
> > > >
> > > > I think you have successfully argued that it is ;-)
> > > 
> > > BUG_ON is too severe.
> > 
> > Why? Under what circumstances can this be correctly called in a way
> > which would result in the hypercall failing?
> 
> Is BUG_ON() reasonable if invalid physbase passed in?

Just emulate the values in the error case. We don't _need_ them per say - except
to emulate some sensible values.

> 
> > 
> > >  How about WARN_ON?
> > > 
> > > ret = hypercall(...)
> > > 
> > > if (ret) {
> > >    WARN_ON(1);
> > >    return -1;
> > > }
> > > 
> > > 
> > > >
> > > > Ian.
> > 
> > 
> 
