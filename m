Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab2AaVxQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 16:53:16 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60610 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753405Ab2AaVxP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 16:53:15 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdaLekGTdkpfr_Zf5PXAZ16dZsXrwnFHjBe+aEvGb5zYjg@mail.gmail.com>
References: <1328004002-24646-1-git-send-email-Barry.Song@csr.com>
 <1328004002-24646-2-git-send-email-Barry.Song@csr.com> <CACRpkdaLekGTdkpfr_Zf5PXAZ16dZsXrwnFHjBe+aEvGb5zYjg@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 31 Jan 2012 14:52:55 -0700
X-Google-Sender-Auth: 16cZ1a5Unr226XP6PnQHnVRi8TY
Message-ID: <CACxGe6srOi97g1OHDAULLcGP95ZGb8AJVURRFJt062HiN43wSg@mail.gmail.com>
Subject: Re: [PATCH 1/3] platform: add common resource requesting and mapping helper
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Barry Song <Barry.Song@csr.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        linux-mtd@lists.infradead.org, Barry Song <Baohua.Song@csr.com>,
        Erik Gilling <konkers@google.com>,
        Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
        David Woodhouse <dwmw2@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 2:20 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Tue, Jan 31, 2012 at 11:00 AM, Barry Song <Barry.Song@csr.com> wrote:
>
>> From: Barry Song <Baohua.Song@csr.com>
>>
>> this patch helps to move the common pattern from
>
> Good idea!
>
>> @@ -44,6 +44,7 @@ extern struct device platform_bus;
>>
>>  extern void arch_setup_pdev_archdata(struct platform_device *);
>>  extern struct resource *platform_get_resource(struct platform_device *, unsigned int, unsigned int);
>> +extern void __iomem *platform_devm_request_and_ioremap(struct platform_device *, unsigned int);
>
> But don't you want a reverse call for the module remove() function?
>
> Like:
>
> extern void __iomem *platform_devm_iounmap_and_free(struct
> platform_device *, unsigned int);

I wouldn't because it is exactly the same as the normal unwind call.
I don't think the name redirection buys us anything here.

g.
