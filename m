Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab1HWWRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 18:17:15 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52474 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755947Ab1HWWRE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 18:17:04 -0400
MIME-Version: 1.0
In-Reply-To: <20110823221314.GL3895@n2100.arm.linux.org.uk>
References: <20110823151936.GM9232@opensource.wolfsonmicro.com>
	<201108232351.55432.rjw@sisk.pl>
	<CAOS58YNUSn2eVLDLzqKmrtL7M5tSetkhZ1ODecLK54NSDnZVAA@mail.gmail.com>
	<20110823220056.GK3895@n2100.arm.linux.org.uk>
	<CAOS58YNuCbaOsWBfmjSUsXsArZ5ng6c0B30yswFbRAWkho6L6Q@mail.gmail.com>
	<20110823221314.GL3895@n2100.arm.linux.org.uk>
Date: Wed, 24 Aug 2011 00:17:03 +0200
X-Google-Sender-Auth: t0oO7XUPYSmCvE41EW72zPnwFys
Message-ID: <CAOS58YNtQEuke=Ko9J2oNGMECjabzxj=Nrg1o64X1JC3YRmJuw@mail.gmail.com>
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
From: Tejun Heo <tj@kernel.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 12:13 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> Thereby entirely preventing threads from being frozen?  You're asking
> me to effectively disable suspend/resume on an architecture where it's
> heavily used.  That's not a good idea, and would be an out-right
> regression.

Eh? So, it's supposed to enter refrigerator with IRQ disabled? Then,
moving might_sleep() inside refrigerator() doesn't help either, does
it? Then we should be doing is,

if (freezing() && IRQ disabled) {
      bust on IRQ;
      try_to_freeze();
      replug IRQ;
}

But, that can't be right. The current code isn't triggering warning
from scheduler code, right? If the above is the case, it should be
triggering that. What am I missing?

-- 
tejun
