Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab2JJJVK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 05:21:10 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43730 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931Ab2JJJVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 05:21:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAOh2x=mNiL4k=v3YGexq7YMZUx131QWBpm11QXupnWLUPuKU4Q@mail.gmail.com>
References: <1349178121-9105-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<1349178121-9105-2-git-send-email-andriy.shevchenko@linux.intel.com>
	<1349859841.10584.122.camel@smile>
	<CAOh2x=mNiL4k=v3YGexq7YMZUx131QWBpm11QXupnWLUPuKU4Q@mail.gmail.com>
Date: Wed, 10 Oct 2012 12:21:04 +0300
Message-ID: <CAHp75VePqj3FViNrOcicHXhv9BzhJQgSg6KvA31HmdEFf7BXOg@mail.gmail.com>
Subject: Re: [PATCH 1/4] dmaengine: dw_dmac: use helper macro module_platform_driver()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: viresh kumar <viresh.kumar@linaro.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Vinod Koul <vinod.koul@intel.com>, linux-kernel@vger.kernel.org,
        spear-devel <spear-devel@list.st.com>, balbi@ti.com,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 12:08 PM, viresh kumar <viresh.kumar@linaro.org> wrote:
> On Wed, Oct 10, 2012 at 2:34 PM, Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:
>> On Tue, 2012-10-02 at 14:41 +0300, Andy Shevchenko wrote:
>>> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>>>
>>> Since v3.2 we have nice macro to define the platform driver's init and exit
>>> calls. This patch simplifies the dw_dmac driver by using that macro.
>>
>> Actually we can't do this. It will break initialization of some other
>> drivers.
>
> why?

We have spi, i2c and hsuart devices connected to the DMA controller.
In case we would like to use DMA we have to have the dw_dmac loaded
before them. Currently we have spi driver on subsys_initcall level,
and Mika, who is developing it, will change to module_init_call level.
However, it will just hide the potential issue. He also tried to use
deferred module loading, but we don't know if it's good solution or
not, and that solution requires something to stop deferring at some
moment.

Might be we missed something and there is a better solution.

-- 
With Best Regards,
Andy Shevchenko
