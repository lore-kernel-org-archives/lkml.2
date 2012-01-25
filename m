Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab2AYLnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 06:43:16 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43994 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751181Ab2AYLnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 06:43:15 -0500
MIME-Version: 1.0
X-Originating-IP: [89.139.53.79]
In-Reply-To: <4F1EE861.4030405@monstr.eu>
References: <4F1EE861.4030405@monstr.eu>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 25 Jan 2012 13:42:54 +0200
Message-ID: <CAK=Wgba5kT8AwLtuHyosucYnWf-EA+xpE1kzmssfhSC7ZXQA=g@mail.gmail.com>
Subject: Re: remoteproc: Load coprocessor code to the specific main memory location
To: monstr@monstr.eu
Cc: LKML <linux-kernel@vger.kernel.org>,
        John Williams <john.williams@petalogix.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "Grosen, Mark" <mgrosen@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

On Tue, Jan 24, 2012 at 7:20 PM, Michal Simek <monstr@monstr.eu> wrote:
> Hi,
>
> I have a question how to setup resource table to support firmware loading
> to specific memory location.
> I have allocated the part of ram which is at physical address 0x0
> which coprocessor needs for rtos code.

Can you specify about your allocation a bit more ? size ? method of
allocation (CMA/external ram+ioremap/other) ?

> Currently I am using carveout with setup size but from rproc_handle_carveout
> is __dma_alloc_buffer which is remapped by __dma_alloc_remap function to any

oh, so you're < ARMv6 (no CMA). you'd need to set aside some coherent
memory for your device then.

> Coprocessor can directly access memory of the main cpu.

That's fine: remoteproc supports these cases, and does not require an IOMMU.

We also successfully tested this with davinci, which does not have an IOMMU.

Looping in Mark, who did the davinci remoteproc support, and might
have the code available to share. Hopefully we'd have the patches
posted soon, and then no-iommu platforms could just use them for
reference.

Thanks,
Ohad.
