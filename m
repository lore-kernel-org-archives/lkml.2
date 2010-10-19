Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab0JSJy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:54:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49831 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751375Ab0JSJy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:54:28 -0400
Date: Tue, 19 Oct 2010 02:53:54 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 2/2] mfd: Add WM831x SPI support
Message-ID: <20101019095347.GC11371@opensource.wolfsonmicro.com>
References: <1286573003-13889-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1286573003-13889-2-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20101019094422.GG2736@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019094422.GG2736@sortiz-mobl>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 11:44:23AM +0200, Samuel Ortiz wrote:

> > +static int wm831x_spi_write_device(struct wm831x *wm831x, unsigned short reg,
> > +				   int bytes, void *src)
> > +{
> > +	struct spi_device *spi = wm831x->control_data;
> > +	u16 *s = src;
> > +	u16 data[2];
> > +	int ret;
> > +
> > +	/* Go register at a time */
> > +	for (r = reg; r < reg + (bytes / 2); r++) {
> > +		data[0] = r;

Oh, gah.  We need an extra int r here, I've obviously stuffed up the
move from the BSP I was working on.  Sorry about that:

>From b7fc0d8ff8c96fabf531d685bda7c3d5b8c51f35 Mon Sep 17 00:00:00 2001
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Tue, 19 Oct 2010 02:53:08 -0700
Subject: [PATCH] mfd: Fix missing variable in WM831x SPI

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/mfd/wm831x-spi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/mfd/wm831x-spi.c b/drivers/mfd/wm831x-spi.c
index 073d4c6..2789b15 100644
--- a/drivers/mfd/wm831x-spi.c
+++ b/drivers/mfd/wm831x-spi.c
@@ -48,7 +48,7 @@ static int wm831x_spi_write_device(struct wm831x *wm831x, unsigned short reg,
 	struct spi_device *spi = wm831x->control_data;
 	u16 *s = src;
 	u16 data[2];
-	int ret;
+	int ret, r;
 
 	/* Go register at a time */
 	for (r = reg; r < reg + (bytes / 2); r++) {
-- 
1.7.1

