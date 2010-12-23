Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab0LWRfT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 12:35:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42495
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753649Ab0LWRfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 12:35:15 -0500
Date: Thu, 23 Dec 2010 09:35:44 -0800 (PST)
Message-Id: <20101223.093544.71126698.davem@davemloft.net>
To: ying.huang@intel.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, peterz@infradead.org,
        torvalds@linux-foundation.org, mingo@elte.hu, rth@twiddle.net,
        linux@arm.linux.org.uk, starvik@axis.com, dhowells@redhat.com,
        ysato@users.sourceforge.jp, tony.luck@intel.com, takata@linux-m32r.org,
        geert@linux-m68k.org, monstr@monstr.eu, ralf@linux-mips.org,
        kyle@mcmartin.ca, schwidefsky@de.ibm.com, liqin.chen@sunplusct.com,
        mingo@redhat.com, chris@zankel.net
Subject: Re: [RFC -v9 1/4] Add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
From: David Miller <davem@davemloft.net>
In-Reply-To: <1293083003-19577-2-git-send-email-ying.huang@intel.com>
References: <1293083003-19577-1-git-send-email-ying.huang@intel.com>
	<1293083003-19577-2-git-send-email-ying.huang@intel.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Huang Ying <ying.huang@intel.com>
Date: Thu, 23 Dec 2010 13:43:20 +0800

> --- a/arch/sparc/Kconfig
> +++ b/arch/sparc/Kconfig
> @@ -22,6 +22,7 @@ config SPARC
>  	select RTC_CLASS
>  	select RTC_DRV_M48T59
>  	select HAVE_IRQ_WORK
> +	select ARCH_HAVE_NMI_SAFE_CMPXCHG
>  	select HAVE_DMA_ATTRS
>  	select HAVE_DMA_API_DEBUG
>  	select HAVE_ARCH_JUMP_LABEL

This should only be set for "SPARC64".  SPARC32's cmpxchg uses spinlocks and
IRQ disabling, which is not NMI safe.

