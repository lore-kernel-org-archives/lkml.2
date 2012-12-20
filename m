Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab2LTV4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 16:56:47 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:38607 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751567Ab2LTV4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 16:56:40 -0500
MIME-Version: 1.0
In-Reply-To: <50D384AF.40002@intel.com>
References: <1355881933-15182-1-git-send-email-david.a.cohen@intel.com>
 <1355881933-15182-2-git-send-email-david.a.cohen@intel.com>
 <20121220011812.98B003E0AD7@localhost> <50D384AF.40002@intel.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 20 Dec 2012 21:56:17 +0000
X-Google-Sender-Auth: o3_gXgriL0RKdiZwjTFCCO92I5M
Message-ID: <CACxGe6veF7tn=eOcmV2BVyvmUhjXqsJDigpZumT2q7fK5ozc3Q@mail.gmail.com>
Subject: Re: [PATCH 1/3] gpio-langwell: cleanup driver
To: David Cohen <david.a.cohen@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 20, 2012 at 9:35 PM, David Cohen <david.a.cohen@intel.com> wrote:
> On 12/19/2012 05:18 PM, Grant Likely wrote:
>> On Tue, 18 Dec 2012 17:52:11 -0800, David Cohen <david.a.cohen@intel.com>
>>>   @@ -215,19 +217,14 @@ static int lnw_irq_type(struct irq_data *d,
>>> unsigned type)
>>>         return 0;
>>>   }
>>>   -static void lnw_irq_unmask(struct irq_data *d)
>>> -{
>>> -}
>>> -
>>> -static void lnw_irq_mask(struct irq_data *d)
>>> -{
>>> -}
>>> +static void lnw_irq_noop(struct irq_data *d) {}
>>
>> Umm, this looks entirely wrong. There needs to be either mask/unmask or
>> enable/disable ops for irq_chips. Yes I see that this patch is just
>> consolidating two empty functions, but they are two empty functions that
>> appear to be completely wrong.
>
>
> I see your point. The solution does not belong to a clean up patch,
> so I'll just remove it from here.

Right, that is appropriate.

>>>     static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
>>> @@ -349,7 +327,7 @@ static int __devinit lnw_gpio_probe(struct pci_dev
>>> *pdev,
>>>         retval = pci_request_regions(pdev, "langwell_gpio");
>>>         if (retval) {
>>>                 dev_err(&pdev->dev, "error requesting resources\n");
>>> -               goto err2;
>>> +               goto err;
>>
>> Renaming the labels just increases the noise in the diff. I prefer to
>> see labels in the form "err-what-i-just-tried-to-do:" so they don't need
>> to get reshuffled every time the code logic changes.
>>
>> There is no good reason for this change. Please drop it.
>
>
> Maybe instead of drop it I'd prefer to fix the labels. They
> are wrong currently.

If there is real breakage here, then split it off into a separate bug
fix patch. Otherwise I really wouldn't bother.

g.
