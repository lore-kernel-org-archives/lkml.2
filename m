Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184Ab2CaQWQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 12:22:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43229 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab2CaQWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 12:22:11 -0400
Message-ID: <4F772F2A.9020903@gmail.com>
Date: Sun, 01 Apr 2012 00:22:02 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jiang Liu <jiang.liu@huawei.com>, x86@kernel.org,
        Keping Chen <chenkeping@huawei.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 3/4] IRQ,x86: normalize return value of chip->irq_set_affinity()
 method
References: <1333120296-13563-1-git-send-email-jiang.liu@huawei.com> <1333120296-13563-4-git-send-email-jiang.liu@huawei.com> <alpine.LFD.2.02.1203302320060.2542@ionos>
In-Reply-To: <alpine.LFD.2.02.1203302320060.2542@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,
	Thanks for point this out. After checking related code again, I found
the method suggested by you will produce better code, so will send out another
version to remove the duplicated memory copy operations in arch specific code.
	When I was reading the comment for IRQ_SET_MASK_OK_NOCOPY, I thought
both way are ok to update the affinity mask by arch code or core logic, and
haven't realized the issue raised by you.
	Thanks!
	Gerry

On 03/31/2012 05:23 AM, Thomas Gleixner wrote:
> On Fri, 30 Mar 2012, Jiang Liu wrote:
> 
>> On x86 platforms, interrupt controller chip's irq_set_affinity() method
>> always copies affinity mask to irq_data->affinity field but still returns
> 
> Now the question here is whether it copies the mask because it
> modified the mask in some way and want to reflect the change back.
> 
> If it just copies the unmodified mask, then this patch is wrong. It
> should remove the copy from the arch code and return IRQ_SET_MASK_OK
> so the core code can take care of the copying.
> 
> Ditto for the ia64 one.
> 
> Thanks,
> 
> 	tglx

