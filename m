Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab2KFVkh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 16:40:37 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:44609 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab2KFVkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 16:40:36 -0500
Message-ID: <509983D0.1060107@wwwdotorg.org>
Date: Tue, 06 Nov 2012 14:40:32 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] gpiolib: iron out include ladder mistakes
References: <1352218863-2037-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1352218863-2037-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 09:21 AM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> The <*/gpio.h> includes are updated again: now we need to account
> for the problem introduced by commit:
> 595679a8038584df7b9398bf34f61db3c038bfea
> "gpiolib: fix up function prototypes etc"
> 
> Actually we need static inlines in include/asm-generic/gpio.h
> as well since we may have GPIOLIB but not PINCTRL.
> 
> And we need to keep the static inlines in <linux/gpio.h>
> but here for the !CONFIG_GENERIC_GPIO case, and then we
> may as well throw in a few warnings like the other
> prototypes there, if someone would have the bad taste
> of compiling without GENERIC_GPIO even.

Hmm. Is there way to avoid the duplication of the dummy implementations?
Having a prototype and a truly dummy implementation in one place, but a
WARNing/failing dummy implementation elsewhere, seems like it'll cause
issues.

Does this patch mean the previous series causes "git bisect" failures?
