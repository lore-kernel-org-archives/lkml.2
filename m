Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab1IALft (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 07:35:49 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42531 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab1IALfs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 07:35:48 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbb_5EZHT3=SNePbW-=NYjLSLzJgjEdEaBV7X=s6gxydw@mail.gmail.com>
References: <1314843744-2910-1-git-send-email-Baohua.Song@csr.com>
	<CACRpkdbb_5EZHT3=SNePbW-=NYjLSLzJgjEdEaBV7X=s6gxydw@mail.gmail.com>
Date: Thu, 1 Sep 2011 19:35:47 +0800
Message-ID: <CAGsJ_4yeudp+5J-D6RQ4G4HP9fKjfqLrPuu-OQezQcqBF=ycXw@mail.gmail.com>
Subject: Re: [PATCH v2] pinmux: add a driver for the CSR SiRFprimaII pinmux
From: Barry Song <21cnbao@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Barry Song <Baohua.Song@csr.com>, Stephen Warren <swarren@nvidia.com>,
        linus.walleij@stericsson.com, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, Rongjun Ying <rongjun.ying@csr.com>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/1 Linus Walleij <linus.walleij@linaro.org>
>
> On Thu, Sep 1, 2011 at 4:22 AM, Barry Song <Baohua.Song@csr.com> wrote:
>
> >  -v2:
> >  rebase to Linus W's v5 patch(v5 is still in discussion);
> >  add complete pinmux list table;
> >  add gpio ranges;
> >  replace mask magic number by bitops;
> >  rename upmx to spmx
>
> No further comments on this, but now I went in and rewrote
> pinmuxing a bit so that pin groups are a separate concept from
> pinmux (which just refers to a group). Please have a look at
> the U300 driver and see if you can accomodate the changes.
>
> Sorry for the flow of respins but I'm really liking the stuff that
> has come out as a result of Stephen's feedback. Having
> separate groups and functions may look a bit crufty on
> simple pinmuxes but I'm pretty convinced it'll be a win
> for the subsystem when moving to more complex drivers.
>

never mind. it is not too difficult for me to rebase the patch. and
i'm happy to see the great job of you and Stephen.

> > +static const struct sirfsoc_pinmux_func sirfsoc_pinmux_funcs[] = {
> > +       {
> > +               .name = "lcd_16bits",
> > +               .pins = lcd_16bits_pins,
> > +               .num_pins = ARRAY_SIZE(lcd_16bits_pins),
> > +               .padmux = &lcd_16bits_padmux,
> > +       }, {
> > +               .name = "lcd_18bits",
> > +               .pins = lcd_18bits_pins,
> > +               .num_pins = ARRAY_SIZE(lcd_18bits_pins),
> > +               .padmux = &lcd_18bits_padmux,
> > +       }, {
>
> You can probably simplify this and other things with
> preprocessor macros if you want to, like:
>
> #define SIRF_FUNC_ENTRY(a) \
> { .name = "##a##", .pins = ##a##_pins, .num_pins =
> ARRAY_SIZE(##a##_pins), .padmux = &##a##_padmux }
>
> Then just:
>
> static const struct sirfsoc_pinmux_func sirfsoc_pinmux_funcs[] = {
>    SIRF_FUNC_ENTRY(lcd_16bits),
>
>
> The macro syntax is probably wrong, the preprocessor always
> craze me out, but you get the idea.

i think it is a good idea.

>
> Thanks,
> Linus Walleij
>
Thanks
barry
