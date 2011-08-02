Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab1HBQRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 12:17:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:51295 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753394Ab1HBQRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 12:17:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,307,1309762800"; 
   d="scan'208";a="33413017"
Message-ID: <4E382329.8080307@linux.intel.com>
Date: Tue, 02 Aug 2011 09:17:45 -0700
From: J Freyensee <james_p_freyensee@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110628 Thunderbird/5.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
        akpm <akpm@linux-foundation.org>,
        torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] pti: add missing CONFIG_PCI dependency
References: <20110802080834.GA9847@osiris.boeblingen.de.ibm.com> <20110802081129.b84a7bc7.rdunlap@xenotime.net>
In-Reply-To: <20110802081129.b84a7bc7.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2011 08:11 AM, Randy Dunlap wrote:
> On Tue, 2 Aug 2011 10:08:34 +0200 Heiko Carstens wrote:
>
>> From: Heiko Carstens<heiko.carstens@de.ibm.com>
>>
>> allmodconfig compile fails on s390 because of the new PTI driver:
>>
>> drivers/misc/pti.c:407:3: error: implicit declaration of function 'pci_iounmap'
>> drivers/misc/pti.c:410:3: error: implicit declaration of function 'pci_release_region'
>>
>> Add a 'depends on PCI' statement so it doesn't get compiled.
>>
>> Cc: J Freyensee<james_p_freyensee@linux.intel.com>
>

Greg, did you see the patch go your way?

http://marc.info/?l=linux-kernel&m=131007615706260&w=2

Should I res-submit this patch to you through the linux-next mailing list?

Thanks Greg,

J

> James has already acked my identical patch.
> The problem seems to be that we don't have a drivers/misc/ maintainter to
> merge the patch.
>
> Anyway:
> Acked-by: Randy Dunlap<rdunlap@xenotime.net>
>
>
>> Signed-off-by: Heiko Carstens<heiko.carstens@de.ibm.com>
>> ---
>>   drivers/misc/Kconfig |    1 +
>>   1 file changed, 1 insertion(+)
>>
>> --- a/drivers/misc/Kconfig
>> +++ b/drivers/misc/Kconfig
>> @@ -146,6 +146,7 @@ config PHANTOM
>>
>>   config INTEL_MID_PTI
>>   	tristate "Parallel Trace Interface for MIPI P1149.7 cJTAG standard"
>> +	depends on PCI
>>   	default n
>>   	help
>>   	  The PTI (Parallel Trace Interface) driver directs
>> --
>
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***


-- 
J (James/Jay) Freyensee
Storage Technology Group
Intel Corporation
