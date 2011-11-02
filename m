Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932660Ab1KBC2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 22:28:08 -0400
Received: from mail.lemote.com ([222.92.8.141]:53043 "EHLO lemote.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339Ab1KBC2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 22:28:04 -0400
MIME-Version: 1.0
In-Reply-To: <1320097228-3612-1-git-send-email-john.stultz@linaro.org>
References: <1320097228-3612-1-git-send-email-john.stultz@linaro.org>
From: Chen Jie <chenj@lemote.com>
Date: Wed, 2 Nov 2011 10:27:25 +0800
Message-ID: <CAGXxSxUqzu8gBHU3GeCj1zmYdQdbC68dqaE1PeiBaOssPobo-g@mail.gmail.com>
Subject: Re: [RFC][PATCH] clocksource: Avoid selecting mult values that might
 overflow when adjusted
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Yong Zhang <yong.zhang0@gmail.com>,
        David Daney <ddaney.cavm@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
We've backported the patch to our kernel, and redo the test[1] that
formerly caused system stall.
After 12-hours, no system stall observed.



Regards,
Chen Jie

----
[1] The test is just do "sleep 5 && reboot " on our mips64 compatible
CPU@500MHz. At each boot time, BIOS will calculate CPU Freq. Some CPU
Freq(around 500MHz) caused easy-overflow clock mult values in the
former tests, which then led to "sleep 5" never return.
