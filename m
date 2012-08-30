Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab2H3CDu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 22:03:50 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42464 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab2H3CDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 22:03:48 -0400
Message-ID: <503EC9FF.1090100@igel.co.jp>
Date: Thu, 30 Aug 2012 11:03:43 +0900
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Simon Horman <horms@verge.net.au>
CC: Hideki EIRAKU <hdk@igel.co.jp>, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Katsuya MATSUBARA <matsu@igel.co.jp>
Subject: Re: [PATCH 0/2] Renesas IPMMU driver for sh7372
References: <1343197742-13630-1-git-send-email-hdk@igel.co.jp> <20120825071344.GI29755@verge.net.au>
In-Reply-To: <20120825071344.GI29755@verge.net.au>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

On 2012/08/25 16:13, Simon Horman wrote:
> On Wed, Jul 25, 2012 at 03:29:00PM +0900, Hideki EIRAKU wrote:
>> This is the Renesas IPMMU driver, IOMMU API implementation and IPMMU
>> device support for sh7372 (AP4EVB and Mackerel).
>>
>> The IPMMU module supports the MMU function and the PMB function.  The
>> MMU function provides address translation by pagetable compatible with
>> ARMv6.  The PMB function provides address translation including
>> tile-linear translation.  This is implementation of the MMU function.
> 
> Hi,
> 
> I am wondering if anyone has had a chance to review this short series.
> It seems reasonable to me with the minor exception that I would
> be happier the second patch to update the relevant defconfigs
> to either enable or disable the driver.
> 
> I am also curious to know how this driver may be tested.

Since this patch series configures the LCDC, and CEU to use the IPMMU,
checking the memory addresses that those blocks are using are properly
registered in the IPMMU, and verifying that they actually function seems
like the best way to test this driver. I'll take a look at doing that.

That said, there currently isn't any way to use this with UIO devices,
since enabling the IPMMU with break direct accesses to physical memory
from all of the IP blocks on the ICB (LCDC, CEU, VPU, VEU, etc.)
For these devices, memory allocated with the dma-mapping API *must* be
used with IPMMU enabled.  The current uio_pdrv_genirq driver isn't set
up to deal with this right now.

Damian
