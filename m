Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252Ab2JHKtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 06:49:07 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:59804 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab2JHKtF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 06:49:05 -0400
MIME-Version: 1.0
In-Reply-To: <1349691428.10584.95.camel@smile>
References: <1348731121-2515-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348731121-2515-6-git-send-email-andriy.shevchenko@linux.intel.com>
	<1348735450.1648.5.camel@vkoul-udesk3>
	<1348739022.13371.157.camel@smile>
	<1348740071.1648.25.camel@vkoul-udesk3>
	<CAOh2x=ntwp22Z3sHf9QehVwab--ZayF-kmTpZsjbkyQYVxrzpw@mail.gmail.com>
	<1349691428.10584.95.camel@smile>
Date: Mon, 8 Oct 2012 16:19:04 +0530
Message-ID: <CAKohpokGsAv2cPjj2EMvmTmN1Q+LOU7mN0H9YZcGzs95mm6c-w@mail.gmail.com>
Subject: Re: [PATCHv3 5/7] dmaengine: dw_dmac: add PCI part of the driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Vinod Koul <vinod.koul@linux.intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 October 2012 15:47, Andy Shevchenko
<andriy.shevchenko@linux.intel.com> wrote:
> This approach has the significant differences to proposed before.

I am afraid i didn't get your mail completely. Still i will try based on my
understanding.

> First of all it will export IP-block relevant functions to the kernel
> namespace. I think it is not a good idea to pollute kernel more.

So, few routines which are required to be called from probe,
suspend/resume and exit would be made non-static... This is what you
wanted to say? Hopefully most of the routines would still be declared
static in the core file. So IMHO, the simplicity or clarity that new approach
gives has more advantages than this aspect.

> Moreover the API dependencies disallow transparent build and usage of
> the drivers. For example, you can't built-in platform driver and leave
> core part as a module.

Obviously... Should be done this way only... What if core driver isn't inserted
and platform's probe is already called. That's why depends-on should not
allow you to make core part as module alone...

I couldn't get the issue completely. What's the problem in this approach?

> And there is at least one device, Intel Medfield,
> where DMA controller is exposed as PCI device on fake PCI bus. In that
> case the initialization sequence matters and the easier way is to
> provide independent drivers for platform device.

Couldn't get this one :(

--
viresh
