Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140Ab1KCDLA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 23:11:00 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49517 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab1KCDK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 23:10:58 -0400
Date: Thu, 3 Nov 2011 11:10:49 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Daney <ddaney.cavm@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] clocksource: Avoid selecting mult values that might
 overflow when adjusted
Message-ID: <20111103031049.GA13681@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1320264087-3413-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1320264087-3413-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 01:01:27PM -0700, John Stultz wrote:
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 2b021b0e..d37c9e3 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -820,6 +820,9 @@ static void timekeeping_adjust(s64 offset)
>  	} else
>  		return;
>  
> +	WARN_ONCE(timekeeper.mult+adj >
> +			timekeeper.clock->mult + timekeeper.clock->maxadj,
> +			"Adjusting more then 11%%");

			s/then/than ; s/%%/%\n ?

Thanks,
Yong
