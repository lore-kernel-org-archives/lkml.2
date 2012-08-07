Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755089Ab2HGNZQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 09:25:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45185 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754700Ab2HGNZN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 09:25:13 -0400
Date: Tue, 7 Aug 2012 14:25:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, sameo@linux.intel.com,
        rpurdie@rpsys.net, bryan.wu@canonical.com,
        linux-kernel@vger.kernel.org, Bergmann Arnd <arnd@arndb.de>
Subject: Re: [PATCH 0/5] mfd: replace IORESOURCE_IO by IORESOURCE_MEM
Message-ID: <20120807132510.GE16861@opensource.wolfsonmicro.com>
References: <20120806213124.GB14594@flint.arm.linux.org.uk>
 <20120806220032.GD26698@opensource.wolfsonmicro.com>
 <CAN1soZzSz9Gs_SsTd_5BOFNjUviZgBjBiGCjt1EsAtkS5XquQA@mail.gmail.com>
 <20120807103851.GS16861@opensource.wolfsonmicro.com>
 <20120807111331.GC24257@flint.arm.linux.org.uk>
 <20120807112844.GZ16861@opensource.wolfsonmicro.com>
 <20120807113121.GD24257@flint.arm.linux.org.uk>
 <20120807113801.GB16861@opensource.wolfsonmicro.com>
 <20120807114415.GG24257@flint.arm.linux.org.uk>
 <20120807121157.GA10166@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120807121157.GA10166@flint.arm.linux.org.uk>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 01:11:57PM +0100, Russell King wrote:

> The only open questions on this are:
> 1. Is there another driver you are concerned about.

As I said elsewhere 88pm* needs this as a stable bugfix and wm831x
should be converted over too.

> 2. Choosing a better name.

I'm not sure we need one, _REG seems perfectly fine here unless we want
to go with Arnd's suggestion of _OTHER.  Do you have any concerns with
the use of reg?

> But I won't put question marks at the end of those because you never seem
> to answer questions.  You will just produce yet more justifications why
> this approach is not one you're willing to accept.  So I really don't know
> why I wasted my time to produce this patch.

As I mentioned in my mail a few moments ago I had not replied to your
mails asking these question about which drivers are affected because
those mails have been arriving so quickly since the first one I saw with
the question in that there has not been a chance to do so.

> index 589e0e7..bfee885 100644
> --- a/include/linux/ioport.h
> +++ b/include/linux/ioport.h
> @@ -31,6 +31,7 @@ struct resource {
>  #define IORESOURCE_TYPE_BITS	0x00001f00	/* Resource type */
>  #define IORESOURCE_IO		0x00000100
>  #define IORESOURCE_MEM		0x00000200
> +#define IORESOURCE_REG		0x00000300	/* Register offsets */
>  #define IORESOURCE_IRQ		0x00000400
>  #define IORESOURCE_DMA		0x00000800
>  #define IORESOURCE_BUS		0x00001000

As I've said before I'm fine with the driver changes.  I do feel that it
would be better to also renumber all the existing resource types while
we're at it in order to make it clear that these are just plain numbers,
that's the reason nobody wrote this patch previously.  This will avoid
any future confusion.
