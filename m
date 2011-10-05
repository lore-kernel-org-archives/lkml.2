Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935122Ab1JEQ5P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:57:15 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:59154 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935068Ab1JEQ5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:57:11 -0400
MIME-Version: 1.0
In-Reply-To: <20111003155331.GR4118@sortiz-mobl>
References: <1313137760-31015-1-git-send-email-linus.walleij@stericsson.com>
	<20111003155331.GR4118@sortiz-mobl>
Date: Wed, 5 Oct 2011 18:57:11 +0200
Message-ID: <CACRpkdZg8rLr_2=92MRMB5BC4TWWHqXGigD6j7m6_R-wX8FW0w@mail.gmail.com>
Subject: Re: [PATCH 13/23] mfd/db5500-prcmu: update mailbox handling
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>,
        Vijaya Kumar Kilari <vijay.kilari@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 3, 2011 at 5:53 PM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> On Fri, Aug 12, 2011 at 10:29:20AM +0200, Linus Walleij wrote:
>> From: Shreshtha Kumar Sahu <shreshthakumar.sahu@stericsson.com>
>>
>> This updates the mailbox handling to be more robust and
>> adds basic infrastructure for event (IRQ) handling.
>
> This patch and the next one (#14) adds 500 lines of code but I have the
> feeling a lot of it could be shared between 8500 and 5500. What are your plans
> for that ?

I've tried to locate similarities, but it's quite hard. The drivers reflect
the fact that they are talking to software, which is reengineered for
each SoC produced.

So for example if I take a common function like
u*500_prcmu_set_power_state() you can see that they write very
different things into very different mailboxes.

I do look for similarities and try to find some pattern, and I also
think some vtable scheme for switching between the implementations
could be good.

If you think there is too much functional growth and too little
consolidation from patch 13 onwards (i.e. the DB5500 stuff) then
feel free to stop applying at this point.

I think the two fixup patches I just sent out can apply on top of
patch 12 or so anyway, maybe with some patch -p1 <
to avoid patching the clock control in db5500-prcmu.c.

Yours,
Linus Walleij
