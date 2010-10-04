Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755188Ab0JDKun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 06:50:43 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42076 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab0JDKum convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 06:50:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=kRHOLr7CM6xSykwADe6gk5RctLmP6jHd0hdqVHEufCaeHR0uePnYLMLQcSTKih1OCK
         bqeSvOd4vhUuRSM8V1vntCKkkCddOXHojp1jYkg+GyQWQFU4e2WJHmm8Gy/hng3x8/0L
         KpgSsrB4Hx8Rl/fkfr75LQO53nGvpn73R13z8=
MIME-Version: 1.0
In-Reply-To: <4CA9B07D.8080202@ru.mvista.com>
References: <1286115016-2759-1-git-send-email-rahul.ruikar@gmail.com> <4CA9B07D.8080202@ru.mvista.com>
From: Rahul Ruikar <rahul.ruikar@gmail.com>
Date: Mon, 4 Oct 2010 16:20:18 +0530
Message-ID: <AANLkTi=inrYar8MrwZbPsUH4NF1H7KdzdC86nrR21qz7@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: goku_udc: Fix error path
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, Dan Carpenter <error27@gmail.com>,
        nm127@freemail.hu, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergei,

Please ignore this particular patch.. I resubmitted this in another mail

Thanks,
- Rahul Ruikar





On 4 October 2010 16:16, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
> Hello.
>
> On 03-10-2010 18:10, Rahul Ruikar wrote:
>
>> call put_device() when device_register() fails.
>
>> Signed-off-by: Rahul Ruikar<rahul.ruikar@gmail.com>
>
> [...]
>>
>> diff --git a/drivers/usb/gadget/goku_udc.c b/drivers/usb/gadget/goku_udc.c
>> index 1088d08..080779b 100644
>> --- a/drivers/usb/gadget/goku_udc.c
>> +++ b/drivers/usb/gadget/goku_udc.c
>> @@ -1847,8 +1847,13 @@ static int goku_probe(struct pci_dev *pdev, const
>> struct pci_device_id *id)
>>        /* done */
>>        the_controller = dev;
>>        retval = device_register(&dev->gadget.dev);
>> -       if (retval == 0)
>> +       if (retval != 0) {
>> +               dev_reg_status = 2;
>> +               goto done;
>> +       } else {
>> +               dev_reg_status = 1;
>
>   Did you mean 'dev->dev_reg_status'?
>
>>                return 0;
>> +       }
>>
>>  done:
>>        if (dev)
>> diff --git a/drivers/usb/gadget/goku_udc.h b/drivers/usb/gadget/goku_udc.h
>> index 566cb23..c27b9e2 100644
>> --- a/drivers/usb/gadget/goku_udc.h
>> +++ b/drivers/usb/gadget/goku_udc.h
>> @@ -251,7 +251,8 @@ struct goku_udc {
>>                                        got_region:1,
>>                                        req_config:1,
>>                                        configured:1,
>> -                                       enabled:1;
>> +                                       enabled:1,
>> +                                       dev_reg_status:2;
>
>   I don't see where this new field is read in your patch...
>
> WBR, Sergei
>
