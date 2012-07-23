Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754694Ab2GWSzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 14:55:25 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:53687 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab2GWSzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 14:55:23 -0400
MIME-Version: 1.0
In-Reply-To: <1342567672-29071-1-git-send-email-ccross@android.com>
References: <1342567672-29071-1-git-send-email-ccross@android.com>
Date: Mon, 23 Jul 2012 20:55:22 +0200
Message-ID: <CACRpkdaHdCvx1HJNDsyJSZAN--sF+4-V1TbzXZL1v+7Asoe_oA@mail.gmail.com>
Subject: Re: [RFC] ARM: sched_clock: update epoch_cyc on resume
From: Linus Walleij <linus.walleij@linaro.org>
To: Colin Cross <ccross@android.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Krzysztof Halasa <khc@pm.waw.pl>, Nicolas Pitre <nico@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 1:27 AM, Colin Cross <ccross@android.com> wrote:

> This will have a side effect of causing SoCs that have clocks that
> continue to count in suspend to appear to stop counting, reporting the
> same sched_clock() value before and after suspend.

So for our platform (ux500) that has a sched clock that *does*
continue to run during suspend,
drivers/clocksource/clksrc-dbx500-prcmu.c
how do we opt out of this behaviour?

Since sched_clock is used for the debug prints, if we have a
crash immediately after resume() it will appear to be at resume
time in the log which kinda sucks. :-(

Isn't the proper way to do this either:

- Assign suspend/resume hooks to the sched_clock code in the
  platform and let the code that reads the hardware clock deal with
  this

Or

- If it absolutely needs to be in the core code, also have a bool
  field indicating whether the clock is going to die during suspend
  and add new registration functions for setting that sched_clock
  type, e.g. setup_sched_clock_nonsuspendable()

Yours,
Linus Walleij
