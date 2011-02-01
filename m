Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab1BAKvc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 05:51:32 -0500
Received: from mga11.intel.com ([192.55.52.93]:25610 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290Ab1BAKvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 05:51:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,409,1291622400"; 
   d="scan'208";a="653203728"
Date: Tue, 1 Feb 2011 11:51:28 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        liu.y.victor@gmail.com, B02280@freescale.com
Subject: Re: [PATCH 3/9] Add a mfd IPUv3 driver
Message-ID: <20110201105127.GA10128@sortiz-mobl>
References: <1292842127-21406-1-git-send-email-s.hauer@pengutronix.de>
 <1292842127-21406-4-git-send-email-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292842127-21406-4-git-send-email-s.hauer@pengutronix.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

On Mon, Dec 20, 2010 at 11:48:41AM +0100, Sascha Hauer wrote:
> The IPU is the Image Processing Unit found on i.MX50/51/53 SoCs. It
> features several units for image processing, this patch adds support
> for the units needed for Framebuffer support, namely:
> 
> - Display Controller (dc)
> - Display Interface (di)
> - Display Multi Fifo Controller (dmfc)
> - Display Processor (dp)
> - Image DMA Controller (idmac)
> 
> This patch is based on the Freescale driver, but follows a different
> approach. The Freescale code implements logical idmac channels and
> the handling of the subunits is hidden in common idmac code pathes
> in big switch/case statements. This patch instead just provides code
> and resource management for the different subunits. The user, in this
> case the framebuffer driver, decides how the different units play
> together.
> 
> The IPU has other units missing in this patch:
> 
> - CMOS Sensor Interface (csi)
> - Video Deinterlacer (vdi)
> - Sensor Multi FIFO Controler (smfc)
> - Image Converter (ic)
> - Image Rotator (irt)
> 
> So expect more files to come in this directory.
I couldn't look into details as the patch is huge, but it looks mostly good.
One thing I don't really like is the

+static struct device *ipu_dev;
+void __iomem *ipu_cm_reg;
+void __iomem *ipu_idmac_reg;

part. I know there is currently no HW supporting more than one of those
controllers, but as a general principle I find this is not a good programming
habit.

Now, on a less technical note: I don't really see how this driver fits in the
MFD category, unless the upcoming units support brings something new. If I
were looking for the i.MX5x image processing unit, I would be looking under
drivers/video/.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
