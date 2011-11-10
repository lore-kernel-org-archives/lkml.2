Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626Ab1KJMRQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 07:17:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53468 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab1KJMRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 07:17:14 -0500
Message-ID: <4EBBC090.4070109@gmail.com>
Date: Thu, 10 Nov 2011 20:16:16 +0800
From: cody <mail.kai.huang@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20110704 Icedove/3.0.11
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: iommu@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-arm-kernel@lists.infradead.org,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org, Hiroshi Doyu <hdoyu@nvidia.com>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        KyongHo Cho <pullip.cho@samsung.com>, kvm@vger.kernel.org
Subject: Re: [PATCH v4 2/7] iommu/core: split mapping to page sizes as supported
 by the hardware
References: <1318850846-16066-1-git-send-email-ohad@wizery.com> <1318850846-16066-3-git-send-email-ohad@wizery.com> <CANqQZNH1YRSgYRVxceicQ3szD=t7zeJjhJKEQ30PeKsxtj5V+A@mail.gmail.com> <CAK=WgbZbfCRJqA-wwHN=iLH6rYyoKjJCaL0zMfY93Tg6Jw2uvA@mail.gmail.com>
In-Reply-To: <CAK=WgbZbfCRJqA-wwHN=iLH6rYyoKjJCaL0zMfY93Tg6Jw2uvA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2011 03:31 PM, Ohad Ben-Cohen wrote:
> On Thu, Nov 10, 2011 at 8:17 AM, Kai Huang<mail.kai.huang@gmail.com>  wrote:
>    
>> Seems the unmap function don't take phys as parameter, does this mean
>> domain->ops->unmap will walk through the page table to find out the
>> actual page size?
>>      
> The short answer is yes, and furthermore, we also consider to remove
> the size param from domain->ops->unmap entirely at some point.
>
> We had a long discussion about it, please see:
>
> https://lkml.org/lkml/2011/10/10/234
>    
Yes I've seen your discussion, I followed this thread from beginning:)

How about the IOTLB flush? As I said I think we need to consider that 
IOMMU (even does not exist now) may have some limitation on IOTLB flush, 
and hiding page size from IOTLB flush code may hurt performance, or even 
worse, trigger undefined behaviors.

-cody
