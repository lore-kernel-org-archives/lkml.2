Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab2CEPgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 10:36:11 -0500
Received: from mx.atlanta.gplhost.com ([117.121.247.104]:37647 "EHLO
	mx.atlanta.gplhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab2CEPgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 10:36:10 -0500
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Mar 2012 10:36:10 EST
Message-ID: <4F54DB1F.3080000@debian.org>
Date: Mon, 05 Mar 2012 23:26:23 +0800
From: Thomas Goirand <zigo@debian.org>
Organization: Debian
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: Jonathan Nieder <jrnieder@gmail.com>, xen-devel@lists.xensource.com,
        pkg-xen-devel@lists.alioth.debian.org,
        Maciej Sosnowski <maciej.sosnowski@intel.com>,
        linux-kernel@vger.kernel.org, William Dauchy <wdauchy@gmail.com>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Dave Jiang <dave.jiang@intel.com>
Subject: Re: [Pkg-xen-devel] ioatdma: Boot process hangs then reboots when
 using Xen + Linux 3.2
References: <CAJ75kXZ-2vWZpG7Uz3firg6ew4y_DdorXotkAkUGSK0GWLMUQQ@mail.gmail.com>	<20120127144737.GA27750@andromeda.dapyr.net>	<20120219223125.GA820@burratino> <20120220181618.GD17566@burratino>	<4F4891B8.9050008@goirand.fr> <20120302055715.GA692@burratino>	<CABE8wwt8Lngy=-iL7QGCofy0nW5-q4VJDS_ovEr96fGdYm72ew@mail.gmail.com>	<20120302162159.GB31683@wavehammer.waldi.eu.org>	<CABE8wwtrMEAMw3sJgb8XWQWn_N=YOPzhNbLL0kzMKLhv7xt5=A@mail.gmail.com>	<20120302175719.GA1468@wavehammer.waldi.eu.org> <CABE8wwvd-R1VkyFL-eZYDB9O05zyWkVQ8pXuMb8GcdAW=5qT3A@mail.gmail.com>
In-Reply-To: <CABE8wwvd-R1VkyFL-eZYDB9O05zyWkVQ8pXuMb8GcdAW=5qT3A@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2012 03:31 AM, Dan Williams wrote:
> Can you send the log of the driver load with debug enabled?
> 
> diff --git a/drivers/dma/ioat/dma.c b/drivers/dma/ioat/dma.c
> index a4d6cb0..82472de 100644
> --- a/drivers/dma/ioat/dma.c
> +++ b/drivers/dma/ioat/dma.c
> @@ -24,7 +24,7 @@
>   * This driver supports an Intel I/OAT DMA engine, which does asynchronous
>   * copy operations.
>   */
> -
> +#define DEBUG
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>
> diff --git a/drivers/dma/ioat/dma_v2.c b/drivers/dma/ioat/dma_v2.c
> index 5d65f83..da337e7 100644
> --- a/drivers/dma/ioat/dma_v2.c
> +++ b/drivers/dma/ioat/dma_v2.c
> @@ -24,7 +24,7 @@
>   * This driver supports an Intel I/OAT DMA engine (versions >= 2), which
>   * does asynchronous data movement and checksumming operations.
>   */
> -
> +#define DEBUG
>  #include <linux/init.h>
>  #include <linux/module.h>
>  #include <linux/slab.h>

I will do my best to provide it ASAP. Should I compile with BUG_ON so
you see it crashing, as per the original code, or just with WARN_ON, so
you also see further things in dmesg?

Thomas
