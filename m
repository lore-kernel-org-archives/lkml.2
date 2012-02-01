Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab2BACWV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 21:22:21 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55955 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab2BACWU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 21:22:20 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdaLekGTdkpfr_Zf5PXAZ16dZsXrwnFHjBe+aEvGb5zYjg@mail.gmail.com>
References: <1328004002-24646-1-git-send-email-Barry.Song@csr.com>
 <1328004002-24646-2-git-send-email-Barry.Song@csr.com> <CACRpkdaLekGTdkpfr_Zf5PXAZ16dZsXrwnFHjBe+aEvGb5zYjg@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 1 Feb 2012 10:22:00 +0800
Message-ID: <CAGsJ_4z-QB_1z1Dw3H6sE2Vwe2ZQtRce9uy-Xa3V+sfj2drOuA@mail.gmail.com>
Subject: Re: [PATCH 1/3] platform: add common resource requesting and mapping helper
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Barry Song <Barry.Song@csr.com>, Atsushi Nemoto <anemo@mba.ocn.ne.jp>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Grant Likely <grant.likely@secretlab.ca>,
        linux-mtd@lists.infradead.org, Barry Song <Baohua.Song@csr.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Erik Gilling <konkers@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

2012/2/1 Linus Walleij <linus.walleij@linaro.org>:
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

that point is we have the garbage collection mechanism by calling
devm_ function families. everything is undone on driver detach.
so we will not have the free and unmap things.
>
> ?
>
> Yours,
> Linus Walleij

-barry
