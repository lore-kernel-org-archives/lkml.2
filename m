Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393Ab1DGH6u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 03:58:50 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:48857 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754085Ab1DGH6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 03:58:49 -0400
Message-ID: <4D9D6807.40800@stericsson.com>
Date: Thu, 7 Apr 2011 09:30:15 +0200
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCHv5 2/3] ARM: Allow machines to override __delay()
References: <1302047800-26720-1-git-send-email-sboyd@codeaurora.org> <1302047800-26720-3-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1302047800-26720-3-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2011 01:56 AM, Stephen Boyd wrote:
> Some machines want to implement their own __delay() routine based
> on fixed rate timers. Expose functionality to set the __delay()
> routine at runtime. This should allow two machines with different
> __delay() routines to happily co-exist within the same kernel
> with minimal overhead.
>
> Russell expressed concern that using a timer based __delay()
> would cause problems when an iomapped device isn't mapped in
> prior to a delay call being made (see
> http://article.gmane.org/gmane.linux.ports.arm.kernel/78543  for
> more info). We can sidestep that issue with this approach since
> the __delay() routine_should_  only be pointed to a timer based
> delay once the timer has been properly mapped. Up until that
> point __delay() and udelay() will use delay_loop() which is
> always safe to call.
>
> This patch is inspired by x86's delay.c
>

Tested-by: Mattias Wallin <mattias.wallin@stericsson.com>

Yours,
Mattias Wallin

