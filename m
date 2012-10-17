Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660Ab2JQSxE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 14:53:04 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47371 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757627Ab2JQSxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 14:53:03 -0400
MIME-Version: 1.0
In-Reply-To: <201210171338.01011.arnd@arndb.de>
References: <1350306959-5843-1-git-send-email-lee.jones@linaro.org>
	<201210151420.29930.arnd@arndb.de>
	<20121015160740.GC7662@gmail.com>
	<201210171338.01011.arnd@arndb.de>
Date: Wed, 17 Oct 2012 20:53:00 +0200
Message-ID: <CAPDyKFq6YfpjCs-3Wh=RPGc-4ukUinuhVWaZ0=+WCLsc0JBWbQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] mmc: core: Support all MMC capabilities when booting
 from Device Tree
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        Chris Ball <cjb@laptop.org>, Russell King <linux@arm.linux.org.uk>,
        linux-mmc@vger.kernel.org, Ulf Hansson <ulf.hansson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 October 2012 15:38, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 15 October 2012, Lee Jones wrote:
>> > and so on. What are you actually missing in the properties that
>> > are already there?
>>
>> MMC_CAP_ERASE
>
> This one seems to be set unconditionally on some controllers but
> not on others. Why would it need to be configurable?
>
>> MMC_CAP_UHS_SDR12
>> MMC_CAP_UHS_SDR25
>> MMC_CAP_UHS_DDR50
>
> Could this be derived from max-frequency?

No, this is likely depending on what the hw controller supports. Not
connected to the freq.
UHS also means 1.8 V I/O voltage.

>
>> MMC_CAP_1_8V_DDR
>
> Right, I suppose we need this. Should we have a minimum and maximum
> voltage added to the common properties for this?
>
>> MMC_CAP2_DETECT_ON_ERR
>> MMC_CAP2_NO_SLEEP_CMD
>
> I don't see these ones being set anywhere, but they were both
> added by Ulf. Maybe he can comment on if or why they are needed
> in devicetree, rather than being set by the driver unconditionally
> or for specific versions of the host controller.

>From ux500 perspective there are patches not been up-streamed yet
which are using these host caps, for whatever it is worth for you to
know and consider.

Actually, I think quite a few of the host caps in mmc could be debated
whether those should exist at all.
Some are directly mapped to what the host controller hw support, some
are purely what the host driver (sw) support, but then there are
others kind of "mmc/sd/sdio software support configuration" which are
kind of strange host caps to me. For example MMC_CAP2_DETECT_ON_ERR
which I invented. :-). I think it especially these "software support
configuration" caps that might be causing this dt issues.

Would be very interesting to hear if someone is sharing my thoughts
around the host caps. Or if I am totally wrong here.

Kind regards
Ulf Hansson
