Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390Ab1EXFtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 01:49:35 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48122 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601Ab1EXFte convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 01:49:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NeRrsth4CEl17aWJNKKAig21h74hfakvPu56V5YyAbOZo5WYehxMp8Q9kVecHIlaG0
         FcwKmCZNlxIK605qv5JBi77C1cUATVTwp2M47F/Kle1m8qiHl4hNBUzPsZ5lblVBZO7A
         dD2ID8RvrOvxM6EYWf3lC1wFJEDZkzq0qHzIM=
MIME-Version: 1.0
In-Reply-To: <BANLkTinNn_nx1Wd8ocUHe2WipFkUK0o-2A@mail.gmail.com>
References: <201105231527.53805.stevie.trujillo@gmail.com>
	<BANLkTi=iGzkSwWPZrFPBJZYg6x=dDBb5Eg@mail.gmail.com>
	<BANLkTi=Xtunb3Qocw_AWZyAkBak52=njWQ@mail.gmail.com>
	<BANLkTinNn_nx1Wd8ocUHe2WipFkUK0o-2A@mail.gmail.com>
Date: Tue, 24 May 2011 13:49:34 +0800
Message-ID: <BANLkTi=UeEEj0fRb9v1viFpUOWvmrSHM2g@mail.gmail.com>
Subject: Re: ramoops: is using platform_drivers correct?
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Stevie Trujillo <stevie.trujillo@gmail.com>, marco.stornelli@gmail.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 1:32 PM, Kyungmin Park <kmpark@infradead.org> wrote:
> On Mon, May 23, 2011 at 11:36 PM, Kyungmin Park <kmpark@infradead.org> wrote:
>> Hi,
>>
>> You have to define the ramoops platform data at your board file and
>> pass it to the platform device init.
>> As these address is different for each SoCs. e.g., x86, and Samsung
>> ARM SoCs and so on.
>>
>> I think maybe you use the x86 so define the default x86 ram address
>> for ramoops and pass it to platform structures.

Why not document this?

>>
>> At office, I will send the sample usage.
>
> +static struct ramoops_platform_data goni_ramoops_data = {
> +       .mem_size               = SZ_16K,
> +       .mem_address            = 0xED000000,   /* SRAM */
> +};
> +
> +static struct platform_device goni_ramoops = {
> +       .name = "ramoops",
> +       .dev = {
> +               .platform_data = &goni_ramoops_data,
> +       },
> +};
>
> and register the goni_rammoops. then you can find a rammops.
>

Huh? Is this for x86 too? Why so unfriendly for end-users?

I think we need some kernel parameter like 'crashkernel=' (or memmap=)
to reserve memory for ramoops, right?

Thanks.
