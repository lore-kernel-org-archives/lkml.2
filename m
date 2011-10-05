Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934510Ab1JEORZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 10:17:25 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43472 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934407Ab1JEORX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 10:17:23 -0400
MIME-Version: 1.0
In-Reply-To: <20111003155316.GQ4118@sortiz-mobl>
References: <1313137713-30848-1-git-send-email-linus.walleij@stericsson.com>
	<20111003155316.GQ4118@sortiz-mobl>
Date: Wed, 5 Oct 2011 16:17:22 +0200
Message-ID: <CACRpkdauBH2njguZ7WarAGaaGL25iXMSv=-1KExAtFJktz3X_Q@mail.gmail.com>
Subject: Re: [PATCH 08/23] mfd/db8500-prcmu: add watchdog accessor functions
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Jonas Aberg <jonas.aberg@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 3, 2011 at 5:53 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:

>> +int prcmu_kick_a9wdog(u8 id)
>> +{
>> +     return prcmu_a9wdog(MB4H_A9WDOG_KICK, id, 0, 0, 0);
>> +}
>
> So I suppose you will eventually export those symbols ?

Not really, both this driver and the watchdog driver are of the
"always-compile-in" (bool) type, you really don't want to load the
watchdog as a module, because then the watchdog cannot safeguard
the module loading process to that point :-P

So we just call these from compile-in code.

I actually have Jonas' watchdog driver ready as well if you want
me to submit it on top of this patch set so you get the whole
picture.

Yours,
Linus Walleij
