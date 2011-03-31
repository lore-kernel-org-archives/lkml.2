Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341Ab1CaQuy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 12:50:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:23241 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758295Ab1CaQuw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 12:50:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,276,1299484800"; 
   d="scan'208";a="727545032"
Date: Thu, 31 Mar 2011 09:50:51 -0700
From: jacob pan <jacob.jun.pan@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jamie Iles <jamie@jamieiles.com>, LKML <linux-kernel@vger.kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] clocksource: clocksource/clockevent driver for Synopsys
 dw_apb_timer
Message-ID: <20110331095051.7933c7b9@jacob-laptop>
In-Reply-To: <alpine.LFD.2.00.1103311719420.22418@localhost6.localdomain6>
References: <1301584372-26261-1-git-send-email-jamie@jamieiles.com>
	<alpine.LFD.2.00.1103311719420.22418@localhost6.localdomain6>
Organization: OTC
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011 17:33:12 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Thu, 31 Mar 2011, Jamie Iles wrote:
> 
> > This patch adds a driver for the Synopsys DesignWare APB timer block
> > found in some ARM systems.  This uses the timers with an IRQ as a
> > clockevents device and a timer without an IRQ as a clocksource
> > device.
> 
> Interesting. That's probably the same thing as:
> 
>      arch/x86/kernel/apb_timer.c
> 
> So if we merge that thing, then we should make sure, that we can
> replace the x86 one with it.
> 
It seems we have room to consolidate, here is my 2c:
1. need to support multiple timer channels
2. support percpu clockevent, need to deal with cpu online/offline
3. early boot needs. I don't know if abp timer is needed for booting on
ARM platforms. But for Moorestown, we need timer before platform bus
running. So I guess we cannot enumerate the timer as platform device.

-- 
Thanks

Jacob

