Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752916Ab3AFUBF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 15:01:05 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:29434
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752175Ab3AFUBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 15:01:03 -0500
X-IronPort-AV: E=Sophos;i="4.84,420,1355094000"; 
   d="scan'208";a="167555757"
Date: Sun, 6 Jan 2013 21:00:59 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: nsekhar@ti.com, khilman@ti.com, w.sang@pengutronix.de, ben-linux@fluff.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: question about drivers/i2c/busses/i2c-davinci.c
Message-ID: <alpine.DEB.2.02.1301062057260.2029@localhost6.localdomain6>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function davinci_i2c_remove in drivers/i2c/busses/i2c-davinci.c 
contains the following code:

         put_device(&pdev->dev);

         clk_disable_unprepare(dev->clk);
         clk_put(dev->clk);
         dev->clk = NULL;

         davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, 0);
 	free_irq(dev->irq, dev);

Is there any danger in putting free_irq(dev->irq, dev); after 
put_device(&pdev->dev);, because the interrupt handler i2c_davinci_isr can 
eg refer to dev->dev.

thanks,
julia
