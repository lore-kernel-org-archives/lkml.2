Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab2BZRik (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 12:38:40 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:49068 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751838Ab2BZRii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 12:38:38 -0500
Date: Sun, 26 Feb 2012 12:34:58 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "Liu, Jinsong" <jinsong.liu@intel.com>
Cc: Jan Beulich <jbeulich@suse.com>, "keir.xen@gmail.com" <keir.xen@gmail.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] RFC: Prepare PAD for native and xen platform
Message-ID: <20120226173458.GB18098@phenom.dumpdata.com>
References: <DE8DF0795D48FD4CA783C40EC82923350AD088@SHSMSX101.ccr.corp.intel.com>
 <4F46530B020000780007F751@nat28.tlf.novell.com>
 <DE8DF0795D48FD4CA783C40EC82923350AD9BB@SHSMSX101.ccr.corp.intel.com>
 <DE8DF0795D48FD4CA783C40EC82923350B2013@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923350B2013@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4F4A6E14.00B1,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 26, 2012 at 08:25:41AM +0000, Liu, Jinsong wrote:
> Liu, Jinsong wrote:
> > Jan Beulich wrote:
> >>>>> "Liu, Jinsong" <jinsong.liu@intel.com> 02/23/12 2:29 PM >>>
> >>> --- a/drivers/acpi/Kconfig
> >>> +++ b/drivers/acpi/Kconfig
> >>> @@ -213,10 +213,11 @@ config ACPI_HOTPLUG_CPU
> >>>    default y
> >>  >
> >>> config ACPI_PROCESSOR_AGGREGATOR
> >>> -    tristate "Processor Aggregator"
> >>> +    bool "Processor Aggregator"
> >> 
> >> There must be ways to address whatever strange problem you see
> >> without making this piece of code non-modular.
> >> 
> > 
> > Yes, another approach is x86_init approach, defining acpi_pad_ops at
> > x86_init.c and overwritten when xen_start_kernel. This patch is just
> > a RFC patch, to evaluate which approch is more reasonable :-) 
> > 
> 
> Have a more think about it, x86_init approach still need to disable acpi_pad module.
> Seems we have to set acpi_pad as bool, as long as it need to hook to native acpi_pad fucs/variables.

What about the other approach I suggested where there are some function
overrides in osl.c? Something similar to https://lkml.org/lkml/2012/1/17/401,
specifically https://lkml.org/lkml/2012/1/17/403 - that way you are not turning
the modules into being built in, but intead have the function table already in
the kernel (as some form of EXPORT_SYMBOL_GPL or a registration function).

Instead of just one function being over-ridden it could have some more. However
I am not sure if the osl.c is the place for this either. Perhaps Len might
have some better ideas?

