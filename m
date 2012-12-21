Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab2LUKCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 05:02:01 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49105 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579Ab2LUKBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 05:01:55 -0500
Message-ID: <50D43399.7010705@ti.com>
Date: Fri, 21 Dec 2012 15:32:01 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: <linux-kernel@vger.kernel.org>, <linux@arm.linux.org.uk>,
        <nico@linaro.org>, <marc.zyngier@arm.com>, <will.deacon@arm.com>,
        <john.stultz@linaro.org>, <tglx@linutronix.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 1/5] ARM: remove useless guard in smp.c
References: <1355832418-31692-1-git-send-email-mark.rutland@arm.com> <1355832418-31692-2-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1355832418-31692-2-git-send-email-mark.rutland@arm.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 December 2012 05:36 PM, Mark Rutland wrote:
> Currently we only provide an implementation of smp_timer_broadcast in
> smp.c if GENERIC_CLOCKEVENTS_BROADCAST is selected. As
> smp_timer_broadcast is only used in smp.c, smp.c depends on SMP, and
> GENERIC_CLOCKEVENTS_BROADCAST is selected by SMP, this is unnecessary.
>
> This patch removes the redundant guard.
>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> ---
CONFIG_GENERIC_CLOCKEVENTS_BROADCAST isn't mandatory to
have SMP kernel working so the below select in ARM arch
kconfig not seems to entirely accurate. SMP kernel will
still boot with !GENERIC_CLOCKEVENTS_BROADCAST.

select GENERIC_CLOCKEVENTS_BROADCAST if SMP

The issue comes only for deeper CPU power C-states.
Anyway, you patch is correct from the current code point of
view.

Regards
Santosh
