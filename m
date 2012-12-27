Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab2L0WPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 17:15:48 -0500
Received: from casper.infradead.org ([85.118.1.10]:57356 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab2L0WPr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 17:15:47 -0500
Date: Thu, 27 Dec 2012 20:15:12 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Fabio Estevam <fabio.estevam@freescale.com>, kernel@pengutronix.de,
        p.zabel@pengutronix.de, javier.martin@vista-silicon.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] coda: Fix build due to iram.h rename
Message-ID: <20121227201512.0a5c5828@infradead.org>
In-Reply-To: <20121217093714.GI26326@pengutronix.de>
References: <1352898282-21576-1-git-send-email-fabio.estevam@freescale.com>
	<20121217093714.GI26326@pengutronix.de>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.13; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 17 Dec 2012 10:37:14 +0100
Sascha Hauer <s.hauer@pengutronix.de> escreveu:

> On Wed, Nov 14, 2012 at 11:04:42AM -0200, Fabio Estevam wrote:
> > commit c045e3f13 (ARM: imx: include iram.h rather than mach/iram.h) changed the
> > location of iram.h, which causes the following build error when building the coda
> > driver:
> > 
> > drivers/media/platform/coda.c:27:23: error: mach/iram.h: No such file or directory
> > drivers/media/platform/coda.c: In function 'coda_probe':
> > drivers/media/platform/coda.c:2000: error: implicit declaration of function 'iram_alloc'
> > drivers/media/platform/coda.c:2001: warning: assignment makes pointer from integer without a cast
> > drivers/media/platform/coda.c: In function 'coda_remove':
> > drivers/media/platform/coda.c:2024: error: implicit declaration of function 'iram_free
> > 
> > Since the content of iram.h is not imx specific, move it to include/linux/iram.h
> > instead.
> 
> Generally we need a fix for this, but:
> 
> > diff --git a/arch/arm/mach-imx/iram.h b/include/linux/iram.h
> > similarity index 100%
> > rename from arch/arm/mach-imx/iram.h
> > rename to include/linux/iram.h
> 
> We shouldn't introduce a file include/linux/iram.h which is purely i.MX
> specific. The name is far too generic. I would rather suggest
> include/linux/platform_data/imx-iram.h (Although it's not exactly
> platform_data, so I'm open for better suggestions).
> 
> As a side note this i.MX specific iram stuff (hopefully) is obsolete
> after the next merge window as Philip already has patches for a generic
> iram allocator which didn't make it into this merge window.

Hi Sasha,

This compilation breakage seems to still be happening.

Just tested here with arm32 "allmodconfig", on a tree based on Linus one,
with -next and -media patches applied on it:

drivers/media//platform/coda.c:27:23: fatal error: mach/iram.h: No such file or directory
compilation terminated.

I don't mind how this would be named, but this should be fixed somehow ;)

Regards,
Mauro
