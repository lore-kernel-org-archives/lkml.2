Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab0DAFt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 01:49:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:50796 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751209Ab0DAFtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 01:49:49 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18ogSsrVjwoZdPiGIu99eAZos+ioUMqLuBu8Hd5cT
	3uOTPluE774hTp
Subject: Re: Issues with Patch: "sched: Improve latencies and throughput"
From: Mike Galbraith <efault@gmx.de>
To: Michael Grzeschik <mgr@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, rsc@pengutronix.de
In-Reply-To: <20100331223106.GJ10342@pengutronix.de>
References: <20100331223106.GJ10342@pengutronix.de>
Content-Type: text/plain
Date: Thu, 01 Apr 2010 07:49:46 +0200
Message-Id: <1270100986.6707.156.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.57999999999999996
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-01 at 00:31 +0200, Michael Grzeschik wrote:
> We are using an arm mx31 embedded cpu with the v2.6.34 Kernelrelease and
> realized some issues with the scheduling behaviour the patch "sched:
> Improve latencies and throughput" [1] by Mike Galbraith introduced to
> the kernel.
> 
> When we used the alsa utility aplay to pipe some audio through an
> usbaudio device and put some scheduling overhead on the device, the
> amount of underruns, due to the not fast enough refilled ring buffer,
> was noticable increased with that patch [1] applied. Until we reverse
> applied the patch the amount of underruns was appreciable lower.

Testcase?

> That in fact is the opposite behaviour to its actual meaning.

Not necessarily.  NEXT_BUDDY can increase latency for waiters, as can
_not_ pulling a waiter to an idle CPU. 


> [1] 0ec9fab3d186d9cbb00c0f694d4a260d07c198d9
> 
> mgr

	-Mike

