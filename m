Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129Ab2IGNnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:43:10 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:61996 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315Ab2IGNnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:43:06 -0400
Date: Fri, 7 Sep 2012 14:43:01 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH 15/19] mfd: Don't convert just one IRQ using irqdomain if
 a range is provided
Message-ID: <20120907134259.GJ29601@gmail.com>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
 <201209071235.41785.arnd@arndb.de>
 <20120907124611.GD29601@gmail.com>
 <201209071337.26587.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201209071337.26587.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 07, 2012 at 01:37:26PM +0000, Arnd Bergmann wrote:
> On Friday 07 September 2012, Lee Jones wrote:
> > On Fri, Sep 07, 2012 at 12:35:41PM +0000, Arnd Bergmann wrote:
> > > On Friday 07 September 2012, Lee Jones wrote:
> > > > MFD core code attempts to convert specified hardware (local) IRQ
> > > > numbers to virtual-IRQs, which something Linux can understand. This
> > > > works great when only one IRQ is specified. However, converting
> > > > entire ranges is currently unsupported. If this occurs we issue a
> > > > kernel warning to inform the user of this, but we continue to
> > > > convert the first specified IRQ anyway and replace the range. This
> > > > is not the correct behaviour. This patch ensures that if a range
> > > > is specified, it is left untouched.
> > > > 
> > > > CC: Samuel Ortiz <sameo@linux.intel.com>
> > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > 
> > > I don't see the advantage of the change. The warning already tells
> > > us that the input to mfd_add_device was incorrect, so nothing the
> > > function does can reliably fix it. Leaving the resource empty
> > > is just as wrong as listing only the first interrupt.
> > 
> > My thinking was to leave them in a range, then have the target driver
> > convert each entry in the range manually. But what you're saying is
> > that no registration should be attempted using ranges at all? What if
> > the range was vast? Surely a resource array a few hundred lines long
> > isn't correct either? My immediate example would be "GPIO_INT6", which
> > has 31 lines. Do you want them all splitting out individually?
> 
> The examples I had seen before were all just ranges of two interrupts,
> and in those cases it was clear that splitting them would be best.
> 
> In the exampled of the ab8500-gpio driver, it looks like the resource is
> not actually being used, and the gpio driver implements its own irq_chip,
> so maybe we can get away with not solving this problem for now.

Understood. I'd still feel more comfortable if we didn't trash the
range. I think it would be best to show the warning, and leave the
range for its target driver to take care - hence the patch.

... but it's your call.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
