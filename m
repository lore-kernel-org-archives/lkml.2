Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab1FAOWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 10:22:23 -0400
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:42925 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755568Ab1FAOWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 10:22:21 -0400
Message-ID: <4DE64B0E.8030008@stericsson.com>
Date: Wed, 1 Jun 2011 16:22:06 +0200
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 2/3] clocksource: add DB8500 PRCMU Timer support
References: <1306830661-9546-1-git-send-email-mattias.wallin@stericsson.com>	<alpine.LFD.2.02.1105311236250.3078@ionos>	<4DE51EB7.7010606@stericsson.com> <BANLkTinPKbUu40066+wr3cdFRc2di-Uv6g@mail.gmail.com> <4DE5F0DB.2050409@stericsson.com>
In-Reply-To: <4DE5F0DB.2050409@stericsson.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2011 09:57 AM, Mattias Wallin wrote:
> I'll experiment with it during the day and see how it goes.
It did not work to have the clocksource init as a core_initcall.
I got an null pointer oops in sched_clock_poll.
The lauterbach trace showed that the sched_clock_update_fn was null 
since the poll function was called before the init.

I'll go back to having it called from the platform's struct system_time 
(like in patch 3/3) and place the include file in include/linux.

Thomas, are you ok with having it directly under include/linux or do you 
want me to create a include/linux/clocksource/ directory and place it there?
