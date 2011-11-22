Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757948Ab1KVUca (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 15:32:30 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:34849 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab1KVUc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 15:32:28 -0500
Message-ID: <1321993924.6445.74.camel@work-vm>
Subject: Re: [PATCH] rtc: disable the alarm in the hardware
From: John Stultz <john.stultz@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org,
        Rabin Vincent <rabin.vincent@stericsson.com>, stable@kernel.org
Date: Tue, 22 Nov 2011 12:32:04 -0800
In-Reply-To: <1321956194-8382-1-git-send-email-linus.walleij@stericsson.com>
References: <1321956194-8382-1-git-send-email-linus.walleij@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 11112220-4242-0000-0000-0000002D4170
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-11-22 at 11:03 +0100, Linus Walleij wrote:
> From: Rabin Vincent <rabin.vincent@stericsson.com>
> 
> Currently, the RTC code does not disable the alarm in the hardware.
> 
> This means that after a sequence such as the one below (the files are in the
> RTC sysfs), the box will boot up after 2 minutes even though we've
> asked for the alarm to be turned off.
> 
> 	# echo $((`cat since_epoch`)+120) > wakealarm
> 	# echo 0 > wakealarm
> 	# poweroff
> 
> Fix this by disabling the alarm when there are no timers to run.

Hey Linus,
	Thanks for sending this along! It looks like a good fix to me! I'm a
little amazed this hasn't cropped up sooner.  I'll do some further
testing and then queue it for upstream.

thanks
-john


