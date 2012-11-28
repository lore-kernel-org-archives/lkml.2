Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab2K1HJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 02:09:16 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:35377 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab2K1HJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 02:09:13 -0500
Date: Tue, 27 Nov 2012 23:09:09 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Christopher Heiny <cheiny@synaptics.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Linux Input <linux-input@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Allie Xiong <axiong@synaptics.com>, Vivian Ly <vly@synaptics.com>,
        Daniel Rosenberg <daniel.rosenberg@synaptics.com>,
        Alexandra Chin <alexandra.chin@tw.synaptics.com>,
        Joerie de Gram <j.de.gram@gmail.com>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Naveen Kumar Gaddipati <naveen.gaddipati@stericsson.com>
Subject: Re: [PATCH 1/4] Input RMI4 - rename rmi_function_container to
 rmi_function
Message-ID: <20121128070909.GD23378@core.coreip.homeip.net>
References: <1354008098-26346-1-git-send-email-dmitry.torokhov@gmail.com>
 <50B55009.9070904@synaptics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B55009.9070904@synaptics.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 03:43:05PM -0800, Christopher Heiny wrote:
> On 11/27/2012 01:21 AM, Dmitry Torokhov wrote:
> >To save my old fingers...
> >
> >Signed-off-by: Dmitry Torokhov<dmitry.torokhov@gmail.com>
> >---
> >
> >It looks like this driver(s) need some love and I might have some time so I
> >will refresh my "synaptics" branch with the patches you have sent and start
> >working off it. If you have updates I would appreciate if you also make them
> >available relative to that branch. When we are ready we'll squash them all
> >together and apply to the official branch.
> 
> No problem - let me know which branch/tag to work with, and we'll be
> happy to patch against that for the next round.

synaptics-rmi4. It is based off 3.7-rc6.


> 
> >
> >Thanks.
> >
> >  drivers/input/rmi4/rmi_driver.c | 158 +++++++++++----------
> >  drivers/input/rmi4/rmi_driver.h |   4 +-
> >  drivers/input/rmi4/rmi_f01.c    | 298 ++++++++++++++++++++--------------------
> >  drivers/input/rmi4/rmi_f11.c    | 258 +++++++++++++++++-----------------
> >  include/linux/rmi.h             |  22 ++-
> >  5 files changed, 368 insertions(+), 372 deletions(-)
> >
> >diff --git a/drivers/input/rmi4/rmi_driver.c b/drivers/input/rmi4/rmi_driver.c
> >index 05a73ae..e8a4b52 100644
> >--- a/drivers/input/rmi4/rmi_driver.c
> >+++ b/drivers/input/rmi4/rmi_driver.c
> >@@ -594,7 +594,7 @@ static struct device_attribute bsr_attribute = __ATTR(bsr, RMI_RW_ATTR,
> >
> >  static void rmi_free_function_list(struct rmi_device *rmi_dev)
> >  {
> >-	struct rmi_function_container *entry, *n;
> >+	struct rmi_function *entry, *n;
> >  	struct rmi_driver_data *data = dev_get_drvdata(&rmi_dev->dev);
> >
> >  	if (!data) {
> >@@ -613,44 +613,44 @@ static void rmi_free_function_list(struct rmi_device *rmi_dev)
> >  	}
> >  }
> >
> >-static void release_fc_device(struct device *dev)
> >+static void release_function_device(struct device *dev)
> >  {
> >  	dev_dbg(dev, "REMOVING KOBJ!");
> >  	kobject_put(&dev->kobj);
> >  }
> 
> Hmmm.  Since rmi_function_container has evolved into a child device
> of the RMI4 module, maybe it would be better renamed
> rmi_function_device or rmi_function_dev?  I find this clearer, but
> can live with just rmi_function if you prefer that.

I just prefer something reasonably short so I still like rmi_function or
something of similar length.

> 
> 
> Similarly, rmi_function_handler has evolved into a driver for such
> devices, so perhaps it should be renamed rmi_function_driver?

No preference here.

Thanks.

-- 
Dmitry
