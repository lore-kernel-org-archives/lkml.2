Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758765Ab2FUIVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 04:21:11 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43603 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758753Ab2FUIVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 04:21:07 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998FC074@DQHE02.ent.ti.com>
References: <20120621132738.6e797593acc58b3e30902f69@canb.auug.org.au> <A874F61F95741C4A9BA573A70FE3998FC074@DQHE02.ent.ti.com>
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 21 Jun 2012 16:20:46 +0800
Message-ID: <CAF+7xWkzKkwfBFQS1vr-Tk2Auu+5HQmX7bZCGJhsmXRi0V5OZw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the regulator tree
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>, "Girdwood, Liam" <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/21 Kim, Milo <Milo.Kim@ti.com>:
>> Caused by commit 809d310c7e69 ("regulator: lp872x: Don't allow modular
>> build") but that was done to fix a different build problem.
>
> Sorry for this conflict.
>
> Build config of lp872x driver has been changed as tristate.
> And related undefined symbol error has been fixed.
> (don't use devm_gpio_request_one() at this moment because it can not be exported.)

I don't think this is the good way, other drivers may have this build problem.
I think we can fix it by having the patch exporting
devm_gpio_request_one upstrem ASAP.

BTW, In yesterday's linux-next tree, Andrew has below commit.

commit a291ede7be8359a8986740b11b93f9c80e40210b
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Wed Jun 20 09:55:47 2012 +1000

    backlight-l4f00242t03-use-devm_gpio_request_one-fix

    export devm_gpio_request_one() to modules

    Cc: Alberto Panizzo <alberto@amarulasolutions.com>
    Cc: Jingoo Han <jg1.han@samsung.com>
    Cc: Richard Purdie <rpurdie@rpsys.net>
    Cc: Grant Likely <grant.likely@secretlab.ca>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Regards,
Axel
