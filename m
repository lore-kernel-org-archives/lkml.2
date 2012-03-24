Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756541Ab2CXAiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 20:38:51 -0400
Received: from andromeda.dapyr.net ([206.212.254.10]:57482 "EHLO
	andromeda.dapyr.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756097Ab2CXAis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 20:38:48 -0400
X-Greylist: delayed 446 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Mar 2012 20:38:47 EDT
Date: Fri, 23 Mar 2012 20:31:11 -0400
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "keir.xen@gmail.com" <keir.xen@gmail.com>,
        Jan Beulich <JBeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH 1/3] PAD helper for native and paravirt platform
Message-ID: <20120324003111.GA11777@andromeda.dapyr.net>
References: <DE8DF0795D48FD4CA783C40EC829233509D853@SHSMSX101.ccr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC829233509D853@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 08:56:43AM +0000, Liu, Jinsong wrote:
> >From f66a2df1392bbe69426387657a220177be50d58a Mon Sep 17 00:00:00 2001
> From: Liu, Jinsong <jinsong.liu@intel.com>
> Date: Fri, 10 Feb 2012 20:32:50 +0800
> Subject: [PATCH 1/3] PAD helper for native and paravirt platform
> 
> This patch is PAD (Processor Aggregator Device) helper.
> It provides a native interface for natvie platform, and a template
> for paravirt platform, so that os can implicitly hook to proper ops accordingly.
> The paravirt template will further redirect to Xen pv ops in later patch for Xen
>  core parking.

Liu,

With this patch: "  xen/enlighten: Expose MWAIT and MWAIT_LEAF if
hypervisor OKs it." which is now in 3.4-rc0:
(http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blobdiff;f=arch/x86/xen/enlighten.c;h=b132ade26f778f2cfec7c2d5c7b6db48afe424d5;hp=4172af8ceeb363d06912af15bf89e8508752b794;hb=d4c6fa73fe984e504d52f3d6bba291fd76fe49f7;hpb=aab008db8063364dc3c8ccf4981c21124866b395)
it means that now that the drivers/acpi/acpi_pad.c can run
as is under Xen (as the MWAIT_LEAF is exposed) What is the impact
of that? Is the monitor call causing a trap to the hypervisor which will
ignore the call? Or will it have some more worrysome consequences?

Thanks!
