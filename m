Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab1GGO1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 10:27:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48931 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab1GGO1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 10:27:48 -0400
MIME-Version: 1.0
In-Reply-To: <1310004032.20150.14.camel@psiaudioba-mobl1>
References: <1309123793-7806-1-git-send-email-per.forlin@linaro.org>
	<1309123793-7806-3-git-send-email-per.forlin@linaro.org>
	<1310004032.20150.14.camel@psiaudioba-mobl1>
Date: Thu, 7 Jul 2011 16:27:47 +0200
X-Google-Sender-Auth: OribGANYStjt4CuIKTE--UEkOGw
Message-ID: <CAKnu2MoqGjgvVhSRQz_+bP=ErhaXp5+Rn0N+ui7F7SFmw=Q7vQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] dmaengine: remove ste_dma40 from issue_pending TODO
From: Linus Walleij <linus.walleij@linaro.org>
To: Vinod Koul <vkoul@infradead.org>
Cc: Per Forlin <per.forlin@linaro.org>, linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/7 Vinod Koul <vkoul@infradead.org>:
> On Sun, 2011-06-26 at 23:29 +0200, Per Forlin wrote:
>> ste_dma40 now implements issue_pending according to documentation.
>> Submit adds descriptos to a pending queue with are flushed down to the DMAC
>> at issue_pending.
>>
>> Signed-off-by: Per Forlin <per.forlin@linaro.org>
> How about the client driver which are currently using this driver, wont
> they break as they would be calling submit and not issue_pending...?

They all call both, so it works fine. First submit() then issue_pending()
in sucession.

In-tree drivers:
drivers/tty/serial/amba-pl011.c
drivers/mmc/host/mmci.c
drivers/spi/spi-pl022.c

So:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
