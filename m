Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab1GDOq2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 10:46:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60264 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352Ab1GDOqZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 10:46:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ankita Garg <ankita@in.ibm.com>
Subject: Re: [Linaro-mm-sig] [PATCH 08/10] mm: cma: Contiguous Memory Allocator added
Date: Mon, 4 Jul 2011 16:45:29 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Larry Bassel <lbassel@codeaurora.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Zach Pfeffer'" <zach.pfeffer@linaro.org>,
        "'Daniel Walker'" <dwalker@codeaurora.org>,
        "'Daniel Stone'" <daniels@collabora.com>,
        "'Jesse Barker'" <jesse.barker@linaro.org>,
        "'Mel Gorman'" <mel@csn.ul.ie>,
        "'KAMEZAWA Hiroyuki'" <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        "'Michal Nazarewicz'" <mina86@mina86.com>,
        linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com> <201106160006.07742.arnd@arndb.de> <20110704052539.GK12667@in.ibm.com>
In-Reply-To: <20110704052539.GK12667@in.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107041645.29385.arnd@arndb.de>
X-Provags-ID: V02:K0:QfxzRzbAzfe/CEdY5KcJoCxY31lMiZt2d7qUGRa66cT
 jaQNbOSobzzEH3mHk0c9DUnTS1SDIuGPogs2uJd1OBZ50ePJd1
 2ppw2Hn/kPyB/U4f8hzZ0EbR3qn3QlhMPURcCmBsOeUUoSmtTw
 3npjW2vpOY3/2nypLtWPaiEYWEijthzsI+3bNOTGaFxaV0AWJF
 m9aybBteBIdgZ1YibgiPQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 July 2011, Ankita Garg wrote:
> > It still sounds to me that this can be done using the NUMA properties
> > that Linux already understands, and teaching more subsystems about it,
> > but maybe the memory hotplug developers have already come up with
> > another scheme. The way that memory hotplug and CMA choose their
> > memory regions certainly needs to take both into account. As far as
> > I can see there are both conflicting and synergistic effects when
> > you combine the two.
> > 
> 
> Recently, we proposed a generic 'memory regions' framework to exploit
> the memory power management capabilities on the embedded boards. Think
> of some of the above CMA requirements could be met by this fraemwork.
> One of the main goals of regions is to make the VM aware of the hardware
> memory boundaries, like bank. For managing memory power consumption,
> memory regions are created aligned to the hardware granularity at which
> the power can be managed (ie, the memory power consumption operations
> like on/off can be performed). If attributed are associated with each of
> these regions, some of these regions could be marked as CMA-only,
> ensuring that only movable and per-bank memory is allocated. More
> details on the design can be found here:
> 
> http://lkml.org/lkml/2011/5/27/177
> http://lkml.org/lkml/2011/6/29/202
> http://lwn.net/Articles/446493/

Thanks for the pointers, that is exactly what I was looking for.

	Arnd
