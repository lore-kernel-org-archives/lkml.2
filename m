Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab1HQH41 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 03:56:27 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48779 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab1HQH4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 03:56:24 -0400
MIME-Version: 1.0
In-Reply-To: <0dc3a92a831137a432482adc04a9c68815c137b7.1313400777.git.mika.westerberg@linux.intel.com>
References: <e13e177c732ee8ad2d6fe389c9bac21877f60c59.1313400777.git.mika.westerberg@linux.intel.com>
	<0dc3a92a831137a432482adc04a9c68815c137b7.1313400777.git.mika.westerberg@linux.intel.com>
Date: Wed, 17 Aug 2011 09:56:23 +0200
Message-ID: <CACRpkdbVOKoHi8AukX=qwHcp+oFEvYmXRNQ7xBg6hfX2AYbkgg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mmc: prevent aggressive clock gating to race with ios updates
From: Linus Walleij <linus.walleij@linaro.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org, cjb@laptop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 12:03 PM, Mika Westerberg
<mika.westerberg@linux.intel.com> wrote:

> We have seen at least two different races when clock gating kicks in in a
> middle of ios structure update.
>
> First one happens when ios->clock is changed outside of aggressive clock
> gating framework, for example via mmc_set_clock(). The race might happen
> when we run following code:

Patch looks entirely sane if you deal with my considerations
in [1/2] replacing mmc_host_clk_gate_[disable|enable] with
plain mmc_host_clk_[ungate|gate]() or renamed versions
of these respectively.

Thanks,
Linus Walleij
