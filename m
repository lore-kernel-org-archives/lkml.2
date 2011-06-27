Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab1F0GCI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 02:02:08 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56876 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756677Ab1F0GAr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 02:00:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=d7qPdWrn339JT4CsX8BSdyiWbBykBEEgf8pnZ9za7OEQV2VNCPfiW3zVInS6vTqBPg
         dm/gGz2rAWXBr3sMY1HTGHbm1MYug7mVPIgYbty4iemA/vIDmsCjL5Y3Y5SSxjdB4LvL
         v7OPvPdBSh6IC2mlnxkkYxZD7fCN3pX2DlqO8=
MIME-Version: 1.0
In-Reply-To: <BANLkTinCWcjNOR6uoGno1riRb+LBZLJ+Gg@mail.gmail.com>
References: <1309039804-659-1-git-send-email-bryan.wu@canonical.com>
 <1309039804-659-3-git-send-email-bryan.wu@canonical.com> <BANLkTinCWcjNOR6uoGno1riRb+LBZLJ+Gg@mail.gmail.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Mon, 27 Jun 2011 14:00:25 +0800
X-Google-Sender-Auth: mNMWM6C5iR-CRWhQF1viKfY2-wM
Message-ID: <BANLkTimDfs0SG7ZYAHcMqMSV1N7gheo2Rg@mail.gmail.com>
Subject: Re: [PATCH 2/4] ARM: use new LEDS CPU trigger stub to replace old one
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, rpurdie@rpsys.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 26, 2011 at 7:08 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> Hi Bryan, notice that this:
>
> 2011/6/26 Bryan Wu <bryan.wu@canonical.com>:
>
>> -               leds_event(led_idle_start);
>> +               ledtrig_cpu(CPU_LED_IDLE_START);
> (...)
>> -               leds_event(led_idle_end);
>> +               ledtrig_cpu(CPU_LED_IDLE_END);
>
> That breaks all the old users of the CPU activity LEDs.
>
> I only fixed up RealView and Versatile!
>
> grep -r led_idle_start arch/arm/
>
> Gives you a hint that you also have to retire custom LEDs from
> orion, omap, at91, footbridge, sa1100, ks8695, shark, clps711x,
> pxa and omap1.
>
> You have to write a patch each an every one of these, and
> since they all are already using that mechanism actively
> you need to select the LED trigger in their Kconfig.
>

No problem, I will clean them up soon.

Thanks,
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.138-1617-6545 Mobile
Ubuntu Kernel Team
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
