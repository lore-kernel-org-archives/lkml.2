Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1JaNHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 09:07:04 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:34097 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776Ab1JaNHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 09:07:01 -0400
Message-ID: <1320066197.2266.11.camel@js-netbook>
Subject: Re: [MIPS]clocks_calc_mult_shift() may gen a too big mult value
From: John Stultz <johnstul@us.ibm.com>
To: Chen Jie <chenj@lemote.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>, linux-mips@linux-mips.org,
        LKML <linux-kernel@vger.kernel.org>, tglx@linutronix.de,
        yanhua <yanh@lemote.com>,
        =?UTF-8?Q?=E9=A1=B9=E5=AE=87?= <xiangy@lemote.com>,
        zhangfx <zhangfx@lemote.com>,
        =?UTF-8?Q?=E5=AD=99=E6=B5=B7=E5=8B=87?= <sunhy@lemote.com>
Date: Mon, 31 Oct 2011 09:03:17 -0400
In-Reply-To: <CAGXxSxUHGN99hXK8K5k9ayVfMenAWAbWVpqkotix_JyUbPCU+w@mail.gmail.com>
References: <CAGXxSxXmgzxN361Cko1fY_+oWwfgjXLhS61gtvqB8YYXHXZVyw@mail.gmail.com>
	 <CAM2zO=CodQLE05ZNOOba3jv_qJ5XuZj3yrnS0aHCOj+cp_24Xw@mail.gmail.com>
	 <CAGXxSxUHGN99hXK8K5k9ayVfMenAWAbWVpqkotix_JyUbPCU+w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11103113-1780-0000-0000-00000095EDE7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-31 at 18:48 +0800, Chen Jie wrote:
> Hi,
> 
> 2011/10/31 Yong Zhang <yong.zhang0@gmail.com>:
> > On Mon, Oct 31, 2011 at 5:00 PM, Chen Jie <chenj@lemote.com> wrote:
> >> Hi all,
> >>
> >> On MIPS, with maxsec=4, clocks_calc_mult_shift() may generate a very
> >> big mult, which may easily cause timekeeper.mult overflow within
> >> timekeeping jobs.
> >
> > Hmmm, why not use clocksource_register_hz()/clocksource_register_khz()
> > instead? it's more convenient.
> 
> Thanks for the suggestion. And sorry for I didn't notice the upstream
> code has already hooked to clocksource_register_hz() in csrc-r4k.c
> (We're using r4000 clock source)
> 
> I'm afraid this still doesn't fix my case. Through
> clocksource_register_hz()->__clocksource_register_scale()->__clocksource_updatefreq_scale,
> I got a calculated maxsec = (0xffffffff - (0xffffffff>>5))/250000500 =
> 16        # assume mips_hpt_frequency=250000500
> 
> With this maxsec, I got a mult of 0xffffde72, still too big.

Hrmm. Yong Zang is right to suggest clocksource_register_hz(), as the
intention of that code is to try to avoid these sorts of issues.

What is the corresponding shift value you're getting for the value
above?

Could you annotate clocks_calc_mult_shift() a little bit to see where
things might be going wrong?

thanks
-john

