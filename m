Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107Ab1KCMFZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 08:05:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:58354 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932753Ab1KCMFX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 08:05:23 -0400
Date: Thu, 3 Nov 2011 13:05:19 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: John Stultz <john.stultz@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, Yong Zhang <yong.zhang0@gmail.com>,
        David Daney <ddaney.cavm@gmail.com>
Subject: Re: [PATCH] clocksource: Avoid selecting mult values that might
 overflow when adjusted
In-Reply-To: <1320264087-3413-1-git-send-email-john.stultz@linaro.org>
Message-ID: <alpine.LFD.2.02.1111031304210.2829@ionos>
References: <1320264087-3413-1-git-send-email-john.stultz@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Nov 2011, John Stultz wrote:
>  
> +	WARN_ONCE(timekeeper.mult+adj >
> +			timekeeper.clock->mult + timekeeper.clock->maxadj,
> +			"Adjusting more then 11%%");

Shouldn't we rather limit the update instead of just warn and overflow ?

Thanks,

	tglx
