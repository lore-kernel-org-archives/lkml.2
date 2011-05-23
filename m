Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab1EWOgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 10:36:17 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54689 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754860Ab1EWOgQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 10:36:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Y2KsGbkmdH0TeBqbOA647vyEvuFv7qZ/JnOhyccN4fKCpnU3egA6gOKqhryT/d/rqC
         PGnRP/TO1NXoy7Mv9qNXPZEzUMGrjERAJLW6A90KKNunHOBCGkceByu/2YqG72Miwgpz
         /pF3DLMV7G4uqypXPu01HUXGP4bMXzyVI4McQ=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=iGzkSwWPZrFPBJZYg6x=dDBb5Eg@mail.gmail.com>
References: <201105231527.53805.stevie.trujillo@gmail.com>
	<BANLkTi=iGzkSwWPZrFPBJZYg6x=dDBb5Eg@mail.gmail.com>
Date: Mon, 23 May 2011 23:36:15 +0900
X-Google-Sender-Auth: nFN9Z1HeY_mq6_E_inZgZ4c0_vc
Message-ID: <BANLkTi=Xtunb3Qocw_AWZyAkBak52=njWQ@mail.gmail.com>
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

Hi,

You have to define the ramoops platform data at your board file and
pass it to the platform device init.
As these address is different for each SoCs. e.g., x86, and Samsung
ARM SoCs and so on.

I think maybe you use the x86 so define the default x86 ram address
for ramoops and pass it to platform structures.

At office, I will send the sample usage.

Thank you,
Kyungmin Park

On Mon, May 23, 2011 at 11:10 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Mon, May 23, 2011 at 9:27 PM, Stevie Trujillo
> <stevie.trujillo@gmail.com> wrote:
>> Hello,
>>
>> ramoops (drivers/char/ramoops.c) is for "all" computers right? When I try to
>> load it on my laptop, I get ENODEV. This is caused by platform_driver_probe()
>> - the code never reaches the ramoops probe callback.
>>
>> After I removed the platform_driver stuff, moving everything into ramoops_init
>> and ramoops_exit it worked.
>
> Actually that was changed by Kyungmin, Cc'ing...
>
> commit c3b92ce9e75f6353104fc7f8e32fb9fdb2550ad0
> Author: Kyungmin Park <kyungmin.park@samsung.com>
> Date:   Wed Oct 27 15:34:52 2010 -0700
>
>    ramoops: use the platform data structure instead of module params
>
>    As each board and system has different memory for ramoops.  It's better to
>    define the platform data instead of module params.
>
>    [akpm@linux-foundation.org: fix ramoops_remove() return type]
>    Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>    Cc: Marco Stornelli <marco.stornelli@gmail.com>
>    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
