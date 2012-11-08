Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab2KHM6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 07:58:55 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61869 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755521Ab2KHM6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 07:58:54 -0500
MIME-Version: 1.0
In-Reply-To: <509983D0.1060107@wwwdotorg.org>
References: <1352218863-2037-1-git-send-email-linus.walleij@stericsson.com>
	<509983D0.1060107@wwwdotorg.org>
Date: Thu, 8 Nov 2012 13:58:53 +0100
Message-ID: <CACRpkdYgEp2qb6_TWukLZmaO-tKz=hg_2=FAQk9E1DbP5wiP1Q@mail.gmail.com>
Subject: Re: [PATCH] gpiolib: iron out include ladder mistakes
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 10:40 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 11/06/2012 09:21 AM, Linus Walleij wrote:

>> And we need to keep the static inlines in <linux/gpio.h>
>> but here for the !CONFIG_GENERIC_GPIO case, and then we
>> may as well throw in a few warnings like the other
>> prototypes there, if someone would have the bad taste
>> of compiling without GENERIC_GPIO even.
>
> Hmm. Is there way to avoid the duplication of the dummy implementations?
> Having a prototype and a truly dummy implementation in one place, but a
> WARNing/failing dummy implementation elsewhere, seems like it'll cause
> issues.

Yeah :-/

This is not exactly elegant and is some side effect of the split
between CONFIG_GENERIC_GPIO and CONFIG_GPIOLIB,
the real fix is to get rid of all GENERIC_GPIO implementations
in the kernel and switch everyone over to GPIOLIB.

Not that easy though :-( can't think of any nice fix.

> Does this patch mean the previous series causes "git bisect" failures?

Yeah once I have something that doesn't break x86 I might
just squash collapse all of this into the gpioranges patch.

Yours,
Linus Walleij
