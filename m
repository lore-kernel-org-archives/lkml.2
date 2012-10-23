Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964959Ab2JWXMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 19:12:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755686Ab2JWXM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 19:12:29 -0400
Date: Tue, 23 Oct 2012 16:12:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        viresh kumar <viresh.kumar@linaro.org>,
        spear-devel <spear-devel@list.st.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Arnd Bergmann <arnd.bergmann@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH REGRESSION FIX] dw_dmac: make driver's endianness
 configurable
Message-Id: <20121023161218.45a7ae4e.akpm@linux-foundation.org>
In-Reply-To: <507A6FA5.1000800@yahoo.es>
References: <507A6FA5.1000800@yahoo.es>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 14 Oct 2012 15:54:13 +0800
Hein Tibosch <hein_tibosch@yahoo.es> wrote:

> The dw_dmac was originally developed for avr32 to be used with the Synopsys
> DesignWare AHB DMA controller. Starting from 2.6.38, access to the device's i/o
> memory was done with the little-endian readl/writel functions(1)
> 
> This broke the driver for the avr32 platform, because it needs big (native)
> endian accessors.
> This patch makes the endianness configurable using 'DW_DMAC_BIG_ENDIAN_IO',
> which will default be true for AVR32

Do we think this bug should be fixed in earlier kernel versions?

If so, the patch might need to be tweaked for 3.6 and earlier, which
don't have the dma_read_byaddr() definition.
