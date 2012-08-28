Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab2H1HFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 03:05:31 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41982 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751834Ab2H1HFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 03:05:30 -0400
MIME-Version: 1.0
In-Reply-To: <503C6B67.2010903@yahoo.es>
References: <503A8CAE.6050606@yahoo.es>
	<20120827070323.GC28721@samfundet.no>
	<503B342C.9060300@yahoo.es>
	<20120827111431.GA27868@samfundet.no>
	<503B8B26.3050205@yahoo.es>
	<CAKohpo=ALUNOnQdQjNd1Y2jtocxjixKCiBrRZp8qGErqg1LSKw@mail.gmail.com>
	<503C6B67.2010903@yahoo.es>
Date: Tue, 28 Aug 2012 12:35:29 +0530
Message-ID: <CAKohponjP=GPihEK1T9zEsaBkHD5j4JCALgp0GS8xCsU_9exmw@mail.gmail.com>
Subject: Re: [PATCH 1/2] dw_dmac: make driver endianness configurable
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        spear-devel <spear-devel@list.st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 August 2012 12:25, Hein Tibosch <hein_tibosch@yahoo.es> wrote:
> What about this:
>
> In case of AVR32, the arch code will indicate:
>
> static struct dw_dma_platform_data dw_dmac0_data = {
>         .nr_channels    = 3,
>         /* DMAC supports up to 32-bit memory access */
>         .mem_access_32_bit_only = true,
> };
>
> ARM users won't have to change anything because mem_access_32_bit_only
> will be false and therefor 'dw->mem_64_bit' will become true

I will go for the earlier solution that you sent: with max-mem-width.
0 = 64 bit, so nothing to be changed for ARM as global structures would be
getting initialized to zero
1=32 bit, pass this for AVR32.

--
viresh
