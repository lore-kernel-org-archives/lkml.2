Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab2IJMtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 08:49:22 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:65448 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757856Ab2IJMtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 08:49:19 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.9.91]
In-Reply-To: <81C3A93C17462B4BBD7E272753C1057923B924C92D@EXDCVYMBSTM005.EQ1STM.local>
References: <81C3A93C17462B4BBD7E272753C1057923B924C92D@EXDCVYMBSTM005.EQ1STM.local>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 10 Sep 2012 15:48:57 +0300
Message-ID: <CAK=WgbZLjQVYFHcTkb+nDpYZx3qkWp=wQmOqOpMHCxroceTNpg@mail.gmail.com>
Subject: Re: Remoteproc: Translating between host and device addresses.
To: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Tue, Aug 14, 2012 at 8:06 PM, Sjur BRENDELAND
<sjur.brandeland@stericsson.com> wrote:
> One way for the device to figure out the translation between
> host-physical and device-address is to peek into some CarveOut
> resource entry and compute this translation. Because a CarveOut
> resource entry contains both the host-physical-address and the
> device address for the same memory location. But this feels
> like a workaround, shouldn't we make a more explicit way of
> communicating this mapping between host-physical and device
> addresses?

Yes, we should. The plan is, when relevant, to switch to the
IOMMU-based DMA API to allocate device addresses (by programming the
IOMMUs automatically), and stop sending physical addresses remotely.

For OMAP, btw, we will still provide those device->physical
translation resource entries, because OMAP4 has a few remote
components that access the host-physical memory directly.

Thanks,
Ohad.
