Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751345Ab2HaE0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 00:26:40 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34898 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab2HaE0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 00:26:37 -0400
MIME-Version: 1.0
In-Reply-To: <503F9F72.9020301@yahoo.es>
References: <503F9F72.9020301@yahoo.es>
Date: Fri, 31 Aug 2012 09:56:36 +0530
Message-ID: <CAKohponRJHD_7PkQ_W2AF_9YtcRs1sJuQWwZtqmFTSQ-+bQcnQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] dw_dmac: repair driver for use with AVR32 (AP7000)
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Hein Tibosch <hein_tibosch@yahoo.es>
Cc: spear-devel <spear-devel@list.st.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "ludovic.desroches" <ludovic.desroches@atmel.com>,
        Havard Skinnemoen <havard@skinnemoen.net>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, egtvedt@samfundet.no,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd.bergmann@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 August 2012 22:44, Hein Tibosch <hein_tibosch@yahoo.es> wrote:
> After some recent changes to dw_dmac, the driver got broken
> for the AVR32 platform for two reasons:
>
> The accessors to i/o memory had become little-endian.
> The maximum transfer width on the memory side was increased
> from 32 to 64 bits. This led to undefined behavior on the
> avr32 platform.
>
> These patches repair the driver by:
> 1. making the endianness configurable through Kconfig,
> for AVR32 it will become big-endian
> 2. making the maximum memory transfer width configurable
> It can be set in the code within arch

Acked-by: Viresh Kumar <viresh.kumar@linaro.org>

BTW, Ideally speaking the fix for AVR32 which will enable 32bit mem
support and enable BIG endian support should have been part of this
patchset. That code can go through DMA tree as these patches are
very closely related. Otherwise now you have to wait till these patches
are included in linux-next, then only you can send AVR32 patches for
inclusion.

So, maybe you can just add Acked-by from me and Arnd and include
AVR patches (Only changes related to these two patches) in the same series.
That will make life easier for you.

viresh
