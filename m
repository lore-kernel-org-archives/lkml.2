Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755087Ab2C0OoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 10:44:03 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:18677 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab2C0Onj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 10:43:39 -0400
Date: Mon, 26 Mar 2012 12:38:20 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>, "Brown, Len" <len.brown@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "keir.xen@gmail.com" <keir.xen@gmail.com>,
        Jan Beulich <JBeulich@suse.com>, "Li, Shaohua" <shaohua.li@intel.com>
Subject: Re: [PATCH 2/2] RFC: Xen pad logic
Message-ID: <20120326163820.GD10236@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923350AD0A6@SHSMSX101.ccr.corp.intel.com>
 <20120314001833.GB20363@phenom.dumpdata.com>
 <DE8DF0795D48FD4CA783C40EC8292335105DB9@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC8292335105DB9@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090201.4F71D20E.00B6,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 06:18:36AM +0000, Liu, Jinsong wrote:
> Konrad Rzeszutek Wilk wrote:
> > On Thu, Feb 23, 2012 at 01:31:25PM +0000, Liu, Jinsong wrote:
> >>> From ba9abf6ee7e5fe0515e2d51b14743c8d5416285c Mon Sep 17 00:00:00
> >>> 2001 
> >> From: Liu, Jinsong <jinsong.liu@intel.com>
> >> Date: Fri, 24 Feb 2012 02:18:02 +0800
> >> Subject: [PATCH 2/2] Xen pad logic
> >> 
> >> This patch implement Xen pad logic, and when getting pad device
> >> notification, it hypercalls to Xen hypervisor for core parking.
> > 
> > Can you explain to me how and what pad device is? And how it functions
> > right now in baremetal? And what kind of hardware do you need to use
> > this? 
> > And what happens if you do not use it? Can one ignore the "pad"
> > support? 
> > Please assume that I've a basic understanding of ACPI.
> > 
> > 
> > Also, what happens now, if the this patch is not implemented? What
> > will/is dom0 doing without these patches (so 3.2 for example on this
> > machine)? 
> > Is it just idling using mwait on idle CPUs and ending up trapping in
> > the hypervisor? Or is not mwaiting since the cstate.c doesn't get
> > executed since we have: 
> > 
> >        boot_option_idle_override = IDLE_HALT;
> > 
> > in arch/x86/xen/setup.c ?
> 
> 
> Pad is an ACPI device used to direct os taking some action (depend on os itsef) for the sake of power consumption. 2 objs (PUR and OST) could be declared under PAD and as bios/os interface.
> 
> PAD itself is pointless, unless it co-work with some external power control s/w (like NPTM). For example currently in baremetal, NPTM engine trigger sci to ospm, then evaluate and call sci handler, through which bios notify os with PUR value by which os could take corresponding action and feedback bios through OST. I don't think it's a problem if user don't use PAD or ignore it, it only make some external power control s/w unuseable.

What is NPTM? Sounds like a SMI firmware?

> 
> As for how os handle pad notify is os business. Native kernel use round robin and mwait, considering some app workload affinity (I was told so). For xen we don't need care it since it's a question of vcpu level. For xen acpi_pad, dom0 patches used to parse PUR and hypercall to hypervisor, which in turn idle pcpu by its own algorithm.

I presume you have some of this hardware - if you launch the latest linus/master (along with these
patches https://bugzilla.redhat.com/show_bug.cgi?id=804347 patches) and compile CONFIG_ACPI_PAD_PROCESSOR=y
and are running under Xen 4.1, what happens when the _PUR notifcation takes affect?
