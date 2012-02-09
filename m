Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757739Ab2BIKMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 05:12:51 -0500
Received: from www.linutronix.de ([62.245.132.108]:34786 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab2BIKMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 05:12:50 -0500
Date: Thu, 9 Feb 2012 11:12:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
cc: John Stultz <john.stultz@linaro.org>, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org
Subject: Re: clock_getres() and real resolution
In-Reply-To: <4F32A347.4090703@linaro.org>
Message-ID: <alpine.LFD.2.02.1202091051310.2794@ionos>
References: <4F32A347.4090703@linaro.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Feb 2012, Dmitry Antipov wrote:

> IIUC, an idea behind clock_getres() is to give a hint about the resolution of
> specified clock. This hint may be used by an application programmer to check
> whether
> this clock is suitable for a some purpose. So why clock_getres() always
> returns
> something like {0, 1} (if hrtimers are enabled) regardless of the underlying
> platform's
> real numbers?
> 
> For example, OMAP4's real resolution of CLOCK_REALTIME is 30.5us for 32K timer
> and 26ns
> for MPU timer. Such a difference definitely makes sense - but
> clock_getres(CLOCK_REALTIME,..)
> always returns {0, KTIME_HIGH_RES}. Since this behavior causes a confusion
> like
> http://lists.linaro.org/pipermail/linaro-dev/2012-February/010112.html, I'm
> considering
> this as a stupid misfeature.

We had this discussion before. The point is that the accuracy of the
internal kernel timer handling is 1nsec in case of high resolution
timers. The fact that the underlying clock event device has a coarser
resolution does not change that. 

It would be possible to return the real resolution of the clock event
device, but we have systems, where the clockevent device is
dynamically changing. So which resolution do we expose to an
application? The one of the current active device or some magic number
of a device which might not even be initialized? That's more confusing
than telling user space that high resolution timers are active and the
kernel is trying to achieve the 1ns accuracy.

Thanks,

	tglx
