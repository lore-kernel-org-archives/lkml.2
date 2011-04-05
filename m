Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100Ab1DEC3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 22:29:49 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:56586 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751799Ab1DEC3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 22:29:48 -0400
MIME-Version: 1.0
In-Reply-To: <4D981EAB.8070209@codeaurora.org>
References: <1301602523-9906-1-git-send-email-omar.ramirez@ti.com>
	<BANLkTimtAcPLmcFKoHkCtWcJipy+rSSP+A@mail.gmail.com>
	<4D959058.7010606@codeaurora.org>
	<BANLkTim8GhUAZ7L-MiJiqi6xM=P_Q8kqfg@mail.gmail.com>
	<4D981EAB.8070209@codeaurora.org>
Date: Mon, 4 Apr 2011 21:29:45 -0500
Message-ID: <BANLkTimhk_G0fapzHAf0Gc-XhqT0qu+VbQ@mail.gmail.com>
Subject: Re: [PATCH] ARM: BUG() dies silently
From: "Ramirez Luna, Omar" <omar.ramirez@ti.com>
To: Simon Glass <sjg@chromium.org>, Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>, lk <linux-kernel@vger.kernel.org>,
        lak <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon, Stephen,

On Sun, Apr 3, 2011 at 2:15 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> (Please stop top posting)
>
> On 4/1/2011 3:29 PM, Simon Glass wrote:
>> Hi Stephen,
>>
>> Sorry for the confusion, but in fact I was talking about the patch to
>> make ARM use the generic bug handling via an undef instruction instead
>> of calling ______bug() or writing to memory address 0. Please see
>> here:
>>
>> http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=6808/1
>
> Yes I've seen your patch (and even posted comments on it which have not
> been responded to).
>
> Correct me if I'm wrong, but that patch with CONFIG_BUG=n would lead to
> the same error that Omar is seeing because the code only modifies the
> bug infrastructure when CONFIG_BUG=y.

I am using CONFIG_BUG=y, however I don't have CONFIG_DEBUG_BUGVERBOSE
and hence I fall into the part which doesn't print the file and the
line where the BUG was found.

With Simon's patch if my .config had:

CONFIG_BUG=y
CONFIG_GENERIC_BUG is not set
CONFIG_DEBUG_BUGVERBOSE is not set

I would fall into the same BUG definition that is causing issues:

#define BUG()           do { *(int *)0 = 0; } while (1)

OTOH, is not like "Use generic BUG() handler" gives the choice of
removing GENERIC_BUG given that it is not prompted in menuconfig and
auto selected, if this is the intention is there any reason to keep
the #else part of /* not CONFIG_GENERIC_BUG */? there is no way we can
use it with this patch, right?

Regards,

Omar
