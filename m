Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756061Ab2CEAP3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 19:15:29 -0500
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:42532 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753867Ab2CEAP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 19:15:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mturquette@ti.com designates 10.14.39.130 as permitted sender) smtp.mail=mturquette@ti.com
MIME-Version: 1.0
In-Reply-To: <20120304143502.GC11546@lunn.ch>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
 <1330763341-3437-5-git-send-email-mturquette@linaro.org> <20120304143502.GC11546@lunn.ch>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Sun, 4 Mar 2012 16:15:03 -0800
Message-ID: <CAJOA=zM9Qo=V1He=HfL-6KaFV_Yai=KyC5hbca5iQ3uMO_pZzQ@mail.gmail.com>
Subject: Re: [PATCH v5 4/4] clk: basic clock hardware types
To: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>, patches@linaro.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Paul Walmsley <paul@pwsan.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jamie Iles <jamie@jamieiles.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q250FYKY028648

On Sun, Mar 4, 2012 at 6:35 AM, Andrew Lunn <andrew@lunn.ch> wrote:
>> +#define DEFINE_CLK_GATE(_name, _parent_name, _parent_ptr,    \
>> +                             _flags, _reg, _bit_idx,         \
>> +                             _gate_flags, _lock)             \
>> +     static struct clk _name;                                \
>> +     static char *_name##_parent_names[] = {                 \
>> +             _parent_name,                                   \
>> +     };                                                      \
>> +     static struct clk *_name##_parents[] = {                \
>> +             _parent_ptr,                                    \
>> +     };                                                      \
>> +     static struct clk_gate _name##_hw = {                   \
>> +             .hw = {                                         \
>> +                     .clk = &_name,                          \
>> +             },                                              \
>> +             .reg = _reg,                                    \
>> +             .bit_idx = _bit_idx,                            \
>> +             .flags = _gate_flags                            \
>> +             .lock = _lock,                                  \
>> +     };                                                      \
>> +     static struct clk _name = {                             \
>> +             .name = #_name,                                 \
>> +             .ops = &clk_gate_ops,                           \
>> +             .hw = &_name##_hw.hw,                           \
>> +             .parent_names = _name##_parent_names,           \
>> +             .num_parents =                                  \
>> +                     ARRAY_SIZE(_name##parent_names),        \
>
> Hi Mike
>
> This should be _name##_parent_names, i.e. you are missing a _.
>
> With this and the previous change, i get something which at least
> compiles...

The gate clock is the only type of the basic clocks that I do not
(currently) use in my OMAP port and it's test coverage has suffered as
a result.  My bad.

Thanks for the review and the patch in the separate thread.  I'll take
the changes in.

Regards,
Mike

>
>        Andrew
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
