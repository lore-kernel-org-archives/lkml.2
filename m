Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751168Ab1JIFjX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 01:39:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43571 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab1JIFjW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 01:39:22 -0400
MIME-Version: 1.0
In-Reply-To: <3712698.4MAZQPafzW@wuerfel>
References: <1314843744-2910-1-git-send-email-Baohua.Song@csr.com>
 <CACRpkdbb_5EZHT3=SNePbW-=NYjLSLzJgjEdEaBV7X=s6gxydw@mail.gmail.com>
 <CAGsJ_4xpYMzHGi09jt2Y9xCocYJ0iHYRfdvwCzcH65uaF2sP0g@mail.gmail.com> <3712698.4MAZQPafzW@wuerfel>
From: Barry Song <21cnbao@gmail.com>
Date: Sun, 9 Oct 2011 13:39:01 +0800
Message-ID: <CAGsJ_4z=ME6krkhmcYnrNdJqpifJxoNvDCsFpKqVt_-EdKhWiw@mail.gmail.com>
Subject: Re: [PATCH v2] pinmux: add a driver for the CSR SiRFprimaII pinmux
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@nvidia.com>, linus.walleij@stericsson.com,
        linux-kernel@vger.kernel.org, workgroup.linux@csr.com,
        Rongjun Ying <rongjun.ying@csr.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/8 Arnd Bergmann <arnd@arndb.de>:
> On Saturday 08 October 2011 19:58:23 Barry Song wrote:
>> > You can probably simplify this and other things with
>> > preprocessor macros if you want to, like:
>> >
>> > #define SIRF_FUNC_ENTRY(a) \
>> > { .name = "##a##", .pins = ##a##_pins, .num_pins =
>> > ARRAY_SIZE(##a##_pins), .padmux = &##a##_padmux }
>> >
>> > Then just:
>> >
>> > static const struct sirfsoc_pinmux_func sirfsoc_pinmux_funcs[] = {
>> >     SIRF_FUNC_ENTRY(lcd_16bits),
>> >
>> >
>> > The macro syntax is probably wrong, the preprocessor always
>> > craze me out, but you get the idea.
>>
>>  :-)  .name = "##a##"  should be changed to .name = #a
>>
>> #name will convert name into a string "name"
>>
>
> Better don't use string concatenation at all if you can avoid it.
>
> A generic macro like
>
> #define SIRF_PINMUX(_name, _pins, _padmux) \
>        { .name = (_name), .pins = (_pins), \
>          .num_pins = ARRAY_SIZE(_pins), padmux = (_padmux), }
>
> is both very easy to understand for someone reading it casually and
> lets you actually grep for where the identifiers are being used.
>
>> static const struct sirfsoc_pinmux_func sirfsoc_pinmux_funcs[] = {
>>     SIRF_FUNC_ENTRY(lcd_16bits),
>
> for the first time, you have no clue what that does, but
>
> static const struct sirfsoc_pinmux_func sirfsoc_pinmux_funcs[] = {
>        SIRF_PINMUX("lcd_16bits", lcd_16bits_pins, &lcd_16bits_padmux),
>        ...
> };
>
> Makes it very clear what you are referencing here and needs no extra lines.

well. thanks! i'll send prima2 pinmux v3 rebased on Linus W's v9 and
with this change too.

>
>        Arnd
>
-barry
