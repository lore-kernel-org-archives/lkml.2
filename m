Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760250Ab2COSMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 14:12:34 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35350 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab2COSMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 14:12:30 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6650"; a="170513534"
Message-ID: <4F623107.2040108@codeaurora.org>
Date: Thu, 15 Mar 2012 23:42:23 +0530
From: Ravi Kumar V <kumarrav@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: David Brown <davidb@codeaurora.org>, Russell King <linux@arm.linux.org.uk>,
        Vinod Koul <vinod.koul@intel.com>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bryan Huntsman <bryanh@codeaurora.org>,
        gregkh@linuxfoundation.org, Dan Williams <dan.j.williams@intel.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/2] DMAEngine: Add DMAEngine driver based on old MSM
 DMA APIs
References: <1331548364-27845-1-git-send-email-kumarrav@codeaurora.org> <20120312201421.GA3459@fifo99.com> <4F5F41AF.1090907@codeaurora.org> <20120314150533.GA8757@fifo99.com> <20120314201929.GA17259@codeaurora.org>
In-Reply-To: <20120314201929.GA17259@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/15/2012 1:49 AM, David Brown wrote:
> On Wed, Mar 14, 2012 at 08:05:53AM -0700, Daniel Walker wrote:
>> On Tue, Mar 13, 2012 at 06:16:39PM +0530, Ravi Kumar V wrote:
>>> On 3/13/2012 1:44 AM, Daniel Walker wrote:
>>>> On Mon, Mar 12, 2012 at 04:02:44PM +0530, Ravi Kumar V wrote:
>>>>> Add DMAEngine based driver using the old MSM DMA APIs internally.
>>>>
>>>> What do you mean by this?
>>>>
>>> There is a MSM DMA driver in arch/arm/mach-msm/ which is not in
>>> dmaengine framework standards, but that driver is been used by
>>> client drivers nand, eMMC and serial drivers. Now if we implement
>>> the whole dma driver using dmaengine framework then nand, eMMC like
>>> drivers will be failed as they are using old dma driver API's, so
>>> instead of implementing new driver from scratch we are keeping the
>>> old dma API's as it is and using those API's in new dmaengine
>>> framework.So that we can convert clients drivers to use dma engine
>>> framework.
>>
>> Did you investigate converting the drivers (nand, eMMC, serialied ) ? It
>> seems like there would be a 1:1 mapping between the API's , so it might
>> only be a find->replace operation.
>
> Only at a very superficial level--they both do DMA.  The ADM driver
> wants its scatterlists constructed manually by the caller (in DMA-able
> memory) and just the pointer handed over.  The drivers will have to be
> converted to use the abstracted scatterlists that dmaengine wants.
> Drivers like msm_sdcc are currently fairly intimitely tied to flow
> that is specific to ADM.  The msm_sdcc driver also needs use of the
> ADM's "box" mode, which has to be made to work with DMAEngine as well.
>
> Providing both APIs is really the only practical way to get this in
> without having to rewrite several other drivers.
>
> The nand driver (which doesn't seem to have made it in yet,
> https://lkml.org/lkml/2011/2/28/570) is much worse.  About half of the
> code is constructing ADM specific command blocks.  I'm not even sure
> it will be practical to even migrate that driver to DMAEngine, since
> the nand controller hardware is so intimately tied to the functioning
> of the ADM.
>
> David
>

Yes i have tried to convert these drivers, but mostly we need to add 
DMAEngine stuff like requesting channel, creating the descriptors, 
passing these descriptors to channel etc which are different from old 
implementation.So we have choose this path not to disturb the existing 
drivers while converting a driver.

Thanks
Ravi Kumar V
-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
