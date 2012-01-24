Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab2AXTO2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 14:14:28 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17841 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab2AXTO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 14:14:27 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6599"; a="155260219"
Message-ID: <4F1F0313.7040008@codeaurora.org>
Date: Tue, 24 Jan 2012 11:14:27 -0800
From: Stepan Moskovchenko <stepanm@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>, David Brown <davidb@codeaurora.org>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: OMAP and MSM IOMMU driver misbehavior
References: <20120123140355.GA19255@amd.com>
In-Reply-To: <20120123140355.GA19255@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/2012 6:03 AM, Joerg Roedel wrote:
> Hi,
>
> while reviewing another IOMMU driver again I came across a problem in
> the IOMMU drivers for OMAP and MSM platforms. In both drivers the
> 'domain_destroy with devices attached' case isn't handled correctly.
>
> OMAP driver seems not to track the devices attached to a domain at all.
> So when a domain is destroyed it can happen that the hardware still
> references old (and already freed) page-table pointers.
>
> MSM tracks devices in a domain, but does not automatically remove the
> devices from a domain that is about to be destroyed.
>
> Please tell me when I mis-read the code, otherwise please fix this in
> your drivers so that we can get consistent behavior for IOMMU-API
> users :-)
>
> Thanks,
>
> 	Joerg

Hello

I believe your analysis is correct, and it is a legitimate problem. The 
driver does keep a list of devices attached to a domain, so it should 
not be too hard to detach them. However, I have been quite occupied with 
other things lately, but I can try to get to it when I have some free 
time. Calling detach_dev on each element is what needs to happen in 
theory, but I feel like the main detach_dev code will need to be broken 
out to handle the locking properly. Still, it does not sound 
particularly difficult.

Steve

