Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751259Ab1JMEHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 00:07:01 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49666 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab1JMEG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 00:06:59 -0400
Date: Wed, 12 Oct 2011 21:06:56 -0700
From: mark gross <markgross@thegnar.org>
To: Ming Lei <tom.leiming@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, mark gross <mgross@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM List <linux-pm@vger.kernel.org>
Subject: Re: [Question] PM-QoS: PM_QOS_CPU_DMA_LATENCY == interrupt latency?
Message-ID: <20111013040656.GE893@mgross-G62>
Reply-To: markgross@thegnar.org
References: <CACVXFVOkwX+974=eEY5UPysXN-t9Adg6=Wn0Ts4m0vT5zQaw3g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVOkwX+974=eEY5UPysXN-t9Adg6=Wn0Ts4m0vT5zQaw3g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 10:31:34PM +0800, Ming Lei wrote:
> Hi,
> 
> Looks like it is a bit difficult to understand PM_QOS_CPU_DMA_LATENCY
> from the words' meaning.
> 
> After searching from google, I don't find some useful information about
> the root cause for introducing PM_QOS_CPU_DMA_LATENCY. I understand
> it is very similar to interrupt latency. Also from the comment for
> omap_pm_set_max_mpu_wakeup_lat in file[1], the description is basically same
> with interrupt latency.

its the amount of time the CPU can take to wake up and feed a DMA
engine.  Its a bit more general than interrupt latency.

> From comments of pm_qos_add_request usages in drivers, it can be understood
> as interrupt latency too, IMO.

The original 2 issues that drove its predecessor implementation where
DMA'ing data to the original intel wifi device.  If the CPU snoozed too
long the wifi device would get lost and network would suffer.

The other one was something to do with generating audio pops if the cpu
didn't keep some audio buffer that was getting DMA'd to something from
underflowing.


> 
> So, could we think that PM_QOS_CPU_DMA_LATENCY is interrupt latency?
nope.

--mark
> 
> [1], arch/arm/plat-omap/include/plat/omap-pm.h
> 
> thanks,
> -- 
> Ming Lei
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
