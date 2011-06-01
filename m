Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899Ab1FAOZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 10:25:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33963 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756117Ab1FAOZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 10:25:26 -0400
Date: Wed, 1 Jun 2011 15:25:07 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/3] clocksource: add DB8500 PRCMU Timer support
Message-ID: <20110601142507.GK3660@n2100.arm.linux.org.uk>
References: <1306830661-9546-1-git-send-email-mattias.wallin@stericsson.com> <alpine.LFD.2.02.1105311236250.3078@ionos> <4DE51EB7.7010606@stericsson.com> <BANLkTinPKbUu40066+wr3cdFRc2di-Uv6g@mail.gmail.com> <4DE5F0DB.2050409@stericsson.com> <4DE64B0E.8030008@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE64B0E.8030008@stericsson.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 01, 2011 at 04:22:06PM +0200, Mattias Wallin wrote:
> On 06/01/2011 09:57 AM, Mattias Wallin wrote:
>> I'll experiment with it during the day and see how it goes.
> It did not work to have the clocksource init as a core_initcall.
> I got an null pointer oops in sched_clock_poll.
> The lauterbach trace showed that the sched_clock_update_fn was null  
> since the poll function was called before the init.

sched_clock is supposed to be setup and initialized really early.  Why
are you doing trying to move it soo late?
