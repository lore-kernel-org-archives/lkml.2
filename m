Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750975Ab0L1FD3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 00:03:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:29938 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718Ab0L1FD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 00:03:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,237,1291622400"; 
   d="scan'208";a="640973782"
Subject: Re: [PATCH] ACPI: use ioremap_cache()
From: Shaohua Li <shaohua.li@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Len Brown <lenb@kernel.org>, Jack Steiner <steiner@sgi.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "tony.luck@gmail.com" <tony.luck@gmail.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gbeshers@sgi.com" <gbeshers@sgi.com>
In-Reply-To: <4D195AFF.9020106@zytor.com>
References: <20101214220932.GA1206@sgi.com>
	 <alpine.LFD.2.00.1012141903210.25387@x980> <20101215024136.GB19601@sgi.com>
	 <alpine.LFD.2.00.1012142302110.4878@x980> <20101215164635.GA27373@sgi.com>
	 <alpine.LFD.2.00.1012151536510.21167@x980>
	 <alpine.LFD.2.00.1012162149370.20940@x980>
	 <alpine.LFD.2.00.1012170307080.20940@x980>
	 <1293506460.10593.43.camel@sli10-conroe>  <4D195AFF.9020106@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Dec 2010 13:02:20 +0800
Message-ID: <1293512540.10593.46.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-28 at 11:35 +0800, H. Peter Anvin wrote:
> On 12/27/2010 07:21 PM, Shaohua Li wrote:
> > RCRB is a memory mapped io. In ICH, it's chipset configuration
> > registers. this range can't be cached.
> > I thought we should add a check like
> > if page is E820_RAM or E820_ACPI then
> > 	cached_map
> > else
> > 	uncached_map
> > we have page_is_ram() API which just checks E820_RAM, I thought we can
> > add a new API to check E820_ACPI.
> 
> For x86, that is handled by the MTRRs; 
does it cause any problem if the pat and mtrr doesn't match?

