Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab0EZQWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 12:22:39 -0400
Received: from king.tilera.com ([72.1.168.226]:14545 "EHLO king.tilera.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054Ab0EZQWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 12:22:37 -0400
Message-ID: <4BFD4AC9.6080602@tilera.com>
Date: Wed, 26 May 2010 12:22:33 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <alpine.LFD.2.00.1005252129441.2948@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1005252129441.2948@localhost.localdomain>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 May 2010 16:22:35.0664 (UTC) FILETIME=[A6A42900:01CAFCEF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/2010 4:12 PM, Thomas Gleixner wrote:
> +unsigned long long sched_clock(void)
> +{
> +	u64 cycles;
> +	u32 cyc_hi, cyc_lo;
> +
> +	if (unlikely(cyc2ns_mult == 0))
> +		setup_clock();
>
>   Please initialize stuff _before_ it is called the first time and not
>   at some arbitrary point conditionally in a hotpath.
>   

Looking more closely at this, the reason for this lazy initialization
was that sched_clock() can be called from lockdep_init(), which runs way
before any tasteful architecture-specific initialization can happen. 
Perhaps the correct model is that during the early stages of boot, we
are happy to shift by zero, multiply by zero, and claim the time is zero :-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


