Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab0LWOI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 09:08:27 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:59783 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab0LWOI0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 09:08:26 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=ISO-8859-1
Date: Thu, 23 Dec 2010 15:08:21 +0100
From: Tomasz Fujak <t.fujak@samsung.com>
Subject: Re: [PATCHv8 00/12] Contiguous Memory Allocator
In-reply-to: <20101223135120.GL3636@n2100.arm.linux.org.uk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kmpark@infradead.org>,
        linux-arm-kernel@lists.infradead.org,
        Daniel Walker <dwalker@codeaurora.org>,
        Johan MOSSBERG <johan.xx.mossberg@stericsson.com>,
        Mel Gorman <mel@csn.ul.ie>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Ankita Garg <ankita@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-media@vger.kernel.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Message-id: <4D1357D5.9000507@samsung.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.13)
 Gecko/20101207 Thunderbird/3.1.7
References: <cover.1292443200.git.m.nazarewicz@samsung.com>
 <AANLkTim8_=0+-zM5z4j0gBaw3PF3zgpXQNetEn-CfUGb@mail.gmail.com>
 <20101223100642.GD3636@n2100.arm.linux.org.uk>
 <87k4j0ehdl.fsf@erwin.mina86.com>
 <20101223135120.GL3636@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-12-23 14:51, Russell King - ARM Linux wrote:
> On Thu, Dec 23, 2010 at 02:41:26PM +0100, Michal Nazarewicz wrote:
>> Russell King - ARM Linux <linux@arm.linux.org.uk> writes:
>>> Has anyone addressed my issue with it that this is wide-open for
>>> abuse by allocating large chunks of memory, and then remapping
>>> them in some way with different attributes, thereby violating the
>>> ARM architecture specification?
>>>
>>> In other words, do we _actually_ have a use for this which doesn't
>>> involve doing something like allocating 32MB of memory from it,
>>> remapping it so that it's DMA coherent, and then performing DMA
>>> on the resulting buffer?
>> Huge pages.
>>
>> Also, don't treat it as coherent memory and just flush/clear/invalidate
>> cache before and after each DMA transaction.  I never understood what's
>> wrong with that approach.
> If you've ever used an ARM system with a VIVT cache, you'll know what's
> wrong with this approach.
>
> ARM systems with VIVT caches have extremely poor task switching
> performance because they flush the entire data cache at every task switch
> - to the extent that it makes system performance drop dramatically when
> they become loaded.
>
> Doing that for every DMA operation will kill the advantage we've gained
> from having VIPT caches and ASIDs stone dead.
This statement effectively means: don't map dma-able memory to the CPU
unless it's uncached. Have I missed anything?

> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

