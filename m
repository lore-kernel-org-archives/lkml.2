Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751723Ab0L2Jbx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 04:31:53 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55351 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab0L2Jbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 04:31:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=m2+N9h+WxhMxa5W9Zsj7LNSW5a0J77oVzyss9Ug9zYrpz7yCOiE93TPvfOwGzCrg0s
         /DVxhnYC0X/U0DoJvnJIiw+bYl4zTlVF9de+94Y5SG3WTULq+t1wcIuTOMAcvC3zg7nD
         3qv+vuxSu5mpOOtXtW9WhL4ZN9oyoRJ1VriY8=
MIME-Version: 1.0
In-Reply-To: <CE761E84DADF2947A4AF22FB8D97A47331E86F6E@shsmsx501.ccr.corp.intel.com>
References: <1293023621-3077-1-git-send-email-tardyp@gmail.com>
	<41EFD7A46E18724CAB128DAD00733480193D2AE61C@shsmsx502.ccr.corp.intel.com>
	<AANLkTinYWODS785AefQ7hV+urPkAn1+En-fZEaFQygLG@mail.gmail.com>
	<CE761E84DADF2947A4AF22FB8D97A47331E86F6E@shsmsx501.ccr.corp.intel.com>
Date: Wed, 29 Dec 2010 10:31:50 +0100
Message-ID: <AANLkTimB7h0ZxvSOt2dUkO90RxE2c3Bu3CRqpasgzxw=@mail.gmail.com>
Subject: Re: [RFC] sdhci: use ios->clock to know when sdhci is idle
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: "Gao, Yunpeng" <yunpeng.gao@intel.com>
Cc: Pierre Tardy <tardyp@gmail.com>, "Yuan, Hang" <hang.yuan@intel.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Takashi Iwai <tiwai@suse.de>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Ohad Ben-Cohen <ohad@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/29 Gao, Yunpeng <yunpeng.gao@intel.com>:

> So, why we have to move to the 'aggressive clock gating framework'?

The aggressive clock gating makes more sense since the different
drivers will know better how to handle the gating. ios with f=0 can
be interpreted differently. Else every driver has to register
runtime PM hooks for this, which is less elegant.

A better question is why the clock gating does not use runtime
PM abstractions.

The hysteresis (timeout after inactivity, in the MMC spec >= 8 MCLK
cycles) can possibly be handled by refactoring the runtime PM
framework, someone offered to look at this later actually.

> Also, I noticed that in the current 'aggressive clock gating
> framework' patch, the clock gating of SDIO card has been
> disabled (please reference code and comments of function
> mmc_host_may_gate_card() in that patch).

We discussed different approaches to this, from marking an
SDIO slot as suspendable by using platform data, or whitelisting
the SDIO cards that can handle clock gating.

It was decided to keep SDIO cards out of it until we have this
infrastructure in place. So now you will have the opportunity
to fix this!

Not all SDIO cards will work properly if you try to gate them
so we need a mechanism to selectively do this.
Any suggestions?

Yours,
Linus Walleij
