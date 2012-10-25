Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755025Ab2JYMHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 08:07:37 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:48898 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab2JYMHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 08:07:36 -0400
MIME-Version: 1.0
In-Reply-To: <20121025082341.GC3348@gmail.com>
References: <1351089926-32161-1-git-send-email-lee.jones@linaro.org>
	<1351089926-32161-3-git-send-email-lee.jones@linaro.org>
	<CACRpkdaeBW2ecQZ2fA-hL8o47pYpjZ=5Mn131F87u58rX+dekw@mail.gmail.com>
	<20121025073127.GB971@gmail.com>
	<5088F0EE.8030900@stericsson.com>
	<20121025082341.GC3348@gmail.com>
Date: Thu, 25 Oct 2012 14:07:34 +0200
Message-ID: <CACRpkdb9wHStmVHWJy7YhMeNX5T31mXOJSF0J_e=uBneSCrgmA@mail.gmail.com>
Subject: Re: [PATCH 2/6] pinctrl: Update clock handling for the
 pinctrl-nomadik GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 10:23 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Thu, 25 Oct 2012, Linus Walleij wrote:
>>
>> Yeah drop it for now.
>
> Actually, a quick question before I do:
>
> If it's better/faster to prepare the clock and keep it prepared
> while you do clk_enable/clk_disable,

It is generally faster that is why we call it fastpath.

E.g. if the clock hardware can do this in IRQ context by just
chaninging one bit in a quickly written register from 1->0 and
then the clock goes off from some silicon.

Whether it's "better" or not is a transcendental question,
as it requires a ruler to measure betterness.

> why don't we do that in all
> drivers? Why do we bother to prepare/unprepare each time if all
> it does is take up cycles?

Usually to save power.

Albeit saving power may be at odds with gaining the maximum
performance and/or latency.

So depending on the demands and use case the answer to
whether or not you want to do this will be different.

That's for the clock API.

In the ux500 case specifically, you can drill down to the
clock implementation and ask the question whether or not
we want to do this for this instance of the pin controller
in this case, I'll leave that for Ulf to answer... but remember
that this driver is also used for the Nomadik NHK8815.

Yours,
Linus Walleij
