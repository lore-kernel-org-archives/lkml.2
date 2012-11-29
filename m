Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab2K2UKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 15:10:44 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:39789 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab2K2UKn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 15:10:43 -0500
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Chao Xie <chao.xie@marvell.com>
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, haojian.zhuang@gmail.com,
        linux-arm-kernel@lists.infradead.org, xiechao.mail@gmail.com
Subject: Re: [PATCH 4/4] rtc: pxa: request rtc irqs when probe/remove the device
References: <1354155670-6267-1-git-send-email-chao.xie@marvell.com>
	<1354155670-6267-4-git-send-email-chao.xie@marvell.com>
X-URL: http://belgarath.falguerolles.org/
Date: Thu, 29 Nov 2012 21:10:26 +0100
In-Reply-To: <1354155670-6267-4-git-send-email-chao.xie@marvell.com> (Chao
	Xie's message of "Wed, 28 Nov 2012 21:21:10 -0500")
Message-ID: <87mwy0187h.fsf@free.fr>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chao Xie <chao.xie@marvell.com> writes:

> The original pxa_rtc_open/pxa_rtc_release will be called
> when the /dev/rtc0 is opened or closed.
> In fact, these two functions will register/unregister the irqs.
> User application will use /dev/rtc0 to read the rtc time or set
> the alarm. The rtc should still run indepent of open/close the
> rtc device.
> So only register the irqs when probe the device,
> and disable clock and unregister the irqs when remove the device.
No, as Russell I think that's not correct.

This is not how RTC API should be used. And on top of RTC API considerations,
consider this : today, rtc-pxa and rtc-sa1100 _can_ coexist on a PXA platform,
and be used alternatively (I know, it's a bit borderline because of IO space,
but anyway it does work). How will that be possible with your patch ?

Cheers.

--
Robert
