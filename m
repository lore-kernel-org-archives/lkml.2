Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703Ab0HLV1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 17:27:34 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58201 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753882Ab0HLV1d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 17:27:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=tiI3oMcuKmjnXSXgI8gu90xP5xZhC7wDGbAVJP8h5mVgZxSFrSA5ienYANiCEbsTA0
         S247q0pSwWAwEzWmvbcFxvjZygy1dXgoqhfxWQGTTKse30whrRpBx0XtyypGn+iaX/4+
         31ZtvaA9HAqTULL84taGI5zjZVeCCVW3uiY0w=
MIME-Version: 1.0
In-Reply-To: <201008111659.o7BGxn4g029524@hera.kernel.org>
References: <201008111659.o7BGxn4g029524@hera.kernel.org>
Date: Thu, 12 Aug 2010 23:27:32 +0200
X-Google-Sender-Auth: exCa-xoUCLjgph_4nPNvIuYByOE
Message-ID: <AANLkTin7+UPYJ5tsyrbUhxcEfbHLMVJQOSrV1_3zQ0V3@mail.gmail.com>
Subject: Re: rtc/m41t80: use rtc_valid_tm() to check returned tm
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Wan ZongShun <mcuos.com@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 18:59, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/b485fe5ea1008db02abff9ef15be4f31b52df4f7

>    rtc/m41t80: use rtc_valid_tm() to check returned tm
>
>    Use rtc_valid_tm() to check returned struct rtc_time *tm - it can avoid
>    returning wrong tm value.

> diff --git a/drivers/rtc/rtc-m41t80.c b/drivers/rtc/rtc-m41t80.c
> index 6dc4e62..66377f3 100644
> --- a/drivers/rtc/rtc-m41t80.c
> +++ b/drivers/rtc/rtc-m41t80.c

> @@ -364,7 +364,7 @@ static int m41t80_rtc_read_alarm(struct device *dev, struct rtc_wkalrm *t)
>        t->time.tm_isdst = -1;
>        t->enabled = !!(reg[M41T80_REG_ALARM_MON] & M41T80_ALMON_AFE);
>        t->pending = !!(reg[M41T80_REG_FLAGS] & M41T80_FLAGS_AF);
> -       return 0;
> +       return rtc_valid_tm(t);

warning: passing argument 1 of ‘rtc_valid_tm’ from incompatible pointer type

`t' is of type `struct rtc_wkalrm *', not `struct rtc_time *'.
Probably the intention was:

        return rtc_valid_tm(&t->time);

??

>  }

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
