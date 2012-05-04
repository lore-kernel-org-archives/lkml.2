Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760189Ab2EDVNF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 17:13:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44823 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364Ab2EDUpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 16:45:52 -0400
Message-Id: <20120504204227.646162655@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 04 May 2012 13:43:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stephen Warren <swarren@nvidia.com>
Subject: [ 38/75] USB: ehci-tegra: remove redundant gpio_set_value
In-Reply-To: <20120504204258.GA12552@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit 04c235c92ce8474e9f2b358bd97f013a500385f2 upstream.

The immediately preceding gpio_direction_output() already set the value,
so there's no need to repeat it. This also prevents gpio_set_value() from
WARNing when the GPIO is sleepable (e.g. is on an I2C expander); the set
direction API is always sleepable, but plain set_value isn't.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-tegra.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/usb/host/ehci-tegra.c
+++ b/drivers/usb/host/ehci-tegra.c
@@ -601,7 +601,6 @@ static int setup_vbus_gpio(struct platfo
 		dev_err(&pdev->dev, "can't enable vbus\n");
 		return err;
 	}
-	gpio_set_value(gpio, 1);
 
 	return err;
 }


