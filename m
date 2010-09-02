Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab0IBDB0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 23:01:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53246 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469Ab0IBDBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 23:01:25 -0400
Date: Thu, 2 Sep 2010 13:01:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        JiebingLi <jiebing.li@intel.com>, Joe Perches <joe@perches.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: linux-next: manual merge of the usb tree with the trivial tree
Message-Id: <20100902130118.add62d4a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
drivers/usb/gadget/langwell_udc.c between commit
7f26b3a7533bbc1ddd88b297c935ee4da8f74cea ("drivers/usb: Remove
unnecessary return's from void functions") from the trivial tree and
commit 0f92bbacd2d1a26e8bf863d2cc05572df43bf7fb ("USB: langwell: USB
Client driver code cleanup") from the usb tree.

Just context changes.  I fixed it up (see below) and can carry the fix
while necessary.  Though, if that trivial tree commit was in the usb tree,
the conflict could be resolved there ...
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/usb/gadget/langwell_udc.c
index d41b69c,1ef17a6..0000000
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@@ -283,7 -253,8 +253,7 @@@ static void ep0_reset(struct langwell_u
  		ep_reset(&dev->ep[0], 0, i, USB_ENDPOINT_XFER_CONTROL);
  	}
  
- 	VDBG(dev, "<--- %s()\n", __func__);
+ 	dev_vdbg(&dev->pdev->dev, "<--- %s()\n", __func__);
 -	return;
  }
  
  
@@@ -1484,7 -1501,8 +1500,7 @@@ static void langwell_udc_start(struct l
  	usbcmd |= CMD_RUNSTOP;
  	writel(usbcmd, &dev->op_regs->usbcmd);
  
- 	DBG(dev, "<--- %s()\n", __func__);
+ 	dev_dbg(&dev->pdev->dev, "<--- %s()\n", __func__);
 -	return;
  }
  
  
@@@ -1506,7 -1524,8 +1522,7 @@@ static void langwell_udc_stop(struct la
  	usbcmd &= ~CMD_RUNSTOP;
  	writel(usbcmd, &dev->op_regs->usbcmd);
  
- 	DBG(dev, "<--- %s()\n", __func__);
+ 	dev_dbg(&dev->pdev->dev, "<--- %s()\n", __func__);
 -	return;
  }
  
  
