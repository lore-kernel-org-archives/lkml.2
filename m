Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab1JOLZp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 07:25:45 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38694 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab1JOLZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 07:25:44 -0400
MIME-Version: 1.0
In-Reply-To: <0CE8B6BE3C4AD74AB97D9D29BD24E55202321C11@CORPEXCH1.na.ads.idt.com>
References: <1317191992-3635-1-git-send-email-jaswinder.singh@linaro.org>
	<1317200618.1573.1765.camel@vkoul-udesk3>
	<CAJe_ZhfDk7O_O7LDh7GrpcaPMzQuzs9nBA8BeN0VxG8_Oe93wg@mail.gmail.com>
	<1317295068.1573.1780.camel@vkoul-udesk3>
	<CAGsJ_4y+ageAqg1DQtQJ-g2j6im_e3KdvkcBaDFLz8fUniJpuA@mail.gmail.com>
	<CAJe_ZhfyTBgH7wqB1HWtkjDNusecTOTZrqyYKF=Lwb9xQAXA3w@mail.gmail.com>
	<CAGsJ_4x=F41Fbsw9gB3y=Vzyhf8a9yXB=sd6xbxSNUbTAYdjOA@mail.gmail.com>
	<CAJe_Zhd86uqhzRHaA8ci2GHQgz6TadPR5hTuuUKqCWOFJwn6qg@mail.gmail.com>
	<CAGsJ_4zOUFUkGv_-BB5sqjVZF1gBe-MVJS3Vxmi9Jo4sqYCLAg@mail.gmail.com>
	<CAJe_Zhc8zdZzse+jutYERec5bKBPqWmq9v0xYrou0x1BSKyCLQ@mail.gmail.com>
	<20111003161349.GB28287@flint.arm.linux.org.uk>
	<CAJe_ZhfS=4vSS0OiSuNx3S+fW8R4-=khrHtt8suLeHjTFYBVeA@mail.gmail.com>
	<CABE8wwsQKF9eTTU_N305hR=G5qW4Rzb7Lo-nHbc9RVYwSJVSVA@mail.gmail.com>
	<1317966346.1573.2252.camel@vkoul-udesk3>
	<CAJe_ZhdFA641AzmEmYaz++iRNYQmrHDFmAWOkrwmR_h2ie176g@mail.gmail.com>
	<CABE8wwtcO_su0cF6YocVjAYKhUb=TTwqttfaZkC+RWGLKJimdQ@mail.gmail.com>
	<CAJe_Zhc1CeFFPKMu0LDpufhQw_Q0SFkxHwXrziQrcP3AXkXANA@mail.gmail.com>
	<0CE8B6BE3C4AD74AB97D9D29BD24E55202321C11@CORPEXCH1.na.ads.idt.com>
Date: Sat, 15 Oct 2011 16:55:43 +0530
Message-ID: <CAJe_ZheocjVhD4PTXQo3R7rqgiyt4BCo8Fx_sJ7AmDCjB=zMxQ@mail.gmail.com>
Subject: Re: [PATCHv4] DMAEngine: Define interleaved transfer request api
From: Jassi Brar <jaswinder.singh@linaro.org>
To: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
Cc: "Williams, Dan J" <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Russell King <rmk@arm.linux.org.uk>,
        Barry Song <21cnbao@gmail.com>, linux-kernel@vger.kernel.org,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>,
        Dave Jiang <dave.jiang@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 October 2011 00:45, Bounine, Alexandre <Alexandre.Bounine@idt.com> wrote:

>> But doesn't the info, pointed to by this (void *), remain same for
>> every
>> transfer to a particular target/remote device ?
> No. An address within the target may (and most likely will) be changed for
> every transfer. Target destination ID will be the same for given virtual channel.
>
Thanks for the info.

> Virtual channel may bring the same challenge and I may need a channel locking
> if more than one requester try to read/write data to the same target RIO device.
>
One can't avoid taking care of locking, but using virtual channels keeps
the dma_chan usage consistent.

RapidIO supports 34(32+2), 50(48+2) and 66(64+2) bit addressing
which makes me wonder if the (upper or lower) 2 bits could be attached to
the identity of the target device ?
(tsi721 driver actually discards the upper 2 bits while claiming to support
66bit addressing so I couldn't make anything out of it and specs don't
seem to say much about it)

If there is no user of 66bit addressing and isn't coming in very near future,
we might as well drop that case for now(tsi721 already does) because
that 'completeness' of support modifies the semantics of dmaengine apis
today for no real use.
