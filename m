Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758787Ab0FPG4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 02:56:34 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37858 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758761Ab0FPG4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 02:56:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=G2N1TQixbbNbutRotqHPO5SEXy2y+n2UYjN1B6ZAwopRsJuZZxXR4InTqAgJbWWSsg
         F5KdxRL6L+YbsOBEWpqAMLn982bsRLbV2lvJPuQaTYwojp7mj972dhMRbaDMblHHxYi0
         WcBRBt+BuXNKxRsnRqxCfQnGfqYugC3kNcQdQ=
Message-ID: <4C1875B0.1050007@gmail.com>
Date: Tue, 15 Jun 2010 23:56:48 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/5]pci:bus.c Fix variable 'retval' set but not used
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com> 	<1276666434-11227-4-git-send-email-justinmattock@gmail.com> <AANLkTik27fbCY0pMJdcbuCaEXr-902WiqiFPkju4Bet0@mail.gmail.com>
In-Reply-To: <AANLkTik27fbCY0pMJdcbuCaEXr-902WiqiFPkju4Bet0@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/15/2010 10:42 PM, Julian Calaby wrote:
> On Wed, Jun 16, 2010 at 15:33, Justin P. Mattock
> <justinmattock@gmail.com>  wrote:
>> The patch below fixes the warning message I am seeing with gcc 4.6.0
>>   CC      drivers/pci/bus.o
>> drivers/pci/bus.c: In function 'pci_enable_bridges':
>> drivers/pci/bus.c:237:6: warning: variable 'retval' set but not used
>>
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>
>> ---
>>   drivers/pci/bus.c |    2 --
>>   1 files changed, 0 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/pci/bus.c b/drivers/pci/bus.c
>> index 628ea20..84bdb48 100644
>> --- a/drivers/pci/bus.c
>> +++ b/drivers/pci/bus.c
>> @@ -234,12 +234,10 @@ void pci_bus_add_devices(const struct pci_bus *bus)
>>   void pci_enable_bridges(struct pci_bus *bus)
>>   {
>>         struct pci_dev *dev;
>> -       int retval;
>>
>>         list_for_each_entry(dev,&bus->devices, bus_list) {
>>                 if (dev->subordinate) {
>>                         if (!pci_is_enabled(dev)) {
>> -                               retval = pci_enable_device(dev);
>>                                 pci_set_master(dev);
>>                         }
>>                         pci_enable_bridges(dev->subordinate);
>
> Er, this appears to be bogus: I'm only guessing, but I'd expect that
> the pci_enable_device() call is actually doing something useful, and
> removing it is going to break *something* - Have you booted a kernel
> with this code enabled and these patches applied?
>
> As for this warning, I think that there is a better solution.
>
> Thanks,
>

alright!!

Justin P. Mattock
