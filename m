Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758907Ab2FAIFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 04:05:15 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36198 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758694Ab2FAIFA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 04:05:00 -0400
MIME-Version: 1.0
X-Originating-IP: [85.250.83.253]
In-Reply-To: <1338473535-26957-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1338473535-26957-1-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 1 Jun 2012 11:04:40 +0300
Message-ID: <CAK=WgbaM-3_rsJ=Tq_YK-HboAUxxpvgG6iFSYafuTbKE7Ss1Hg@mail.gmail.com>
Subject: Re: [RFC] remoteproc: Add custom STE-modem firmware loader.
To: sjur.brandeland@stericsson.com
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Thu, May 31, 2012 at 5:12 PM,  <sjur.brandeland@stericsson.com> wrote:
> OK, here is an early version of the STE-Modem firmware loader.
> Haven't done the Makefile and Kconfig updates yet though.

Thanks for posting this! I'll find the time to review this asap.

> But I have one issue, I need the firmware image to be allocated
> at the start of shared memory. But the vring gets allocated first.
> I could work around this by calling dma_mark_declared_memory_occupied(),
> from the driver and then call dma_release_from_coherent() before booting.
> But this feels like a hack. Any ideas on how to handle this properly?

One proper way to handle this is to allow platforms to provide
separate memory regions for separate purposes by binding each memory
region to a different per-purpose subdevices.

This way remoteproc could then use the right device whenever it
invokes the DMA API, and memory will then always be allocated from the
expected region, without being affected by different allocation
orders.

Ludovic was working on a patch that does exactly that, and the zynq
folks also need it, so the timing of your request looks perfect :)

Thanks,
Ohad.
