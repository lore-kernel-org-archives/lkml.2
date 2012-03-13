Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab2CMMqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 08:46:50 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:57883 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284Ab2CMMqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 08:46:48 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6647"; a="169681679"
Message-ID: <4F5F41AF.1090907@codeaurora.org>
Date: Tue, 13 Mar 2012 18:16:39 +0530
From: Ravi Kumar V <kumarrav@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Daniel Walker <dwalker@fifo99.com>
CC: Russell King <linux@arm.linux.org.uk>, Vinod Koul <vinod.koul@intel.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bryan Huntsman <bryanh@codeaurora.org>, gregkh@linuxfoundation.org,
        Dan Williams <dan.j.williams@intel.com>,
        David Brown <davidb@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 2/2] DMAEngine: Add DMAEngine driver based on old MSM
 DMA APIs
References: <1331548364-27845-1-git-send-email-kumarrav@codeaurora.org> <20120312201421.GA3459@fifo99.com>
In-Reply-To: <20120312201421.GA3459@fifo99.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/2012 1:44 AM, Daniel Walker wrote:
> On Mon, Mar 12, 2012 at 04:02:44PM +0530, Ravi Kumar V wrote:
>> Add DMAEngine based driver using the old MSM DMA APIs internally.
>
> What do you mean by this?
>
There is a MSM DMA driver in arch/arm/mach-msm/ which is not in
dmaengine framework standards, but that driver is been used by client 
drivers nand, eMMC and serial drivers. Now if we implement the whole dma 
driver using dmaengine framework then nand, eMMC like drivers will be 
failed as they are using old dma driver API's, so instead of 
implementing new driver from scratch we are keeping the old dma API's as 
it is and using those API's in new dmaengine framework.So that we can 
convert clients drivers to use dma engine framework.

>> The benefit of this approach is that not all the drivers
>> have to get converted to DMAEngine APIs simultaneosly while
>> both the drivers can stay enabled in the kernel. The client
>> drivers using the old MSM APIs directly can now convert to
>> DMAEngine one by one.
>
> Which drivers?

client drivers which are using dma.
>
> Daniel
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel


-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
