Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab0FJGPr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 02:15:47 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53826 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712Ab0FJGPp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 02:15:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=t8USBPOUVZcPu5VNjXIasW8+3hQj73N1jHFz0Kwx5JKDvOtrrFapGsSVXvCYAmSFn4
         xo5Adfd26Rix6dQBnDCVi8KI4+gJJlENFXIe+hWeqrajzBavxLJRppaiBc1v0qSPQc1V
         k2l5hCum7RicNKJvwA4IUOSOcFs9Vf+ZDpZfc=
MIME-Version: 1.0
In-Reply-To: <20100610055026.GM7660@chipmunk>
References: <4c104d7a.0c3ddf0a.2185.329a@mx.google.com> <20100610055026.GM7660@chipmunk>
From: Dmytro Milinevskyy <milinevskyy@gmail.com>
Date: Thu, 10 Jun 2010 09:15:24 +0300
X-Google-Sender-Auth: GJ5Hj4zZ8X3ONDFxTE1s645-LqA
Message-ID: <AANLkTilVxQBnoLNT_Z7aoPqjHqNqqXS58Av2txdsuTWm@mail.gmail.com>
Subject: Re: [PATCH] Marvell OpenRD-Ultimate machine support
To: Alexander Clouter <alex@digriz.org.uk>
Cc: linux-arm-kernel@lists.infradead.org,
       Russell King <linux@arm.linux.org.uk>,
       Dhaval Vasa <dhaval.vasa@einfochips.com>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Nicolas Pitre <nico@fluxnic.net>, Simon Guinot <sguinot@lacie.com>,
       Martin Michlmayr <tbm@cyrius.com>,
       Simon Kagstrom <simon.kagstrom@netinsight.net>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

You are right, I didn't notice that it's called via subsys_initcall.

-- Dima

On Thu, Jun 10, 2010 at 8:50 AM, Alexander Clouter <alex@digriz.org.uk> wrote:
> Hi,
>
> * Dmytro Milinevskyy <milinevskyy@gmail.com> [2010-06-10 05:24:56+0300]:
>>
>> [snipped]
>>
>> @@ -84,8 +90,7 @@ static void __init openrd_init(void)
>>
>>  static int __init openrd_pci_init(void)
>>  {
>> -     if (machine_is_openrd_base() || machine_is_openrd_client())
>> -             kirkwood_pcie_init();
>> +     kirkwood_pcie_init();
>>
>>       return 0;
>>  }
>>
> You just 'broke' kirkwood, welcome to the club.  We all have done this:
>
> http://marc.info/?l=linux-arm-kernel&m=125624586625065&w=2
> http://marc.info/?l=linux-arm-kernel&m=125804222219159&w=2
>
> Put that 'if()' clause back in, the 'subsys_initcall(openrd_pci_init)'
> causes that code to run on *all* compiled in boards (think of the case
> where you have SheevaPlug's also enabled).
>
> Cheers
>
> --
> Alexander Clouter
> .sigmonster says: Poverty begins at home.
>
