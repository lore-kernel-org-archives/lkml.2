Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829Ab2CTUxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 16:53:50 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:22545 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab2CTUxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 16:53:25 -0400
Date: Tue, 20 Mar 2012 16:48:59 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org,
        midgoon@gmail.com
Subject: Re: 3.2.1 Unable to reset IRR messages on boot
Message-ID: <20120320204859.GA25944@phenom.dumpdata.com>
References: <20120312132448.GA20204@zod.bos.redhat.com>
 <1331577393.31585.94.camel@sbsiddha-desk.sc.intel.com>
 <20120319133046.GB13093@zod.bos.redhat.com>
 <20120319193842.GA8123@phenom.dumpdata.com>
 <20120320094048.GC20079@phenom.dumpdata.com>
 <1332267178.16101.66.camel@sbsiddha-desk.sc.intel.com>
 <20120320185841.GF29554@phenom.dumpdata.com>
 <1332273919.16101.74.camel@sbsiddha-desk.sc.intel.com>
 <20120320202546.GA29554@phenom.dumpdata.com>
 <1332276093.16101.78.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332276093.16101.78.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090208.4F68EE3C.0018,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 01:41:32PM -0700, Suresh Siddha wrote:
> On Tue, 2012-03-20 at 16:25 -0400, Konrad Rzeszutek Wilk wrote:
> > On Tue, Mar 20, 2012 at 01:05:19PM -0700, Suresh Siddha wrote:
> > > Also does the dom0 see all the GSI's/io-apic's that the host sees or is
> > > it going to be just one io-apic? I was just wondering if the reg 01 need
> > > to be same as what the host sees?
> > 
> > It does not use the APIC mechanism at all. It only needs the GSI value
> > from the IOAPIC and LAPIC so that the ACPI can work.
> 
> So the number of redirection entries in the io-apic need to be same as
> the original values then?

It can be up to sixteen and or up to whatever the INT_SRV_OVR has. With
the dummy mapping it was 0xff, which meant it had up to 255 which was more than
enough.
> 
> > It could also at startup copy the original values and stick them in these copies.
> > That does mean using the memory allocator to allocate X copies for X IOAPICS. I
> > don't think the memory allocator is active at that stage since we using fixmaps.
> > Thoughts?
> 
> You should be able to use alloc_bootmem friends.
> 
> thanks,
> suresh
> 
