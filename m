Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752040Ab0GMHjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 03:39:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45873 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153Ab0GMHjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 03:39:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 13 Jul 2010 16:34:17 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Minchan Kim <minchan.kim@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>, Yakui Zhao <yakui.zhao@intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC] Tight check of pfn_valid on sparsemem
Message-Id: <20100713163417.17895202.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100713072009.GA19839@n2100.arm.linux.org.uk>
References: <20100712155348.GA2815@barrios-desktop>
	<20100713121947.612bd656.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTiny7dz8ssDknI7y4JFcVP9SV1aNM7f0YMUxafv7@mail.gmail.com>
	<20100713132312.a7dfb100.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTinVwmo5pemz86nXaQT3V_ujaPLOsyNeQIFhL0Vu@mail.gmail.com>
	<20100713072009.GA19839@n2100.arm.linux.org.uk>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Jul 2010 08:20:09 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Tue, Jul 13, 2010 at 03:04:00PM +0900, Minchan Kim wrote:
> > > __get_user() works with TLB and page table, the vaddr is really mapped or not.
> > > If you got SEGV, __get_user() returns -EFAULT. It works per page granule.
> 
> Not in kernel space.  It works on 1MB sections there.
> 
> Testing whether a page is mapped by __get_user is a hugely expensive
> way to test whether a PFN is valid.

Note: pfn_valid() is for checking "there is memmap". 

> It'd be cheaper to use our flatmem implementation of pfn_valid() instead.
> 
Hmm. IIUC, pfn_valid() succeeds in almost all case if there is a section.
But yes, I'm not familar with ARM. 

I love another idea as I've already shown as preparing _a_ page filled with
0x00004000 and map it into the all holes. PG_reserved will help almost all case
even if it's ugly.

Anyway, sparsemem is designed to be aligned to SECTION_SIZE of memmap.
Please avoid adding new Spaghetti code without proper configs.
Thanks,
-Kame

