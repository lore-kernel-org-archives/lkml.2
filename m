Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752161Ab1JLBzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 21:55:11 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56154 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980Ab1JLBzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 21:55:10 -0400
MIME-Version: 1.0
In-Reply-To: <1711499402.60485.1318380603125.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
References: <CAKYAXd_MJy_3TAoM_buCmP5g3j1e=Vh5vZPJP9O_nxDrWiHsAw@mail.gmail.com>
	<1711499402.60485.1318380603125.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
Date: Wed, 12 Oct 2011 10:55:08 +0900
Message-ID: <CAKYAXd_HAv5+kg26tGLZcDHWmD2MoQFFTwoDtFuvsqgZTcPJwA@mail.gmail.com>
Subject: Re: mmc core broken dependency on CONFIG_BLOCK (Was: linux-next: Tree
 for Oct 11 (mmc))
From: NamJae Jeon <linkinjeon@gmail.com>
To: Andrei Warkentin <awarkentin@vmware.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/12 Andrei Warkentin <awarkentin@vmware.com>:
> Hi,
>
> ----- Original Message -----
>> From: "NamJae Jeon" <linkinjeon@gmail.com>
>> To: "Andrei Warkentin" <awarkentin@vmware.com>
>> Cc: linux-next@vger.kernel.org, "LKML" <linux-kernel@vger.kernel.org>, linux-mmc@vger.kernel.org, "Chris Ball"
>> <cjb@laptop.org>, "Stephen Rothwell" <sfr@canb.auug.org.au>, "Randy Dunlap" <rdunlap@xenotime.net>
>> Sent: Tuesday, October 11, 2011 8:16:51 PM
>> Subject: Re: mmc core broken dependency on CONFIG_BLOCK (Was: linux-next: Tree for Oct 11 (mmc))
>>
>> 2011/10/12 Andrei Warkentin <awarkentin@vmware.com>:
>> > ----- Original Message -----
>> >> From: "NamJae Jeon" <linkinjeon@gmail.com>
>> >> To: "Randy Dunlap" <rdunlap@xenotime.net>, "Andrei Warkentin"
>> >> <awarkentin@vmware.com>
>> >> Cc: linux-next@vger.kernel.org, "LKML"
>> >> <linux-kernel@vger.kernel.org>, linux-mmc@vger.kernel.org, "Chris
>> >> Ball"
>> >> <cjb@laptop.org>, "Stephen Rothwell" <sfr@canb.auug.org.au>
>> >> Sent: Tuesday, October 11, 2011 7:20:48 PM
>> >> Subject: Re: mmc core broken dependency on CONFIG_BLOCK (Was:
>> >> linux-next: Tree for Oct 11 (mmc))
>> >>
>> >> Hi Randy, Andrei.
>> >>
>> >> I suggest third option for this.
>> >> As you know, MMC like ATA Driver and SCSI Driver etc.. can not
>> >> enable
>> >> without CONFIG_BLOCK
>> >> So I think that mmc should be depended from CONFIG_BLOCK like
>> >> other
>> >> block device driver.
>> >> see the their Kconfig. How do you think ?
>> >
>> > MMC core doesn't not imply MMC_BLOCK. You could well use SDIO
>> > devices via MMC without any flash storage whatsoever.
>> > What I want to say is that MMC_BLOCK already depends on BLOCK. MMC,
>> > however, has no such functional dependence, as it
>> > just (effectively) provides bus and device enumeration. So I think
>> > the better solution is wrapping all MMC partition
>> > code within mmc/core/mmc.c and card.h with CONFIG_BLOCK.
>> yes, you're right, I found it after sending mail. If so, should I
>> wrap
>> CONFIG_MMC_BLOCK instead of CONFIG_MMC ? After I add CONFIG_MMC_BLOCK
>> in core/mmc.c, card.h, I can see compile is okay.
>> Thanks.
>> >
>
> I am not sure if it should be CONFIG_MMC_BLOCK or CONFIG_BLOCK. After all, the
> code you're wrapping doesn't really depend on CONFIG_MMC_BLOCK, it gets consumed by it, and
> it depends (in using that one define) only on CONFIG_BLOCK. Maybe I'm overthinking it
> and the code should just define it's own MAX_MMC_PART_NAME to be like 10 or something.
yes, I agree your opinion,  If we define it is easy to solve.
I will send new patch for it today.
Thanks.
>
> A
>
