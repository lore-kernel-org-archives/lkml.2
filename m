Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934270Ab1JaKt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 06:49:27 -0400
Received: from mail.lemote.com ([222.92.8.141]:34993 "EHLO lemote.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932676Ab1JaKt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 06:49:26 -0400
MIME-Version: 1.0
In-Reply-To: <CAM2zO=CodQLE05ZNOOba3jv_qJ5XuZj3yrnS0aHCOj+cp_24Xw@mail.gmail.com>
References: <CAGXxSxXmgzxN361Cko1fY_+oWwfgjXLhS61gtvqB8YYXHXZVyw@mail.gmail.com>
 <CAM2zO=CodQLE05ZNOOba3jv_qJ5XuZj3yrnS0aHCOj+cp_24Xw@mail.gmail.com>
From: Chen Jie <chenj@lemote.com>
Date: Mon, 31 Oct 2011 18:48:45 +0800
Message-ID: <CAGXxSxUHGN99hXK8K5k9ayVfMenAWAbWVpqkotix_JyUbPCU+w@mail.gmail.com>
Subject: Re: [MIPS]clocks_calc_mult_shift() may gen a too big mult value
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-mips@linux-mips.org, LKML <linux-kernel@vger.kernel.org>,
        johnstul@us.ibm.com, tglx@linutronix.de, yanhua <yanh@lemote.com>,
        =?UTF-8?B?6aG55a6H?= <xiangy@lemote.com>, zhangfx <zhangfx@lemote.com>,
        =?UTF-8?B?5a2Z5rW35YuH?= <sunhy@lemote.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/10/31 Yong Zhang <yong.zhang0@gmail.com>:
> On Mon, Oct 31, 2011 at 5:00 PM, Chen Jie <chenj@lemote.com> wrote:
>> Hi all,
>>
>> On MIPS, with maxsec=4, clocks_calc_mult_shift() may generate a very
>> big mult, which may easily cause timekeeper.mult overflow within
>> timekeeping jobs.
>
> Hmmm, why not use clocksource_register_hz()/clocksource_register_khz()
> instead? it's more convenient.

Thanks for the suggestion. And sorry for I didn't notice the upstream
code has already hooked to clocksource_register_hz() in csrc-r4k.c
(We're using r4000 clock source)

I'm afraid this still doesn't fix my case. Through
clocksource_register_hz()->__clocksource_register_scale()->__clocksource_updatefreq_scale,
I got a calculated maxsec = (0xffffffff - (0xffffffff>>5))/250000500 =
16        # assume mips_hpt_frequency=250000500

With this maxsec, I got a mult of 0xffffde72, still too big.



Regards,
-- Chen Jie
