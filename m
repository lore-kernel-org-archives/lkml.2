Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754228Ab1EIOdw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 10:33:52 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53347 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab1EIOdo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 10:33:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=i3WlwXxCVa+mAOdK0h6yIq3N8b4oCvpFU66+NHVWN/l447XlmSGUkLLlKLXauBBMMA
         9T+NNEcRwhan8WupxqBLYE8XpIzyMclQpAq9Pwyh7lXoaPjikwoYYhypRKIxZoGFUKCc
         3RSr4q8Au8ttZHR40ktI+zeKR06GWiV1jK8Q8=
MIME-Version: 1.0
In-Reply-To: <201105081759.03032.arnd@arndb.de>
References: <1304632783-8781-1-git-send-email-zajec5@gmail.com>
	<201105081647.22091.arnd@arndb.de>
	<BANLkTimhOCL7O1ERqUKkH_4sgq5xNYJZRg@mail.gmail.com>
	<201105081759.03032.arnd@arndb.de>
Date: Mon, 9 May 2011 16:33:43 +0200
Message-ID: <BANLkTikoLnrVvAWC7v7+q1fe4+Qt3HF4ug@mail.gmail.com>
Subject: Re: [PATCH][WAS:bcmai, axi] bcma: add Broadcom specific AMBA bus driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        George Kashperko <george@znau.edu.ua>,
        Russell King <rmk@arm.linux.org.uk>, Greg KH <greg@kroah.com>,
        linux-wireless@vger.kernel.org,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        b43-dev@lists.infradead.org,
        =?UTF-8?Q?Michael_B=C3=BCsch?= <mb@bu3sch.de>,
        Arend van Spriel <arend@broadcom.com>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        Andy Botting <andy@andybotting.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/8 Arnd Bergmann <arnd@arndb.de>:
> On Sunday 08 May 2011 16:59:55 Rafał Miłecki wrote:
>> 2011/5/8 Arnd Bergmann <arnd@arndb.de>:
>> >> >> diff --git a/drivers/bcma/TODO b/drivers/bcma/TODO
>> >> >> new file mode 100644
>> >> >> index 0000000..45eadc9
>> >> >> --- /dev/null
>> >> >> +++ b/drivers/bcma/TODO
>> >> >> @@ -0,0 +1,3 @@
>> >> >> +- Interrupts
>> >> >> +- Defines for PCI core driver
>> >> >> +- Convert bcma_bus->cores into linked list
>> >> >
>> >> > The last item doesn't make sense to me. Since you are using the regular
>> >> > driver model, you can simply iterate over all child devices of any
>> >> > dev.
>> >>
>> >> It's about optimization. Right now bcma_bus->cores is static array, we
>> >> probably never will use all entries.
>> >
>> > Oh, I see. You should probably have neither of them. Instead allocate
>> > the devices dynamically as you find them and do a device_register,
>> > which will add the device into linked list.
>>
>> As I said, and wrote: TODO.
>
> Well, I think getting this part right is essential before the
> patch can get merged.
>
>> > Maybe you didn't understand what I said: This should be
>> >
>> > struct bcma_device {
>> >     struct bcma_bus *bus;
>> >     struct bcma_device_id id;
>> >     struct device dev;
>> >     u8 core_index;
>> >
>> >     u32 addr;
>> >     u32 wrap;
>> >
>> >     void *drvdata;
>> > };
>> >
>> > Here, bcma_device is the device, no need to follow pointers
>> > around. It's how all bus_types work, you should just do the same.
>>
>> We can not use static "struct device", see Greg's comments in:
>> [RFC][PATCH V3] axi: add AXI bus driver
>> (not to mention we would have unused "struct device" in ChipCommon's
>> and PCI's "struct bcma_device").
>
> Please reread what Greg explained, it's actually the same as what
> I said here: Don't make the device static (you already don't),
> don't put the device structure as a member in the bus structure
> (as discussed above). Make the device a member of bcma_device,
> so you get proper reference counting for it, in the way that
> Greg explained.

Thanks for help & explaining! Unfortunately Greg didn't answer if my
changed implementation is fine. I'll fix this!

-- 
Rafał
