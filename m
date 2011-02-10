Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab1BJR5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 12:57:23 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33988 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1BJR5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 12:57:22 -0500
Message-ID: <4D5426A9.60903@mvista.com>
Date: Thu, 10 Feb 2011 20:55:53 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/20] pata_efar: always program master_data before slave_data
References: <20110208122314.19110.4092.sendpatchset@linux-mhg7.site>	<20110208122409.19110.4233.sendpatchset@linux-mhg7.site>	<4D53F4ED.10903@ru.mvista.com> <AANLkTinPYo+mhiRwsNpdNgqADQbk7bvQX=RcZoiN0pbS@mail.gmail.com>
In-Reply-To: <AANLkTinPYo+mhiRwsNpdNgqADQbk7bvQX=RcZoiN0pbS@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

>> On 08-02-2011 15:24, Bartlomiej Zolnierkiewicz wrote:
>> [...]

>>> We may need to set SITRE before programming slave_data.
>>> This makes pata_efar match the behavior of IDE's slc90e66 host driver
>>> and also of libata's ata_piix one.

>>> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
>> [...]

>>> diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
>>> index 1e2ff7d..7f564d7 100644
>>> --- a/drivers/ata/pata_efar.c
>>> +++ b/drivers/ata/pata_efar.c
>>> @@ -74,10 +74,12 @@ static void efar_set_timings(struct ata_port *ap,
>>> struct ata_device *adev,
>>>                             u8 pio, bool use_mwdma)
>>>  {
>>>        struct pci_dev *dev     = to_pci_dev(ap->host->dev);
>>> +       unsigned int is_slave   = (adev->devno != 0);

>>   What's the point of this variable? To save one pointer dereference? :-)

> Make code more similar to ata_piix.c and thus easier for comparisons
> through 'diff -ub'.

> In reality it doesn't matter now that much as pata_efar (same for
> pata_oldpiix) vanishes completely at the end of the patch series.. :-)

    Yeah, I understood that. Just don't have time to review the full series yet.

> Thanks,
> Bartlomiej

WBR, Sergei
