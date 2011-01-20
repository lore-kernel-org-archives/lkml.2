Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753675Ab1ATSoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 13:44:07 -0500
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:48403 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab1ATSoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 13:44:05 -0500
Message-ID: <4D388271.50404@linux.vnet.ibm.com>
Date: Thu, 20 Jan 2011 16:44:01 -0200
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>
CC: linux-kernel@vger.kernel.org, Debora Velarde <debora@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net, James Morris <jmorris@namei.org>,
        Matthew Garrett <mjg@redhat.com>
Subject: Re: [PATCH] tpm: fix panic caused by "tpm: Autodetect itpm devices"
References: <1294370641-6791-1-git-send-email-olof@lixom.net> <AANLkTi=E1_Ur6GmwBRnjGRBpmSup4_1_k35ZKvBRcFtv@mail.gmail.com>
In-Reply-To: <AANLkTi=E1_Ur6GmwBRnjGRBpmSup4_1_k35ZKvBRcFtv@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2011 03:37 PM, Olof Johansson wrote:
> Are all TPM maintainers MIA? This is a trivial patch that fixes a
> panic, and it was a late-added regression in 2.6.37.
>
Not myself. I missed this one unfortunately in my work queue, sorry, 
will keep alert to avoid this happening again.

Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
> -Olof
>
> On Thu, Jan 6, 2011 at 7:24 PM, Olof Johansson<olof@lixom.net>  wrote:
>> commit 3f0d3d016d89a5efb8b926d4707eb21fa13f3d27 adds a check for
>> PNP device id to the common tpm_tis_init() function, which in some
>> cases (force=1) will be called without the device being a member of
>> a pnp_dev. Oopsing and panics ensue.
>>
>> Move the test up to before the call to tpm_tis_init(), since it
>> just modifies a global variable anyway.
>>
>> Signed-off-by: Olof Johansson<olof@lixom.net>
>> Cc: Matthew Garrett<mjg@redhat.com>
>> Cc: stable@kernel.org [2.6.37+]
>> ---
>>   drivers/char/tpm/tpm_tis.c |    6 +++---
>>   1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
>> index c17a305..dd21df5 100644
>> --- a/drivers/char/tpm/tpm_tis.c
>> +++ b/drivers/char/tpm/tpm_tis.c
>> @@ -493,9 +493,6 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
>>                  "1.2 TPM (device-id 0x%X, rev-id %d)\n",
>>                  vendor>>  16, ioread8(chip->vendor.iobase + TPM_RID(0)));
>>
>> -       if (is_itpm(to_pnp_dev(dev)))
>> -               itpm = 1;
>> -
>>         if (itpm)
>>                 dev_info(dev, "Intel iTPM workaround enabled\n");
>>
>> @@ -637,6 +634,9 @@ static int __devinit tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
>>         else
>>                 interrupts = 0;
>>
>> +       if (is_itpm(pnp_dev))
>> +               itpm = 1;
>> +
>>         return tpm_tis_init(&pnp_dev->dev, start, len, irq);
>>   }
>>
>> --
>> 1.7.3.GIT
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>

