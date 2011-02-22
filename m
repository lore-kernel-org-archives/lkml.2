Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755019Ab1BVSQ3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 13:16:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46378 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754987Ab1BVSQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 13:16:28 -0500
Date: Tue, 22 Feb 2011 10:16:48 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: john stultz <johnstul@us.ibm.com>
Cc: rtc-linux@googlegroups.com, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Subject: Re: [rtc-linux] [PATCH 04/10] RTC: Cleanup
 rtc_class_ops->read_alarm()
Message-ID: <20110222181647.GA25569@opensource.wolfsonmicro.com>
References: <1298332538-31216-1-git-send-email-john.stultz@linaro.org>
 <1298332538-31216-5-git-send-email-john.stultz@linaro.org>
 <20110222023452.GB18299@sirena.org.uk>
 <1298343333.4222.36.camel@work-vm>
 <1298362178.4222.57.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298362178.4222.57.camel@work-vm>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 12:09:38AM -0800, john stultz wrote:

> Just so I can better get a grip of the cases your considering, could you
> maybe give me some more detailed examples of where you'd like to see the
> alarm timer be set and then persist across multiple power cycles before
> firing? And how is that persistent value managed by the application
> setting it?

The WM83xx RTCs can do this (the alarm can be used to initiate a boot)
and I'd expect many embedded RTC controllers can do similar.  The
application would manage this by owning the RTC in the system, usually
with a configuration saying something like "boot every day at 7am" or
something.

Having thought about this a bit I'm thinking that this sort of alarm
handling is probably something I'd expect to see handled in userspace.
I can see us providing a virtual RTC driver that can generate alarms
when there's no actual RTC hardware but adding additional functionality
on top of the hardware feels like an application issue.
