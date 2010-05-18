Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab0ERXrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 19:47:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565Ab0ERXrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 19:47:31 -0400
Message-ID: <4BF3270D.7050503@redhat.com>
Date: Tue, 18 May 2010 20:47:25 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Vernon Mauery <vernux@us.ibm.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add support for Westmere to i7core_edac driver
References: <20100518184653.GA6511@lucy> <4BF2E3BE.4020101@redhat.com> <20100518201838.GB6511@lucy>
In-Reply-To: <20100518201838.GB6511@lucy>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vernon Mauery wrote:
> On 18-May-2010 04:00 PM, Mauro Carvalho Chehab wrote:
>> Vernon Mauery wrote:
>>> Add support for Westmere to i7core_edac driver
>>>
>>> This adds new PCI IDs for the Westmere's memory controller
>>> devices and modifies the i7core_edac driver to be able to
>>> probe both Nehalem and Westmere processors.
>>>
>>> This applies to
>>> git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/i7core.git
>>> linux_next
>>>
>>> Signed-off-by: Vernon Mauery <vernux@us.ibm.com>
>>>
>>> @@ -1170,7 +1213,7 @@ static void i7core_put_all_devices(void)
>>>           i7core_put_devices(i7core_dev);
>>>   }
>>>
>>> -static void __init i7core_xeon_pci_fixup(int dev_id)
>>> +static void i7core_xeon_pci_fixup(struct pci_id_table *table)
>>>   {
>>>       struct pci_dev *pdev = NULL;
>>>       int i;
>>
>>
>> Hmm... this hunk seems wrong to me. It ir just reverting this patch:
>>
>> http://git.kernel.org/?p=linux/kernel/git/mchehab/i7core.git;a=commit;h=71753e0141a220ecbf9c71a66e0a8acce9705fb5
>>
>>
>> The other changes seem OK on my eyes.
> 
> Oops.  It looks like my merge was not quite correct.  It was not
> intended to revert that patch, but rather change the parameters to the
> function to use a struct pci_id_table instead of an int dev_id.
> 
> Here is a correct patch.

Thanks for the fix. Applied at the tree.

Cheers,
Mauro
