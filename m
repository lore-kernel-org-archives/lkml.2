Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753095Ab1KOEb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 23:31:57 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57749 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab1KOEb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 23:31:56 -0500
Message-ID: <4EC1EB39.1080705@gmail.com>
Date: Mon, 14 Nov 2011 22:31:53 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
To: Arnd Hannemann <arnd@arndnet.de>
CC: linux-kernel@vger.kernel.org, dwmw2@infradead.org,
        iommu@lists.linux-foundation.org
Subject: Re: 3.2rc1: bootup fails: DRHD: handling fault status reg 2
References: <4EC19738.8050007@arndnet.de> <4EC1B80D.5000102@arndnet.de>
In-Reply-To: <4EC1B80D.5000102@arndnet.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2011 06:53 PM, Arnd Hannemann wrote:
> Hi,
>
> Am 14.11.2011 23:33, schrieb Arnd Hannemann:
>
>> when trying to boot kernel 3.2rc1 on my thinkpad t510 I get an endless loop of errors:
>>
>>   DRHD: handling fault status reg 2
>>   DMAR: [DMA Read] Request device [0d:00.0] fault addr fffff000
>>   DMAR: [fault reason 02] Present bit in context entry is clear
>>
>> screenshot can be found here:
>> http://arndnet.de/lkml/screenshot3.2rc1.jpg
>>
>> kernel 3.1.1 is booting up flawlessly.
>
> I must have inadvertently enabled CONFIG_INTEL_IOMMU_DEFAULT_ON in my config
> for 3.2-rc1.
>
> With disabled CONFIG_INTEL_IOMMU_DEFAULT_ON my thinkpad boots up again.
> Not sure if this is expected?

No, that's not supposed to happen. Can you post the output of "lspci 
-vv"? Apparently that device 0d:00.0 is generating unexpected DMA 
accesses for some reason.
