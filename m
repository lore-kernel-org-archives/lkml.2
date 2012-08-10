Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab2HJMJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 08:09:21 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56223 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab2HJMJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 08:09:16 -0400
MIME-Version: 1.0
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00206AAE97175@AUSP01VMBX24.collaborationhost.net>
References: <1344525614-13910-1-git-send-email-gelurine@gmail.com> <ADE657CA350FB648AAC2C43247A983F00206AAE97175@AUSP01VMBX24.collaborationhost.net>
From: =?UTF-8?B?R8O8bmfDtnIgRXJzZXltZW4=?= <gelurine@gmail.com>
Date: Fri, 10 Aug 2012 15:08:54 +0300
Message-ID: <CA+yaK82jMjGYxnYBcp1f==Eu90xWh7y0myZXVbSDi9ArW=S=Tw@mail.gmail.com>
Subject: Re: [PATCH] Staging: comedi: ssv_snp: fix checkpatch.pl warnings
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 9, 2012 at 7:27 PM, H Hartley Sweeten
<hartleys@visionengravers.com> wrote:
> You have a typo in the subject for this patch.
> "ssv_snp" should be "ssv_dnp"
Hello Hartley,

I missed that typo. This is my first patch for linux kernel, i am a bit nervous.

>> diff --git a/drivers/staging/comedi/drivers/ssv_dnp.c b/drivers/staging/comedi/drivers/ssv_dnp.c
>> index 84b9f2a..4cd0f1b 100644
>> --- a/drivers/staging/comedi/drivers/ssv_dnp.c
>> +++ b/drivers/staging/comedi/drivers/ssv_dnp.c
>> @@ -177,7 +177,7 @@ static int dnp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>>       struct comedi_subdevice *s;
>>       int ret;
>>
>> -     printk(KERN_INFO "comedi%d: dnp: ", dev->minor);
>> +     pr_info("comedi%d: dnp: ", dev->minor);
>
> Where possible, fixes like this should use the dev_printk versions.
> For instance, this one would be:
>
>         dev_info(dev->class_dev, "dnp:");
>
> But, there is a cleaner fix for this file. See below.
>
>>       dev->board_name = board->name;
>>
>> @@ -195,7 +195,7 @@ static int dnp_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>>       s->insn_bits = dnp_dio_insn_bits;
>>       s->insn_config = dnp_dio_insn_config;
>>
>> -     printk("attached\n");
>> +     pr_info("attached\n");
>
> There are only two printk's in this file, both in the "attach" routine.
>
> The first one does not have a "\n" and the function could exit without
> ever terminating the message.
>
> A better fix would be to merge the two messages into one "attached" message
> at the end of the function. You could also use the dev->board_name instead of
> the open coded string. Something like:
>
>         dev_info(dev->class_dev, "%s: attached\n", dev->board_name);
>
> Also, the message should be moved so that it's the last thing that happens
> before the function returns.

Thanks for advice, i will send a new patch with changes.
