Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239Ab1KKVGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 16:06:42 -0500
Received: from casper.infradead.org ([85.118.1.10]:40673 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775Ab1KKVGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 16:06:41 -0500
Message-ID: <4EBD8E5F.1010200@kernel.dk>
Date: Fri, 11 Nov 2011 22:06:39 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Mike Miller <mike.miller@hp.com>
CC: Matthew Garrett <mjg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ISS StorageDev <iss_storagedev@hp.com>
Subject: Re: [PATCH V2 4/6] block/cciss: Disable ASPM
References: <1321028064-644-1-git-send-email-mjg@redhat.com> <1321028064-644-5-git-send-email-mjg@redhat.com> <4EBD4A31.2070609@hp.com>
In-Reply-To: <4EBD4A31.2070609@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-11 17:15, Mike Miller wrote:
> On 11/11/2011 10:14 AM, Matthew Garrett wrote:
>> The Windows driver .inf disables ASPM on all cciss devices. Do the same.
>>
>> Signed-off-by: Matthew Garrett<mjg@redhat.com>
>> Cc: mike.miller@hp.com
>> Cc: iss_storagedev@hp.com
>> Cc: axboe@kernel.dk
>> ---
>>   drivers/block/cciss.c |    5 +++++
>>   1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
>> index 486f94e..92d8a2f 100644
>> --- a/drivers/block/cciss.c
>> +++ b/drivers/block/cciss.c
>> @@ -24,6 +24,7 @@
>>   #include<linux/interrupt.h>
>>   #include<linux/types.h>
>>   #include<linux/pci.h>
>> +#include<linux/pci-aspm.h>
>>   #include<linux/kernel.h>
>>   #include<linux/slab.h>
>>   #include<linux/delay.h>
>> @@ -4319,6 +4320,10 @@ static int __devinit cciss_pci_init(ctlr_info_t *h)
>>           dev_warn(&h->pdev->dev, "controller appears to be disabled\n");
>>           return -ENODEV;
>>       }
>> +
>> +    pci_disable_link_state(h->pdev, PCIE_LINK_STATE_L0S |
>> +                   PCIE_LINK_STATE_L1 | PCIE_LINK_STATE_CLKPM);
>> +
>>       err = pci_enable_device(h->pdev);
>>       if (err) {
>>           dev_warn(&h->pdev->dev, "Unable to Enable PCI device\n");
> 
> Acked-by: Mike Miller <mike.miller@hp.com>

Applied for 3.2, thanks.

-- 
Jens Axboe

