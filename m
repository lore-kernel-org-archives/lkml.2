Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973Ab1EXFcj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 01:32:39 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:51092 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab1EXFci convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 01:32:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=VT4Ugepg+pv5wdfwkY/rEIM9Z3JVIohiMlM+WvyPxUJudNvLX5ZouOPLhfmlX1l+hX
         9YsHqUWh7x7ljU6aHXQUJT/DvMkhvlk1b+YPPDq/JyIcutQ3O5IG3czaBmQzhNGrA8EQ
         YOQMIwvg11FRdADh21WDqAOe8bHutQVtKAHqs=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=Xtunb3Qocw_AWZyAkBak52=njWQ@mail.gmail.com>
References: <201105231527.53805.stevie.trujillo@gmail.com>
	<BANLkTi=iGzkSwWPZrFPBJZYg6x=dDBb5Eg@mail.gmail.com>
	<BANLkTi=Xtunb3Qocw_AWZyAkBak52=njWQ@mail.gmail.com>
Date: Tue, 24 May 2011 14:32:37 +0900
X-Google-Sender-Auth: SE54gceXBhr8VzPBRzJPKclA8T4
Message-ID: <BANLkTinNn_nx1Wd8ocUHe2WipFkUK0o-2A@mail.gmail.com>
Subject: Re: ramoops: is using platform_drivers correct?
From: Kyungmin Park <kmpark@infradead.org>
To: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Stevie Trujillo <stevie.trujillo@gmail.com>, marco.stornelli@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 11:36 PM, Kyungmin Park <kmpark@infradead.org> wrote:
> Hi,
>
> You have to define the ramoops platform data at your board file and
> pass it to the platform device init.
> As these address is different for each SoCs. e.g., x86, and Samsung
> ARM SoCs and so on.
>
> I think maybe you use the x86 so define the default x86 ram address
> for ramoops and pass it to platform structures.
>
> At office, I will send the sample usage.

+static struct ramoops_platform_data goni_ramoops_data = {
+       .mem_size               = SZ_16K,
+       .mem_address            = 0xED000000,   /* SRAM */
+};
+
+static struct platform_device goni_ramoops = {
+       .name = "ramoops",
+       .dev = {
+               .platform_data = &goni_ramoops_data,
+       },
+};

and register the goni_rammoops. then you can find a rammops.

Thank you,
Kyungmin Park


>
> Thank you,
> Kyungmin Park
>
> On Mon, May 23, 2011 at 11:10 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> On Mon, May 23, 2011 at 9:27 PM, Stevie Trujillo
>> <stevie.trujillo@gmail.com> wrote:
>>> Hello,
>>>
>>> ramoops (drivers/char/ramoops.c) is for "all" computers right? When I try to
>>> load it on my laptop, I get ENODEV. This is caused by platform_driver_probe()
>>> - the code never reaches the ramoops probe callback.
>>>
>>> After I removed the platform_driver stuff, moving everything into ramoops_init
>>> and ramoops_exit it worked.
>>
>> Actually that was changed by Kyungmin, Cc'ing...
>>
>> commit c3b92ce9e75f6353104fc7f8e32fb9fdb2550ad0
>> Author: Kyungmin Park <kyungmin.park@samsung.com>
>> Date:   Wed Oct 27 15:34:52 2010 -0700
>>
>>    ramoops: use the platform data structure instead of module params
>>
>>    As each board and system has different memory for ramoops.  It's better to
>>    define the platform data instead of module params.
>>
>>    [akpm@linux-foundation.org: fix ramoops_remove() return type]
>>    Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>    Cc: Marco Stornelli <marco.stornelli@gmail.com>
>>    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
