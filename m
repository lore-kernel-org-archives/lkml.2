Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab2CTUla (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 16:41:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:61956 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754353Ab2CTUl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 16:41:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="79718486"
Subject: Re: 3.2.1 Unable to reset IRR messages on boot
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, yinghai@kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@fedoraproject.org,
        midgoon@gmail.com
Date: Tue, 20 Mar 2012 13:41:32 -0700
In-Reply-To: <20120320202546.GA29554@phenom.dumpdata.com>
References: <20120131142621.GA2136@zod.bos.redhat.com>
	 <1328083230.3638.2.camel@sbsiddha-mobl2>
	 <20120312132448.GA20204@zod.bos.redhat.com>
	 <1331577393.31585.94.camel@sbsiddha-desk.sc.intel.com>
	 <20120319133046.GB13093@zod.bos.redhat.com>
	 <20120319193842.GA8123@phenom.dumpdata.com>
	 <20120320094048.GC20079@phenom.dumpdata.com>
	 <1332267178.16101.66.camel@sbsiddha-desk.sc.intel.com>
	 <20120320185841.GF29554@phenom.dumpdata.com>
	 <1332273919.16101.74.camel@sbsiddha-desk.sc.intel.com>
	 <20120320202546.GA29554@phenom.dumpdata.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1332276093.16101.78.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-20 at 16:25 -0400, Konrad Rzeszutek Wilk wrote:
> On Tue, Mar 20, 2012 at 01:05:19PM -0700, Suresh Siddha wrote:
> > Also does the dom0 see all the GSI's/io-apic's that the host sees or is
> > it going to be just one io-apic? I was just wondering if the reg 01 need
> > to be same as what the host sees?
> 
> It does not use the APIC mechanism at all. It only needs the GSI value
> from the IOAPIC and LAPIC so that the ACPI can work.

So the number of redirection entries in the io-apic need to be same as
the original values then?

> It could also at startup copy the original values and stick them in these copies.
> That does mean using the memory allocator to allocate X copies for X IOAPICS. I
> don't think the memory allocator is active at that stage since we using fixmaps.
> Thoughts?

You should be able to use alloc_bootmem friends.

thanks,
suresh


