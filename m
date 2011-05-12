Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab1ELS6Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 14:58:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64339 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750930Ab1ELS6X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 14:58:23 -0400
Date: Thu, 12 May 2011 14:58:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Daniel Kiper <dkiper@net-space.pl>
Cc: stefano.stabellini@eu.citrix.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] [PATCH] arch/x86/xen/setup: Fix for incorrect
 xen_extra_mem_start initialization ifdef CONFIG_X86_32
Message-ID: <20110512185808.GA26281@dumpdata.com>
References: <20110511203438.GA21034@router-fw-old.local.net-space.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110511203438.GA21034@router-fw-old.local.net-space.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4DCC2DCA.014D:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 10:34:38PM +0200, Daniel Kiper wrote:
> git commit 24bdb0b62cc82120924762ae6bc85afc8c3f2b26 (xen: do not create
> the extra e820 region at an addr lower than 4G) does not take into
> account that ifdef CONFIG_X86_32 instead of e820_end_of_low_ram_pfn()
> find_low_pfn_range() is called (both calls are from arch/x86/kernel/setup.c).
> find_low_pfn_range() behaves correctly and does not require change in
> xen_extra_mem_start initialization. Additionally, if xen_extra_mem_start
> is initialized in the same way as ifdef CONFIG_X86_64 then memory hotplug
> support for Xen balloon driver (under development) is broken.

in linux-next.
