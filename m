Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332Ab2CNAWr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 20:22:47 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:44029 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab2CNAWp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 20:22:45 -0400
Date: Tue, 13 Mar 2012 20:18:33 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>, "Brown, Len" <len.brown@intel.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "keir.xen@gmail.com" <keir.xen@gmail.com>,
        Jan Beulich <JBeulich@suse.com>, "Li, Shaohua" <shaohua.li@intel.com>
Subject: Re: [PATCH 2/2] RFC: Xen pad logic
Message-ID: <20120314001833.GB20363@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923350AD0A6@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923350AD0A6@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4F5FE4CB.00A0,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 01:31:25PM +0000, Liu, Jinsong wrote:
> >From ba9abf6ee7e5fe0515e2d51b14743c8d5416285c Mon Sep 17 00:00:00 2001
> From: Liu, Jinsong <jinsong.liu@intel.com>
> Date: Fri, 24 Feb 2012 02:18:02 +0800
> Subject: [PATCH 2/2] Xen pad logic
> 
> This patch implement Xen pad logic, and when getting pad device
> notification, it hypercalls to Xen hypervisor for core parking.

Can you explain to me how and what pad device is? And how it functions
right now in baremetal? And what kind of hardware do you need to use this?
And what happens if you do not use it? Can one ignore the "pad" support?
Please assume that I've a basic understanding of ACPI. 


Also, what happens now, if the this patch is not implemented? What
will/is dom0 doing without these patches (so 3.2 for example on this machine)?
Is it just idling using mwait on idle CPUs and ending up trapping in the hypervisor?
Or is not mwaiting since the cstate.c doesn't get executed since we have:

       boot_option_idle_override = IDLE_HALT;

in arch/x86/xen/setup.c ?
