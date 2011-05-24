Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab1EXGOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 02:14:11 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65294 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab1EXGOK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 02:14:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=sbYsUDUC/FZwXyPtQd08R0t6TYqf5R2a7t7kQBxxjMVaZSIwgyJ+RH3IcYeoDa1eoq
         UAKwXp/CSDt11tZ+0UmlNvFCm82vT7X6bTLY9D77G4P2Z7KvSgV2W/WRvjBhsCNPY9Ru
         D5sv6CgiQYod3GQECvc5HIKESkDwiQhcwsUOw=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=UeEEj0fRb9v1viFpUOWvmrSHM2g@mail.gmail.com>
References: <201105231527.53805.stevie.trujillo@gmail.com>
	<BANLkTi=iGzkSwWPZrFPBJZYg6x=dDBb5Eg@mail.gmail.com>
	<BANLkTi=Xtunb3Qocw_AWZyAkBak52=njWQ@mail.gmail.com>
	<BANLkTinNn_nx1Wd8ocUHe2WipFkUK0o-2A@mail.gmail.com>
	<BANLkTi=UeEEj0fRb9v1viFpUOWvmrSHM2g@mail.gmail.com>
Date: Tue, 24 May 2011 15:14:09 +0900
X-Google-Sender-Auth: vcZUshAM1SRDtVHo07gmx_7Uwm4
Message-ID: <BANLkTimcxvdXeyqP+_h=JQwiay_PH8awkA@mail.gmail.com>
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

On Tue, May 24, 2011 at 2:49 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
> On Tue, May 24, 2011 at 1:32 PM, Kyungmin Park <kmpark@infradead.org> wrote:
>> On Mon, May 23, 2011 at 11:36 PM, Kyungmin Park <kmpark@infradead.org> wrote:
>>> Hi,
>>>
>>> You have to define the ramoops platform data at your board file and
>>> pass it to the platform device init.
>>> As these address is different for each SoCs. e.g., x86, and Samsung
>>> ARM SoCs and so on.
>>>
>>> I think maybe you use the x86 so define the default x86 ram address
>>> for ramoops and pass it to platform structures.
>
> Why not document this?
>
>>>
>>> At office, I will send the sample usage.
>>
>> +static struct ramoops_platform_data goni_ramoops_data = {
>> +       .mem_size               = SZ_16K,
>> +       .mem_address            = 0xED000000,   /* SRAM */
>> +};
>> +
>> +static struct platform_device goni_ramoops = {
>> +       .name = "ramoops",
>> +       .dev = {
>> +               .platform_data = &goni_ramoops_data,
>> +       },
>> +};
>>
>> and register the goni_rammoops. then you can find a rammops.
>>
>
> Huh? Is this for x86 too? Why so unfriendly for end-users?
I don't know which address is acceptable for x86, in case of ARM, each
SoCs has different SRAM address. so it's not good to define for all
SoCs and ARM.
>
> I think we need some kernel parameter like 'crashkernel=' (or memmap=)
> to reserve memory for ramoops, right?

The first implementation is just module parameters.
ramoops.address=0x??????? ramoops.size=0x????. So I patched it as
using platform devices.
and the reason use the platform is it's dependent on each SoCs and board usage.

>
> Thanks.
>
