Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab0GMHV5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 03:21:57 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49411 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab0GMHVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 03:21:54 -0400
Date: Tue, 13 Jul 2010 08:20:09 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shaohua Li <shaohua.li@intel.com>, Yakui Zhao <yakui.zhao@intel.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        arm-kernel@lists.infradead.org, kgene.kim@samsung.com,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [RFC] Tight check of pfn_valid on sparsemem
Message-ID: <20100713072009.GA19839@n2100.arm.linux.org.uk>
References: <20100712155348.GA2815@barrios-desktop> <20100713121947.612bd656.kamezawa.hiroyu@jp.fujitsu.com> <AANLkTiny7dz8ssDknI7y4JFcVP9SV1aNM7f0YMUxafv7@mail.gmail.com> <20100713132312.a7dfb100.kamezawa.hiroyu@jp.fujitsu.com> <AANLkTinVwmo5pemz86nXaQT3V_ujaPLOsyNeQIFhL0Vu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinVwmo5pemz86nXaQT3V_ujaPLOsyNeQIFhL0Vu@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 03:04:00PM +0900, Minchan Kim wrote:
> > __get_user() works with TLB and page table, the vaddr is really mapped or not.
> > If you got SEGV, __get_user() returns -EFAULT. It works per page granule.

Not in kernel space.  It works on 1MB sections there.

Testing whether a page is mapped by __get_user is a hugely expensive
way to test whether a PFN is valid.  It'd be cheaper to use our
flatmem implementation of pfn_valid() instead.
