Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965085Ab1JFQKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 12:10:07 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44319 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935529Ab1JFQKF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 12:10:05 -0400
MIME-Version: 1.0
In-Reply-To: <201110052141.37618.rjw@sisk.pl>
References: <4E8C40A8.6080205@oracle.com>
	<201110052141.37618.rjw@sisk.pl>
Date: Thu, 6 Oct 2011 09:10:05 -0700
Message-ID: <CAE9FiQUjsa5CtpiqgMgHpt7av+v5NZFFOtuKC0a10Hwgwtm0Jg@mail.gmail.com>
Subject: Re: [PATCH] PCI: Set device power state to PCI_D0 for device without
 native PM support
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ajaykumar Hotchandani <ajaykumar.hotchandani@oracle.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 5, 2011 at 12:41 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> Hi,
>>   drivers/pci/pci.c |    3 +++
>>   1 files changed, 3 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
>> index e9651f0..ca8c82d 100644
>> --- a/drivers/pci/pci.c
>> +++ b/drivers/pci/pci.c
>> @@ -664,6 +664,9 @@ static int pci_platform_power_transition(struct pci_dev *dev, pci_power_t state)
>>                  error = platform_pci_set_power_state(dev, state);
>>                  if (!error)
>>                          pci_update_current_state(dev, state);
>> +               /* Fall back to PCI_D0 if native PM is not supported */
>> +               else if (!dev->pm_cap)
>> +                       dev->current_state = PCI_D0;
>>          } else {
>>                  error = -ENODEV;
>>                  /* Fall back to PCI_D0 if native PM is not supported */
>>
>
> I have some vague memories that we tried that and it broke something.

Do have any hint for us to dig out the configuration for failing?

>
> How thoroughly has it been tested?

tested in setups with intel cpus from Nehalem.

Yinghai
