Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab1FZLII (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 07:08:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50987 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab1FZLIE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 07:08:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=mSLtHPnxfph31e4fxZUcy5ZKJ+yM0GR2g8vrRHx2MuuCSrU0r7uM33zkNjYCyIFOW+
         /SsOzGwhqJGynTN+4AnDdVSX1HMWS1Lgc/8koJnybonBPnvEMKGQ2x301rcHwLbP88h0
         6Wv2Uw2akhVpf1uMC22PgGa3KZDKz16h9CFDg=
MIME-Version: 1.0
In-Reply-To: <1309039804-659-3-git-send-email-bryan.wu@canonical.com>
References: <1309039804-659-1-git-send-email-bryan.wu@canonical.com>
	<1309039804-659-3-git-send-email-bryan.wu@canonical.com>
Date: Sun, 26 Jun 2011 13:08:01 +0200
X-Google-Sender-Auth: NC24SC3aBBJcC4FBNGoNjZQQQ_4
Message-ID: <BANLkTinCWcjNOR6uoGno1riRb+LBZLJ+Gg@mail.gmail.com>
Subject: Re: [PATCH 2/4] ARM: use new LEDS CPU trigger stub to replace old one
From: Linus Walleij <linus.walleij@linaro.org>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux-arm-kernel@lists.infradead.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan, notice that this:

2011/6/26 Bryan Wu <bryan.wu@canonical.com>:

> -               leds_event(led_idle_start);
> +               ledtrig_cpu(CPU_LED_IDLE_START);
(...)
> -               leds_event(led_idle_end);
> +               ledtrig_cpu(CPU_LED_IDLE_END);

That breaks all the old users of the CPU activity LEDs.

I only fixed up RealView and Versatile!

grep -r led_idle_start arch/arm/

Gives you a hint that you also have to retire custom LEDs from
orion, omap, at91, footbridge, sa1100, ks8695, shark, clps711x,
pxa and omap1.

You have to write a patch each an every one of these, and
since they all are already using that mechanism actively
you need to select the LED trigger in their Kconfig.

Thanks,
Linus Walleij
