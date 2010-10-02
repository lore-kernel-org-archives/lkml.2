Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab0JBOrO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 10:47:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57151 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab0JBOrN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 10:47:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=f2TBBdPlLtdxd0YpgI65WO2TRJYcJ317841EQLNPkUd9SQgmoPTkbT2OIQIWZ2TGxi
         CT0cGIesMGSlvRq8XopUDFgqjNwCNWevUDBy61Mj7GfKq172wumTd3ZslBNE6rp2mEpy
         AxvjUanSWB8fbJSeSJjYmDph89JPLHoAyL30E=
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1010021018250.15874-100000@netrider.rowland.org>
References: <1286004210-3833-1-git-send-email-rahul.ruikar@gmail.com> <Pine.LNX.4.44L0.1010021018250.15874-100000@netrider.rowland.org>
From: Rahul Ruikar <rahul.ruikar@gmail.com>
Date: Sat, 2 Oct 2010 20:16:51 +0530
Message-ID: <AANLkTi==MpP6FpvqWtmHwDM7CCRbTAz-TMyLS_Z_thGj@mail.gmail.com>
Subject: Re: [PATCH] usb: gadget: dummy_hcd: Fix error path
To: Alan Stern <stern@rowland.harvard.edu>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 October 2010 20:01, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sat, 2 Oct 2010, Rahul Ruikar wrote:
>
>> In function dummy_udc_probe()
>> call put_device() when device_register() fails.
>>
>> Signed-off-by: Rahul Ruikar <rahul.ruikar@gmail.com>
>> ---
>>  drivers/usb/gadget/dummy_hcd.c |    4 +++-
>>  1 files changed, 3 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/usb/gadget/dummy_hcd.c b/drivers/usb/gadget/dummy_hcd.c
>> index dc65462..2548091 100644
>> --- a/drivers/usb/gadget/dummy_hcd.c
>> +++ b/drivers/usb/gadget/dummy_hcd.c
>> @@ -885,8 +885,10 @@ static int dummy_udc_probe (struct platform_device *pdev)
>>       dum->gadget.dev.parent = &pdev->dev;
>>       dum->gadget.dev.release = dummy_gadget_release;
>>       rc = device_register (&dum->gadget.dev);
>> -     if (rc < 0)
>> +     if (rc < 0) {
>> +             put_device(&dum->gadget.dev);
>>               return rc;
>> +     }
>>
>>       usb_get_hcd (dummy_to_hcd (dum));
>
> Acked-by: Alan Stern <stern@rowland.harvard.edu>
>
> Similar changes are needed in net2280.c, file_storage.c and
> f_mass_storage.c, probably also in goku_udc.c and langwell_udc.c.
> Would you like to make them?
>
yes Alan, I am aware of changes needed in these files. actually there
are many other changes needed for these files ( apart from
device_register() failure.. ) I am working on these files. also this
current patch need some updates.

Thanks,
Rahul

> Alan Stern
>
>
