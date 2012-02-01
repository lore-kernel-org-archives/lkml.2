Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2BAJJL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 04:09:11 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41278 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab2BAJJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 04:09:05 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6606"; a="157261449"
Message-ID: <4F29012B.50202@codeaurora.org>
Date: Wed, 01 Feb 2012 14:38:59 +0530
From: Ravi Kumar V <kumarrav@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: linux-arm-kernel@lists.infradead.org, davidb@codeaurora.org,
        dan.j.williams@intel.com, Daniel Walker <dwalker@fifo99.com>,
        johlstei@codeaurora.org, bryanh@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        arnd@arndb.de, tsoni@codeaurora.org, linux@arm.linux.org.uk
Subject: Re: [PATCH v2 0/2] Add Qualcomm MSM ADM DMAEngine driver
References: <1325854052-21402-1-git-send-email-kumarrav@codeaurora.org> <1326807902.1540.116.camel@vkoul-udesk3> <4F195E4C.6080805@codeaurora.org> <1327066287.517.4.camel@vkoul-udesk3> <4F1D4052.3070701@codeaurora.org> <1327326713.517.32.camel@vkoul-udesk3> <4F1FFF7E.3000802@codeaurora.org> <1327911315.1527.8.camel@vkoul-udesk3> <4F278341.4020600@codeaurora.org> <1327990151.1527.80.camel@vkoul-udesk3> <4F28D8A2.9050605@codeaurora.org> <1328084998.1610.11.camel@vkoul-udesk3>  <4F28F9D5.6020801@codeaurora.org> <1328086017.1610.13.camel@vkoul-udesk3>
In-Reply-To: <1328086017.1610.13.camel@vkoul-udesk3>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/1/2012 2:16 PM, Vinod Koul wrote:
> On Wed, 2012-02-01 at 14:07 +0530, Ravi Kumar V wrote:
>> Our hardware supports single transfer mode,scatter gather mode&  box
>> mode.
>>
>> we are using these dmaengine API's for our HW
>> device_prep_memcpy() for single mode.
>> device_prep_dma_sg() for sg mode.
>> device_prep_interleaved_dma() for box mode.
>>
>> We need to pass command configuration parameter to all of the above
>> three modes and it can be possible if extra context parameter is added
>> into these API's
> but again, is this static fr channel for each transfer. Would you be
> able to derive these for non box modes?
>

Command configuration parameter has this information which is used be our HW
1.Device Id for Synchronization & acknowledgment with slow clock devices.
2.Endian type.
3.Blocking/unblocking channel after/before transfer.

Command configuration parameter should be passed in all the three modes 
and per transfer so this parameter is dynamic keep changing for each 
transfer.

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
