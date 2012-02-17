Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753644Ab2BQTJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 14:09:49 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:40375 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751494Ab2BQTJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 14:09:48 -0500
Date: Fri, 17 Feb 2012 14:06:31 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Jan Beulich <JBeulich@suse.com>, "keir.xen@gmail.com" <keir.xen@gmail.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        xen-devel <xen-devel@lists.xen.org>,
        Kerneldevelopment list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] PAD helper for native and paravirt platform
Message-ID: <20120217190631.GA20584@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC829233509D853@SHSMSX101.ccr.corp.intel.com>
 <4F3E345802000078000739B2@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC829233509F044@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233509F044@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090208.4F3EA5F5.0014,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 05:59:56PM +0000, Liu, Jinsong wrote:
> >> 
> >> +static inline int __acpi_pad_init(void)
> >> +{
> >> +	return PVOP_CALL0(int, pv_pad_ops.acpi_pad_init); +}
> >> +
> >> +static inline void __acpi_pad_exit(void)
> >> +{
> >> +	PVOP_VCALL0(pv_pad_ops.acpi_pad_exit);
> >> +}
> > 
> > With this you, aiui, you aim at getting the calls patched. Are the
> > callers of this really on performance critical paths? If not, the
> > simpler approach of having an ops structure the fields of which get
> > overwritten by 
> > Xen initialization would seem a more appropriate approach.
> > 
> 
> Yes, I agree. I code in this way just want to keep same coding style as other pv functions of paravirt.h.
> I update the patch w/ a simpler approach, and will post later.
> Of course, we need Konrad's comments.

The thing is that the paravirt approach also impacts lguests. While I don't
think your patch will affect it, it just doesn't seem like the right place.

It seems that a more general approach, like the x86 one would be appropiate.
Or since this is ACPI related - perhaps in the drivers/acpi/osl.c ? - That is
all "OS dependent functions" and seem proper?

