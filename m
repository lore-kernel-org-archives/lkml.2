Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161Ab1EKTlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 15:41:32 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63495 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab1EKTlb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 15:41:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=m8rYYj7tUKufuUaqmyqM9TVkAkW37HEIidsKQ+A+5Y+nj0PDpDrn/e90qu7GbPUoHW
         P2beTD/9VcRU7qH2LOgLR6DMKe6hWjGuLED75a42CA9d2rdy3UbclWpeuRy+kTrIYZ4e
         AGWqPvCJfaT1OSUNjHfK7ne4hr6cG1FHGVgIQ=
MIME-Version: 1.0
In-Reply-To: <20110511082328.GA2637@sortiz-mobl>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
	<1304901131-7104-17-git-send-email-sameo@linux.intel.com>
	<BANLkTinHyGv11px+cO_ORL0-83T4c-mbsQ@mail.gmail.com>
	<20110511082328.GA2637@sortiz-mobl>
Date: Wed, 11 May 2011 21:41:30 +0200
X-Google-Sender-Auth: 5Ms5UFANHbNhdKqc5IOiKtjWYuQ
Message-ID: <BANLkTi=s9+tDKa69yvG-o9JTjgoAqJtmag@mail.gmail.com>
Subject: Re: [PATCH 16/19] mfd: Use mfd cell platform_data for tps6105x cells
 platform bits
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/11 Samuel Ortiz <sameo@linux.intel.com>:
>> > -       struct tps6105x *tps6105x = mfd_get_data(pdev);
>> > +       struct tps6105x *tps6105x = pdev->dev.platform_data;
>>
>> Can you use platform_get_drvdata(pdev); instead?
>
> I suppose you mean dev_get_platdata() ?

Yes, sorry.

>> >  static int __devexit tps6105x_regulator_remove(struct platform_device *pdev)
>> >  {
>> > -       struct tps6105x *tps6105x = platform_get_drvdata(pdev);
>> > +       struct tps6105x *tps6105x = pdev->dev.platform_data;
>>
>> And this is a NO-OP, actually a bug in the present code, just leave it
>> as it is and the other changes removing the mfd->mfd_data fixes the bug...
>
> I agree it's a bug in the current code. But I need to fetch the platform_data
> pointer, so here again I would have to call dev_get_platdata().

Yes again, you're right.

I was mainly after using the pretty accessor functions rather than direct
dereferencing, no big deal.

Thanks,
Linus Walleij
