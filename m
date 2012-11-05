Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab2KEMZP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:25:15 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51456 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686Ab2KEMZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:25:12 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdbZB4nhFQtLH-GxBSK99RFk7yhSYMhO5keVjyugrqr7JA@mail.gmail.com>
References: <1351779602-13818-1-git-send-email-ulf.hansson@stericsson.com>
	<1351779602-13818-3-git-send-email-ulf.hansson@stericsson.com>
	<CACRpkdbZB4nhFQtLH-GxBSK99RFk7yhSYMhO5keVjyugrqr7JA@mail.gmail.com>
Date: Mon, 5 Nov 2012 13:25:11 +0100
Message-ID: <CAPDyKFpjdVMCuBdN-O+xxK=Dko-GTEjF5AYOeEMgWghJfB8EsA@mail.gmail.com>
Subject: Re: [PATCH 2/2] Input: nomadik-ske-keypad - start using the apb_pclk
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Ulf Hansson <ulf.hansson@stericsson.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 November 2012 19:12, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Thu, Nov 1, 2012 at 3:20 PM, Ulf Hansson <ulf.hansson@stericsson.com> wrote:
>
>> From: Ulf Hansson <ulf.hansson@linaro.org>
>>
>> Previously this clock was handled internally by the clockdriver,
>> but now this is separate clk. So we need take care of it.
>>
>> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
>
> So this is a silicon block clock and falls into the category of things
> we've been discussing...
>
> If I understand correctly, the only "real" solution is to
> implement the PM domains and have these enable the clocks.

Agree.

Although, since the pm_domain not yet exist, this as a way forward for
now - to fix what is broken.
When the pm_domain is in place and when we decide to fold in the clock
handling in there, we can move it.

>
> An alternative may be to move this driver over to the AMBA bus,
> because I think this device actually has primecell registers.
> Then the bus will take care of the pclk for starters.

You are definitely right, this driver can be converted into using the AMBA bus.
Although, do you think that should be done _instead_ of going ahead
with this patch or do you want that to be handled as a next and a
separate step?

Kind regards
Ulf Hansson
