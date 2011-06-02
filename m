Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161014Ab1FBKTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 06:19:15 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:50501 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933096Ab1FBKTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 06:19:13 -0400
Message-ID: <4DE7637B.3060901@stericsson.com>
Date: Thu, 2 Jun 2011 12:18:35 +0200
From: Mattias Wallin <mattias.wallin@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Thunderbird/3.0.10
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCHv2 0/3] clocksource: add db8500 PRCMU timer
References: <1307007271-1004-1-git-send-email-mattias.wallin@stericsson.com> <20110602094622.GS3660@n2100.arm.linux.org.uk>
In-Reply-To: <20110602094622.GS3660@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2011 11:46 AM, Russell King - ARM Linux wrote:
> Why don't we just find a way of fixing sched_clock so that the value
> doesn't reset over a suspend/resume cycle?
Even if the value isn't reset during suspend/resume we want the 
clocksource to keep counting. Or is it ok to have the clocksource stop 
or freeze during suspend?
Then we have cpuidle. Is it ok to stop/freeze the timer during cpuidle 
sleep states?
My view is that sched_clock and the clocksource read should return the 
time since boot and keep counting during sleep and suspend. (In this 
case we use the same timer for both sched_clk and clocksource.)
> IOW, lets fix the problem
> for_everyone_  rather than only fixing it for one platform at a time.
I agree that fixing it for everyone would be better and I can give it a 
try if I get pointed in the right direction.
