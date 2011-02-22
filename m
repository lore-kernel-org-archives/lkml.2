Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab1BVVkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:40:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56819 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751222Ab1BVVkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:40:14 -0500
Date: Tue, 22 Feb 2011 21:40:13 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>, rtc-linux@googlegroups.com,
        LKML <linux-kernel@vger.kernel.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Subject: Re: [rtc-linux] [PATCH 04/10] RTC: Cleanup
	rtc_class_ops->read_alarm()
Message-ID: <20110222214013.GJ31611@opensource.wolfsonmicro.com>
References: <20110222023452.GB18299@sirena.org.uk> <1298343333.4222.36.camel@work-vm> <1298362178.4222.57.camel@work-vm> <20110222181647.GA25569@opensource.wolfsonmicro.com> <1298404268.9215.39.camel@work-vm> <20110222200046.GD31611@opensource.wolfsonmicro.com> <1298406174.9215.71.camel@work-vm> <20110222210522.GG31611@opensource.wolfsonmicro.com> <1298409673.9215.84.camel@work-vm> <alpine.LFD.2.00.1102222225060.2701@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1102222225060.2701@localhost6.localdomain6>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 10:27:12PM +0100, Thomas Gleixner wrote:
> On Tue, 22 Feb 2011, john stultz wrote:

> > We can preserve what hardware state we can at boot, but applications
> > should not expect alarms set multiple reboot cycles ago to be valid.
> > After all, other applications might have jumped in and grabbed the rtc
> > device and set it to something else before the application was able to.
> > Or a user might change the value from something like a bios menu.

> Ack. Anyhting which relies on such a feature is broken by
> definition. A sane requirement is that the last set earliest alarm
> survives, but anything else is just beyond the scope of a sane
> interface.

Right, my point is that it doesn't strike me as obvious that we should
be supporting multiple alarms on an RTC in kernel space in the first
place (unless someone comes up with hardware which does so).
