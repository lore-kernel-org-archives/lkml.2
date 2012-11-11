Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab2KKSkq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 13:40:46 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61686 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753598Ab2KKSkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 13:40:45 -0500
MIME-Version: 1.0
In-Reply-To: <509D3A53.6080007@wwwdotorg.org>
References: <1352456915-28738-1-git-send-email-linus.walleij@stericsson.com>
	<509D3A53.6080007@wwwdotorg.org>
Date: Sun, 11 Nov 2012 19:40:43 +0100
Message-ID: <CACRpkdZz8_SVK6ERaXXTs5d8OBBkYY8e7uwx_dmAXkwV2iPovQ@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl/nomadik: make independent of prcmu driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Jean Nicolas Graux <jean-nicolas.graux@stericsson.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Loic Pallardy <loic.pallardy@st.com>,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 9, 2012 at 6:16 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> [Me]
>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +     if (res) {
>> +             npct->prcm_base = devm_ioremap(&pdev->dev, res->start,
>> +                                            resource_size(res));
>> +             if (!npct->prcm_base) {
>> +                     dev_err(&pdev->dev,
>> +                             "failed to ioremap PRCM registers\n");
>> +                     return -ENOMEM;
>> +             }
>> +     } else {
>> +             dev_info(&pdev->dev,
>> +                      "No PRCM base, assume no ALT-Cx control is available\n");
>> +     }
>
> Where is "assume no ALT-Cx control is available" implemented; I don't
> see anything that uses npct->prcm_base to conditionally enable/block any
> features. Is it just assumed that the DT won't contain any entries that
> trigger writes to the PRCM registers? That seems fragile; it could cause
> a "user"-triggered kernel crash.

Yeah. That's been in for a while, so this patch in itself is not making
things more fragile, it came with the first Alt-Cx patch.
So it is indeed based on good faith in the maps.

I'm poking Jean-Nicolas to have a look at hardening
this with some check, ping!

> Aside from that, this seems fine. Much smaller than V1:-)

Yeah, thanks for poking us...

Yours,
Linus Walleij
