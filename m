Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab1EQOAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 10:00:41 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:53419 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754730Ab1EQOAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 10:00:40 -0400
Message-ID: <4DD27F7D.2070305@ti.com>
Date: Tue, 17 May 2011 19:30:29 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: linux-arm-kernel@lists-infradead.org, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robherring2@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: smp_twd: Reconfigure clockevents after cpufreq change
References: <1305588114-23728-1-git-send-email-ccross@android.com>
In-Reply-To: <1305588114-23728-1-git-send-email-ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Colin,

On 5/17/2011 4:51 AM, Colin Cross wrote:
> The localtimer's clock changes with the cpu clock.  After a
> cpufreq transition, update the clockevent's frequency and
> reprogram the next clock event.
>
> Adds a clock called "smp_twd" that is used to determine the
> twd frequency, which can also be used at init time to
> avoid calibrating the twd frequency.
>
> Signed-off-by: Colin Cross<ccross@android.com>
> Cc: Thomas Gleixner<tglx@linutronix.de>
> Cc: Russell King<linux@arm.linux.org.uk>
> Cc: Santosh Shilimkar<santosh.shilimkar@ti.com>
> Cc: Rob Herring<robherring2@gmail.com>
> ---
>   arch/arm/kernel/smp_twd.c |   69 +++++++++++++++++++++++++++++++++++++++++++--
>   1 files changed, 66 insertions(+), 3 deletions(-)
>
> This patch depends on Thomas Gleixner's patch to add clockevents_reconfigure
> See: https://lkml.org/lkml/2011/5/13/122
>
> This patch adds a clock that can be used to skip calibration as well
> as update the frequency.  A later patch (or a later version of this patch)
> will drop twd_calibrate_rate once all platforms provide the necessary
> smp_twd clock.
>

Since the "smp_twd" clock node will not have a clk_set_rate()
associated with it, will the clk_get_rate() gives you real
rate. May be we can associate this node as a child of
CPU clock node and use the fixed divider based on peripheral
ratio. Is that the idea here to realize it ?

Regards,
Santosh

