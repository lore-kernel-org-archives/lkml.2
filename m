Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376Ab1LHNJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 08:09:18 -0500
Received: from h5.dl5rb.org.uk ([81.2.74.5]:43265 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751266Ab1LHNJR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 08:09:17 -0500
Date: Thu, 8 Dec 2011 13:08:35 +0000
From: Ralf Baechle <ralf@linux-mips.org>
To: zhzhl555@gmail.com
Cc: a.zummo@towertech.it, rtc-linux@googlegroups.com,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
        keguang.zhang@gmail.com, wuzhangjin@gmail.com, r0bertz@gentoo.org
Subject: Re: [PATCH] MIPS: Add RTC support for loongson1B
Message-ID: <20111208130835.GC10113@linux-mips.org>
References: <1322729078-6141-1-git-send-email-zhzhl555@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322729078-6141-1-git-send-email-zhzhl555@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 04:44:38PM +0800, zhzhl555@gmail.com wrote:

> +	writel(t, SYS_TOYWRITE1);
> +	__asm__ volatile ("sync");
> +	c = 0x10000;
> +	while ((readl(SYS_COUNTER_CNTRL) & SYS_CNTRL_TS) && --c)
> +		usleep_range(1000, 3000);

Why the SYNC instruction?  This is an uncached write and on all MIPS CPUs
the SYNC instruction will only make sure the write has left the CPU's
write buffers.  There is no guarantee that by the time the SYNC has completed
the write has actually reached its destination.  If that is what you want,
read something from device.  Reads will only complete after all preceeding
writes have completed.

In this driver all instances of SYNC instructions are followed by polling
loops reading from the RTC which means all SYNCs should be unnecessary.

Or?

  Ralf
