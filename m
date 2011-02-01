Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377Ab1BAK7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 05:59:14 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43313 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab1BAK7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 05:59:13 -0500
Date: Tue, 1 Feb 2011 11:59:09 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        liu.y.victor@gmail.com, B02280@freescale.com
Subject: Re: [PATCH 3/9] Add a mfd IPUv3 driver
Message-ID: <20110201105909.GS9041@pengutronix.de>
References: <1292842127-21406-1-git-send-email-s.hauer@pengutronix.de>
 <1292842127-21406-4-git-send-email-s.hauer@pengutronix.de>
 <20110201105127.GA10128@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201105127.GA10128@sortiz-mobl>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:52:25 up 16 days, 20:59, 54 users,  load average: 0.14, 0.12,
 0.17
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 11:51:28AM +0100, Samuel Ortiz wrote:
> Hi Sascha,
> 
> On Mon, Dec 20, 2010 at 11:48:41AM +0100, Sascha Hauer wrote:
> > The IPU is the Image Processing Unit found on i.MX50/51/53 SoCs. It
> > features several units for image processing, this patch adds support
> > for the units needed for Framebuffer support, namely:
> > 
> > - Display Controller (dc)
> > - Display Interface (di)
> > - Display Multi Fifo Controller (dmfc)
> > - Display Processor (dp)
> > - Image DMA Controller (idmac)
> > 
> > This patch is based on the Freescale driver, but follows a different
> > approach. The Freescale code implements logical idmac channels and
> > the handling of the subunits is hidden in common idmac code pathes
> > in big switch/case statements. This patch instead just provides code
> > and resource management for the different subunits. The user, in this
> > case the framebuffer driver, decides how the different units play
> > together.
> > 
> > The IPU has other units missing in this patch:
> > 
> > - CMOS Sensor Interface (csi)
> > - Video Deinterlacer (vdi)
> > - Sensor Multi FIFO Controler (smfc)
> > - Image Converter (ic)
> > - Image Rotator (irt)
> > 
> > So expect more files to come in this directory.
> I couldn't look into details as the patch is huge, but it looks mostly good.
> One thing I don't really like is the
> 
> +static struct device *ipu_dev;
> +void __iomem *ipu_cm_reg;
> +void __iomem *ipu_idmac_reg;
> 
> part. I know there is currently no HW supporting more than one of those
> controllers, but as a general principle I find this is not a good programming
> habit.

Ok, will look into it.

> 
> Now, on a less technical note: I don't really see how this driver fits in the
> MFD category, unless the upcoming units support brings something new. If I
> were looking for the i.MX5x image processing unit, I would be looking under
> drivers/video/.

The ipu unit also supports cameras which would go to drivers/media/video.
This is the original reason for putting it into drivers/mfd. That said,
I'm not very comfortable with putting it there, mostly because it
contains a lot of code to which a mfd maintainer can hardly say anything
to and because it's one framework more which has to synchronized when
changes to the IPU come.

Thanks,
 Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
