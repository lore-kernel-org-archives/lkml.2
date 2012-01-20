Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752504Ab2ATMaP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 07:30:15 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:1144 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab2ATMaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 07:30:11 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6594"; a="156595403"
Message-ID: <4F195E4C.6080805@codeaurora.org>
Date: Fri, 20 Jan 2012 18:00:04 +0530
From: Ravi Kumar V <kumarrav@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: dan.j.williams@intel.com, arnd@arndb.de, linux-arch@vger.kernel.org,
        davidb@codeaurora.org, dwalker@fifo99.com, bryanh@codeaurora.org,
        linux@arm.linux.org.uk, tsoni@qualcomm.com, johlstei@qualcomm.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 0/2] Add Qualcomm MSM ADM DMAEngine driver
References: <1325854052-21402-1-git-send-email-kumarrav@codeaurora.org> <1326807902.1540.116.camel@vkoul-udesk3>
In-Reply-To: <1326807902.1540.116.camel@vkoul-udesk3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/17/2012 7:15 PM, Vinod Koul wrote:
> On Fri, 2012-01-06 at 18:17 +0530, Ravi Kumar V wrote:
> <sorry for delayed review, was on vacation and now traveling>
>>
>> As our ADM Scatter-gather hardware needs
>> -32-bit command configuration parameter
>>   apart from
>> -32-bit source address
>> -32-bit destination address
>> -16-bit length
>>
>> So,we have added new parameter in struct scatterlist to support xfer
>> descriptor
>> specific private data, and for supporting ADM Box mode DMA we added
>> new
>> API and data structure.
> what do you mean by "ADM Box mode"?
>

ADM Box mode is a interleaved type of DMA where data from rows of equal 
length and equal distance(bytes) between each other are transferred to 
similar pattern of rows.
Each row length and distance between each row in destination pattern may 
not be equal to source pattern.
Distance between beginning of any two rows are always greater than row 
length.
Example:
If 4 rows of 16 bytes each are arranged such that distance between 
beginning of any two rows are 32 bytes.
Now they can be transferred using BOX mode to destination pattern 
arranged in 2 rows of 32 bytes each and distance between them can be any 
lets say 128 bytes.

Source pattern:
4 data rows starts address 0th byte.

0-----16-bytes-data-----15
16    16 bytes void     31
32---------data---------47
48         void         63
64---------data---------79
80         void         95
96---------data--------111

Transferred to destination
Destination pattern:
2 rows
0----------32-bytes-data----------31
32         96 bytes void         127
128-------------data-------------159

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
