Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757460Ab2IGNhf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 09:37:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:56395 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab2IGNhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 09:37:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 15/19] mfd: Don't convert just one IRQ using irqdomain if a range is provided
Date: Fri, 7 Sep 2012 13:37:26 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        Samuel Ortiz <sameo@linux.intel.com>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org> <201209071235.41785.arnd@arndb.de> <20120907124611.GD29601@gmail.com>
In-Reply-To: <20120907124611.GD29601@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201209071337.26587.arnd@arndb.de>
X-Provags-ID: V02:K0:3MpJZ753S0JWPOC8r3pijKBPbOe0eoiaYeILV3AHDuN
 Kc2qu29XRALykJrYuo3s+Xy6q8WiW1CP/pOlGpzXHGwrSPpVqh
 XdFc9cmoJpH5lwUKIBsdsYA6ACslm5SKXV5aKtJTerSrCDXyOk
 VLyfr98r+wtQmg0SMcpI/LsNweB98OinprFMBTLl96wJGHOxTq
 PG9VbSRynsqUvXFvUyUhf/AYQ5/g0Qf1PQYK6Qu9W2dMOhnvV8
 h3NKN3a1t/vMG2a2c7XNbsijqUpM9hVgoy0UDbfk7LLmmF1HNg
 DRYMLmVf/R5cKICVtSX9cQEdozyHAOEW1HU3cH/ZFrcu5aK6Of
 OJr0MMWsMIk0104NRGQs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 September 2012, Lee Jones wrote:
> On Fri, Sep 07, 2012 at 12:35:41PM +0000, Arnd Bergmann wrote:
> > On Friday 07 September 2012, Lee Jones wrote:
> > > MFD core code attempts to convert specified hardware (local) IRQ
> > > numbers to virtual-IRQs, which something Linux can understand. This
> > > works great when only one IRQ is specified. However, converting
> > > entire ranges is currently unsupported. If this occurs we issue a
> > > kernel warning to inform the user of this, but we continue to
> > > convert the first specified IRQ anyway and replace the range. This
> > > is not the correct behaviour. This patch ensures that if a range
> > > is specified, it is left untouched.
> > > 
> > > CC: Samuel Ortiz <sameo@linux.intel.com>
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > 
> > I don't see the advantage of the change. The warning already tells
> > us that the input to mfd_add_device was incorrect, so nothing the
> > function does can reliably fix it. Leaving the resource empty
> > is just as wrong as listing only the first interrupt.
> 
> My thinking was to leave them in a range, then have the target driver
> convert each entry in the range manually. But what you're saying is
> that no registration should be attempted using ranges at all? What if
> the range was vast? Surely a resource array a few hundred lines long
> isn't correct either? My immediate example would be "GPIO_INT6", which
> has 31 lines. Do you want them all splitting out individually?

The examples I had seen before were all just ranges of two interrupts,
and in those cases it was clear that splitting them would be best.

In the exampled of the ab8500-gpio driver, it looks like the resource is
not actually being used, and the gpio driver implements its own irq_chip,
so maybe we can get away with not solving this problem for now.

	Arnd
