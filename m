Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab1BCVIL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:08:11 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43316 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab1BCVIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:08:10 -0500
MIME-Version: 1.0
In-Reply-To: <1296760576.3336.324.camel@work-vm>
References: <1296699283-6784-1-git-send-email-john.stultz@linaro.org>
 <AANLkTimO5FXDoA_egZ=7oR5FTV-Fx5qpjfPRZ7eT1q50@mail.gmail.com> <1296760576.3336.324.camel@work-vm>
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Date: Thu, 3 Feb 2011 18:31:37 -0200
Message-ID: <AANLkTikgTNVkxeb+4HQonce-Y=z7EpxXn_SuwVj=EdE2@mail.gmail.com>
Subject: Re: [PATCH 0/4] RTC regression fixups
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Currently, the RTC driver _must_ declare the read_alarm() callback,
even if it does nothing. But the code in drivers/rtc/interface.c does

	if (rtc->ops == NULL)
		err = -ENODEV;
	else if (!rtc->ops->read_alarm)
		err = -EINVAL;
	else {
		memset(alarm, 0, sizeof(struct rtc_wkalrm));
		alarm->enabled = rtc->aie_timer.enabled;
		alarm->time = rtc_ktime_to_tm(rtc->aie_timer.node.expires);
	}

The read_alarm() callback is not being performed.

Two questions:

1 - Should the callback be removed or should it be kept and called in
the else part?

2 - In case we are keeping it, should it be enforced like it is now,
or should it be kept optional? I'd rather have it optional, that means
less useless code in the drivers.

Regards,
Marcelo.
