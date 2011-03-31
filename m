Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758378Ab1CaRAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 13:00:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:37476 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab1CaRAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 13:00:31 -0400
Date: Thu, 31 Mar 2011 19:00:27 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: jacob pan <jacob.jun.pan@linux.intel.com>
cc: Jamie Iles <jamie@jamieiles.com>, LKML <linux-kernel@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] clocksource: clocksource/clockevent driver for Synopsys
 dw_apb_timer
In-Reply-To: <20110331095051.7933c7b9@jacob-laptop>
Message-ID: <alpine.LFD.2.00.1103311859230.22418@localhost6.localdomain6>
References: <1301584372-26261-1-git-send-email-jamie@jamieiles.com> <alpine.LFD.2.00.1103311719420.22418@localhost6.localdomain6> <20110331095051.7933c7b9@jacob-laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011, jacob pan wrote:

> On Thu, 31 Mar 2011 17:33:12 +0200 (CEST)
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > On Thu, 31 Mar 2011, Jamie Iles wrote:
> > 
> > > This patch adds a driver for the Synopsys DesignWare APB timer block
> > > found in some ARM systems.  This uses the timers with an IRQ as a
> > > clockevents device and a timer without an IRQ as a clocksource
> > > device.
> > 
> > Interesting. That's probably the same thing as:
> > 
> >      arch/x86/kernel/apb_timer.c
> > 
> > So if we merge that thing, then we should make sure, that we can
> > replace the x86 one with it.
> > 
> It seems we have room to consolidate, here is my 2c:
> 1. need to support multiple timer channels
> 2. support percpu clockevent, need to deal with cpu online/offline
> 3. early boot needs. I don't know if abp timer is needed for booting on
> ARM platforms. But for Moorestown, we need timer before platform bus
> running. So I guess we cannot enumerate the timer as platform device.

That's a solvable problem. I just don't want to see two incarnations
of the same thing in the kernel. Can you folks hash that out together
what it needs to work everywhere please ?

Thanks,

	tglx
