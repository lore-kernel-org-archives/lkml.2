Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab0LOGRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 01:17:48 -0500
Received: from mail4.comsite.net ([205.238.176.238]:15953 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750926Ab0LOGRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 01:17:46 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH] - Mapping ACPI tables as CACHED
To: Len Brown <lenb@kernel.org>, Jack Steiner <steiner@sgi.com>,
        "H. Peter Anvin" <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
Message-Id: <acpi-map-cache-err@mdm.bga.com>
In-Reply-To: <alpine.LFD.2.00.1012142317450.4878@x980>
References: <alpine.LFD.2.00.1012142317450.4878@x980>
	<20101214220932.GA1206@sgi.com>
	<alpine.LFD.2.00.1012141903210.25387@x980>
	<20101215024136.GB19601@sgi.com>
	<alpine.LFD.2.00.1012142302110.4878@x980>
Date: Wed, 15 Dec 2010 00:17:44 -0600
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Dec 2010 at about 23:35:28 -0500 (EST), Len Brown wrote:
> 
> [ 1.444475] LENB: free_initmem() NOT!
> is where free_initmem(); would have been called.
> 
> So the calls to acpi_os_map_memory() at 2.586160, kill the machine.
> 
> My guess is that they are related to the opregion stuff used by i915;
> but there is no reason that acpi_os_map_memory can't be called
> as a result of AML at run-time any-time later.
> 
> BTW. what, exactly does this notation do for us?
> 
> void __iomem *__init_refok acpi_os_map_memory(...) {

A function that returns a void pointer for dereference via iomem
accessors that is not init but may conditionally call init text.

__init_refok says that the code was audited to conditionally
use init vs non-init text and data.

> 
> Also, I see no calls within E820_RAM.
> 
> I see a call at 0.534537 which is not in E820_RAM, ACPI, or NVS,
> but is in a reserved region.
> 
> I'm not sure the concept of checking against E820
> is better than simply calling ioremap_cache() always.
> 
> thanks,

after digging back through the thread for the patch, it would seem
that both __acpi_map_table_permanent and e820_all_mapped would
need to be moved from init to normal text, as this is replacing
the non-init path.  I'll let the maintainers decide if that is the
right solution (vs unconditonally mapping cached, or something else).

milton
