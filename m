Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489Ab1JaJUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 05:20:16 -0400
Received: from mail-wy0-f180.google.com ([74.125.82.180]:39661 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260Ab1JaJUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 05:20:15 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXxSxXmgzxN361Cko1fY_+oWwfgjXLhS61gtvqB8YYXHXZVyw@mail.gmail.com>
References: <CAGXxSxXmgzxN361Cko1fY_+oWwfgjXLhS61gtvqB8YYXHXZVyw@mail.gmail.com>
Date: Mon, 31 Oct 2011 17:20:13 +0800
Message-ID: <CAM2zO=CodQLE05ZNOOba3jv_qJ5XuZj3yrnS0aHCOj+cp_24Xw@mail.gmail.com>
Subject: Re: [MIPS]clocks_calc_mult_shift() may gen a too big mult value
From: Yong Zhang <yong.zhang0@gmail.com>
To: Chen Jie <chenj@lemote.com>
Cc: linux-mips@linux-mips.org, LKML <linux-kernel@vger.kernel.org>,
        johnstul@us.ibm.com, tglx@linutronix.de, yanhua <yanh@lemote.com>,
        =?UTF-8?B?6aG55a6H?= <xiangy@lemote.com>, zhangfx <zhangfx@lemote.com>,
        =?UTF-8?B?5a2Z5rW35YuH?= <sunhy@lemote.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 5:00 PM, Chen Jie <chenj@lemote.com> wrote:
> Hi all,
>
> On MIPS, with maxsec=4, clocks_calc_mult_shift() may generate a very
> big mult, which may easily cause timekeeper.mult overflow within
> timekeeping jobs.

Hmmm, why not use clocksource_register_hz()/clocksource_register_khz()
instead? it's more convenient.

Thanks,
Yong

>
> e.g. when clock freq was 250000500(i.e. mips_hpt_frequency=250000500,
> and the CPU Freq will be 250000500*2=500001000), mult will be
> 0xffffde72
>
> Attachment is a script that calculates mult values for CPU Freq
> between 400050000 and 500050000, with 1KHz step. It outputs mult
> values greater than 0xf0000000:
> CPU Freq:500001000, mult:0xffffde72, shift:30
> CPU Freq:500002000, mult:0xffffbce4, shift:30
> CPU Freq:500003000, mult:0xffff9b56, shift:30
> CPU Freq:500004000, mult:0xffff79c9, shift:30
> ...
>
> The peak value appears around CPU_freq=500001000.
>
> To avoid this, it may need:
> 1. Supply a bigger maxsec value?
> 2. In clocks_calc_mult_shift(), pick next mult/shift pair if mult is
> too big? Then maxsec will not be strictly obeyed.
> 3. Change timekeeper.mult to u64?
> 4. ...
>
> Any idea?
>
>
>
> --
> Regards,
> - Chen Jie
>



-- 
Only stand for myself
