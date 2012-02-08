Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097Ab2BHQa0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 11:30:26 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48273 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755661Ab2BHQaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 11:30:22 -0500
Message-ID: <4F32A347.4090703@linaro.org>
Date: Wed, 08 Feb 2012 08:31:03 -0800
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120129 Thunderbird/10.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>
CC: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Subject: clock_getres() and real resolution
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IIUC, an idea behind clock_getres() is to give a hint about the resolution of
specified clock. This hint may be used by an application programmer to check whether
this clock is suitable for a some purpose. So why clock_getres() always returns
something like {0, 1} (if hrtimers are enabled) regardless of the underlying platform's
real numbers?

For example, OMAP4's real resolution of CLOCK_REALTIME is 30.5us for 32K timer and 26ns
for MPU timer. Such a difference definitely makes sense - but clock_getres(CLOCK_REALTIME,..)
always returns {0, KTIME_HIGH_RES}. Since this behavior causes a confusion like
http://lists.linaro.org/pipermail/linaro-dev/2012-February/010112.html, I'm considering
this as a stupid misfeature.

Dmitry
