Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933330Ab1JNQwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:52:53 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42241 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab1JNQwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:52:53 -0400
Message-ID: <4E98688D.3070505@mvista.com>
Date: Fri, 14 Oct 2011 20:51:25 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] ata_piix: unify code for programming PIO and MWDMA
 timings
References: <201110131539.11190.bzolnier@gmail.com> <4E9824AC.6020902@mvista.com> <201110141543.27060.bzolnier@gmail.com> <4E9866A4.80302@mvista.com>
In-Reply-To: <4E9866A4.80302@mvista.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10/14/2011 08:43 PM, Sergei Shtylyov wrote:

>>>> From: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>
>>>> Subject: [PATCH v2] ata_piix: unify code for programming PIO and MWDMA timings

>>>> Besides making things noticably simpler it results in ~2% decrease in
>>>> the driver LOC count and also ~2% decrease in the driver binary size
>>>> (as measured on x86-32).

>>>> Fix piix_set_piomode() documentation while at it.

>>>> Signed-off-by: Bartlomiej Zolnierkiewicz<bzolnier@gmail.com>

>>> I'm still inclined to NAK this patch.

>>>> ---
>>>> v2: remove use_mwdma variable and fix comment style

>>>> earlier references:
>>>> https://lkml.org/lkml/2011/2/8/99

>>>> drivers/ata/ata_piix.c | 111 ++++++++++++++++---------------------------------
>>>> 1 file changed, 38 insertions(+), 73 deletions(-)

>>>> Index: b/drivers/ata/ata_piix.c
>>>> ===================================================================
>>>> --- a/drivers/ata/ata_piix.c
>>>> +++ b/drivers/ata/ata_piix.c
[...]

>> We still have following code at the end of piix_set_timings():

>> /* Ensure the UDMA bit is off - it will be turned back on if
>> UDMA is selected */
>>
>> if (ap->udma_mask) {
>> pci_read_config_byte(dev, 0x48,&udma_enable);
>> udma_enable&= ~(1<< (2 * ap->port_no + adev->devno));
>> pci_write_config_byte(dev, 0x48, udma_enable);
>> }

>> so everything should be OK.

> Ah, I should have looked... Didn't expect it to be there, and it in fact
> shouldn't be there, but now I'm OK with your patch. :-)

    But I would have preferred the above code to be removed, of course.

WBR, Sergei
