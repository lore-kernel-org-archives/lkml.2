Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab0LWSEx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 13:04:53 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:58419 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab0LWSEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 13:04:52 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6206"; a="67832300"
From: David Brown <davidb@codeaurora.org>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Kyungmin Park <kmpark@infradead.org>, linux-media@vger.kernel.org,
        Johan MOSSBERG <johan.xx.mossberg@stericsson.com>,
        Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>, linux-mm@kvack.org,
        linux-arm-kernel@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Tomasz Fujak <t.fujak@samsung.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCHv8 00/12] Contiguous Memory Allocator
References: <cover.1292443200.git.m.nazarewicz@samsung.com>
	<AANLkTim8_=0+-zM5z4j0gBaw3PF3zgpXQNetEn-CfUGb@mail.gmail.com>
	<20101223100642.GD3636@n2100.arm.linux.org.uk>
	<00ea01cba290$4d67f500$e837df00$%szyprowski@samsung.com>
	<20101223121917.GG3636@n2100.arm.linux.org.uk>
	<4D135004.3070904@samsung.com>
	<20101223134838.GK3636@n2100.arm.linux.org.uk>
	<4D1356D7.2000008@samsung.com>
	<20101223141608.GM3636@n2100.arm.linux.org.uk>
	<AANLkTinzsOom5awOr6Y8e7PKRbCWYQOqEbdw9is6HroR@mail.gmail.com>
Date: Thu, 23 Dec 2010 10:04:51 -0800
In-Reply-To: <AANLkTinzsOom5awOr6Y8e7PKRbCWYQOqEbdw9is6HroR@mail.gmail.com>
	(Felipe Contreras's message of "Thu, 23 Dec 2010 16:42:57 +0200")
Message-ID: <8yasjxobc1o.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe Contreras <felipe.contreras@gmail.com> writes:

> On Thu, Dec 23, 2010 at 4:16 PM, Russell King - ARM Linux

> A generic solution (that I think I already proposed) would be to
> reserve a chunk of memory for the CMA that can be removed from the
> normally mapped kernel memory through memblock at boot time. The size
> of this memory region would be configurable through kconfig. Then, the
> CMA would have a "dma" flag or something, and take chunks out of it
> until there's no more, and then return errors. That would work for
> ARM.

That sounds an awful lot like the Android kernel's pmem implementation.

Solving this problem is important for us as well, but, I'm not sure I
see a better solution that something like Felipe suggests.

The disadvantage, of course, being that the memory isn't available for
the system when the user isn't doing the multi-media.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
