Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab2HEOaL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 10:30:11 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:41574 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab2HEOaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 10:30:09 -0400
Message-ID: <501E8367.8070907@ti.com>
Date: Sun, 5 Aug 2012 10:29:59 -0400
From: Cyril Chemparathy <cyril@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>, <linux@arm.linux.org.uk>,
        <will.deacon@arm.com>, Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [PATCH 09/22] ARM: LPAE: use 64-bit pgd physical address in switch_mm()
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-10-git-send-email-cyril@ti.com> <alpine.LFD.2.02.1208040259200.5231@xanadu.home>
In-Reply-To: <alpine.LFD.2.02.1208040259200.5231@xanadu.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/4/2012 3:04 AM, Nicolas Pitre wrote:
> On Tue, 31 Jul 2012, Cyril Chemparathy wrote:
>
>> This patch modifies the switch_mm() processor functions to use 64-bit
>> addresses.  We use u64 instead of phys_addr_t, in order to avoid having config
>> dependent register usage when calling into switch_mm assembly code.
>>
>> The changes in this patch are primarily adjustments for registers used for
>> arguments to switch_mm.  The few processor definitions that did use the second
>> argument have been modified accordingly.
>>
>> Arguments and calling conventions aside, this patch should be a no-op on v6
>> and non-LPAE v7 processors.
>
> NAK.
>
> You just broke all big endian targets, LPAE or not.
>

Indeed.  Thanks.

Would C-land word swappery on BE do?  Any other ideas on the best 
approach to this?

>
> Nicolas
>

-- 
Thanks
- Cyril
