Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab2JEJgg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 05:36:36 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57005 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754918Ab2JEJge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 05:36:34 -0400
MIME-Version: 1.0
In-Reply-To: <506EA54F.1020807@mev.co.uk>
References: <1349395666-6010-1-git-send-email-yamanetoshi@gmail.com>
	<506EA54F.1020807@mev.co.uk>
Date: Fri, 5 Oct 2012 18:36:33 +0900
Message-ID: <CAOTypNTOuT-6M0X5yjpogQv9+1ArYesAnOknPyOEeKMtpReDbA@mail.gmail.com>
Subject: Re: [PATCH] staging/comedi: Use dev_ printks in drivers/adl_pci8164.c
From: Toshiaki Yamane <yamanetoshi@gmail.com>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Ian Abbott <ian.abbott@mev.co.uk>,
        Frank Mori Hess <fmhess@users.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 5, 2012 at 6:15 PM, Ian Abbott <abbotti@mev.co.uk> wrote:
> On 2012-10-05 01:07, YAMANE Toshiaki wrote:
>>
>> fixed below checkpatch warning.
>> - WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then
>> pr_err(...  to printk(KERN_ERR ...
>>
>> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
>> ---
>>   drivers/staging/comedi/drivers/adl_pci8164.c |   12 ++++++------
>>   1 file changed, 6 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/staging/comedi/drivers/adl_pci8164.c
>> b/drivers/staging/comedi/drivers/adl_pci8164.c
>> index 05e06e7..6dbe465 100644
>> --- a/drivers/staging/comedi/drivers/adl_pci8164.c
>> +++ b/drivers/staging/comedi/drivers/adl_pci8164.c
>> @@ -89,9 +89,9 @@ static void adl_pci8164_insn_read(struct comedi_device
>> *dev,
>>         }
>>
>>         data[0] = inw(dev->iobase + axis_reg + offset);
>> -       printk(KERN_DEBUG "comedi: pci8164 %s read -> "
>> -                                                 "%04X:%04X on axis
>> %s\n",
>> -                               action, data[0], data[1], axisname);
>> +       dev_dbg(dev->class_dev,
>> +                 "comedi: pci8164 %s read -> %04X:%04X on axis %s\n",
>> +                 action, data[0], data[1], axisname);
>>   }
>
>
> The "comedi: " prefix is superfluous, so should be removed.  The dev_dbg()
> call will emit the word "comedi" twice already without the extra prefix.
>
>
>>
>>   static int adl_pci8164_insn_read_msts(struct comedi_device *dev,
>> @@ -170,9 +170,9 @@ static void adl_pci8164_insn_out(struct comedi_device
>> *dev,
>>
>>         outw(data[0], dev->iobase + axis_reg + offset);
>>
>> -       printk(KERN_DEBUG "comedi: pci8164 %s write -> "
>> -                                               "%04X:%04X on axis %s\n",
>> -                               action, data[0], data[1], axisname);
>> +       dev_dbg(dev->class_dev,
>> +                 "comedi: pci8164 %s write -> %04X:%04X on axis %s\n",
>> +                 action, data[0], data[1], axisname);
>>
>>   }
>
>
> Same here.

Ian-san,

Thank you for pointing out my mistakes.
I will try to fix it.

-- 

Regards,

YAMANE Toshiaki
