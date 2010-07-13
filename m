Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab0GMIHS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 04:07:18 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47352 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab0GMIHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 04:07:14 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 13 Jul 2010 17:02:22 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Minchan Kim <minchan.kim@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>, Yakui Zhao <yakui.zhao@intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC] Tight check of pfn_valid on sparsemem
Message-Id: <20100713170222.9369e649.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100713165808.e340e6dc.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100712155348.GA2815@barrios-desktop>
	<20100713121947.612bd656.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTiny7dz8ssDknI7y4JFcVP9SV1aNM7f0YMUxafv7@mail.gmail.com>
	<20100713132312.a7dfb100.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTinVwmo5pemz86nXaQT3V_ujaPLOsyNeQIFhL0Vu@mail.gmail.com>
	<20100713072009.GA19839@n2100.arm.linux.org.uk>
	<20100713163417.17895202.kamezawa.hiroyu@jp.fujitsu.com>
	<20100713165808.e340e6dc.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010 16:58:08 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Tue, 13 Jul 2010 16:34:17 +0900
> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 
> > Anyway, sparsemem is designed to be aligned to SECTION_SIZE of memmap.
> > Please avoid adding new Spaghetti code without proper configs.
> > Thanks,
> 
> Ok, I realized I misunderstand all. Arm doesn't unmap memmap but reuse the page
> for memmap without modifing ptes. My routine only works when ARM uses sparsemem_vmemmap.
> But yes, it isn't.
> 
> Hmm...How about using pfn_valid() for FLATMEM or avoid using SPARSEMEM ?
> If you want conrols lower than SPARSEMEM, FLATMEM works better because ARM unmaps memmap.
                      allocation of memmap in lower granule than SPARSEMEM.


How about stop using SPARSEMEM ? What's the benefit ? It just eats up memory for
mem_section[].

Sorry,
-Kame

