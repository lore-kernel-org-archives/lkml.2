Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752997Ab0FWKKY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:10:24 -0400
Received: from www.tglx.de ([62.245.132.106]:43844 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552Ab0FWKKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:10:21 -0400
From: John Ogness <john.ogness@linutronix.de>
To: Ivo Clarysse <ivo.clarysse@gmail.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>,
       Sascha Hauer <kernel@pengutronix.de>,
       linux-arm-kernel@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 4/5] mtd: mxc_nand fixups
References: <804oh0b7gx.fsf@merkur.tec.linutronix.de>
	<20100618205401.GA12115@pengutronix.de>
	<80sk4ivkga.fsf@merkur.tec.linutronix.de>
	<AANLkTimA7Rbm_nHpVYpEPqaPCjrOse9s8YyiInWlhfEK@mail.gmail.com>
	<80tyoyhxey.fsf_-_@merkur.tec.linutronix.de>
	<AANLkTikRj_dMkKLyFhW78yld9jIYAIFncfPaPAF8WqUY@mail.gmail.com>
	<80iq5bqd07.fsf_-_@merkur.tec.linutronix.de>
	<AANLkTimJKNEwOoKldq4a4_ufxNY6IY7r6tAfAM055hlW@mail.gmail.com>
	<80vd9ab0d2.fsf@merkur.tec.linutronix.de>
	<AANLkTinVaXjCneg-XpxB7YNlmGOwQFTnm5RUcetPdToI@mail.gmail.com>
Date: Wed, 23 Jun 2010 12:10:08 +0200
In-Reply-To: <AANLkTinVaXjCneg-XpxB7YNlmGOwQFTnm5RUcetPdToI@mail.gmail.com>
	(Ivo Clarysse's message of "Wed, 23 Jun 2010 11:23:55 +0200")
Message-ID: <80lja6awlb.fsf@merkur.tec.linutronix.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-06-23, Ivo Clarysse <ivo.clarysse@gmail.com> wrote:
> But is it OK to use a regular (non-volatile) variable to communicate
> between interrupt context and the non-interrupt context ?

In this case, yes.

> My original patch for i.MX21 used completions instead:
>
> http://lists.infradead.org/pipermail/linux-arm-kernel/2010-April/012694.html

Ah. It seems you've been through all this before. I wish I had noticed
that thread before. I will need to check more carefully in the future.

Yes, your original patch achieves the exact same thing. Whether we use
wait_event() with a flag or wait_completion() really is the same
thing. So I guess Sascha can decide what we should do there.

What I like about your original patch is that only the i.MX21 has the
cost of constantly enabling/disabling the irq line. It adds 5
cpu_is_mx21() blocks to the code, but will lead to less work for the CPU
on non-i.MX21 boards.

John Ogness
