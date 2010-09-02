Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab0IBOek (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 10:34:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:50097 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793Ab0IBOej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 10:34:39 -0400
Date: Thu, 2 Sep 2010 16:34:36 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, JiebingLi <jiebing.li@intel.com>,
        Joe Perches <joe@perches.com>
Subject: Re: linux-next: manual merge of the usb tree with the trivial tree
In-Reply-To: <20100902032604.GB27598@kroah.com>
Message-ID: <alpine.LNX.2.00.1009021633020.26813@pobox.suse.cz>
References: <20100902130118.add62d4a.sfr@canb.auug.org.au> <20100902032604.GB27598@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Sep 2010, Greg KH wrote:

> > Today's linux-next merge of the usb tree got a conflict in
> > drivers/usb/gadget/langwell_udc.c between commit
> > 7f26b3a7533bbc1ddd88b297c935ee4da8f74cea ("drivers/usb: Remove
> > unnecessary return's from void functions") from the trivial tree and
> > commit 0f92bbacd2d1a26e8bf863d2cc05572df43bf7fb ("USB: langwell: USB
> > Client driver code cleanup") from the usb tree.
> > 
> > Just context changes.  I fixed it up (see below) and can carry the fix
> > while necessary.  Though, if that trivial tree commit was in the usb tree,
> > the conflict could be resolved there ...
> 
> Joe, care to break this one change out and have me take it through the
> usb tree?

Here it goes. I will revert this chunk in trivial tree for now.


From: Joe Perches <joe@perches.com>
Subject: drivers/usb: langwell: Remove unnecessary return's from void functions

There are about 2500 void functions in drivers/usb
Only a few used return; at end of function.

Standardize them a bit.

Signed-off-by: Joe Perches <joe@perches.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/drivers/usb/gadget/langwell_udc.c b/drivers/usb/gadget/langwell_udc.c
index a391351..f1a0702 100644
--- a/drivers/usb/gadget/langwell_udc.c
+++ b/drivers/usb/gadget/langwell_udc.c
@@ -284,7 +284,6 @@ static void ep0_reset(struct langwell_udc *dev)
 	}
 
 	VDBG(dev, "<--- %s()\n", __func__);
-	return;
 }
 
 
@@ -1486,7 +1485,6 @@ static void langwell_udc_start(struct langwell_udc *dev)
 	writel(usbcmd, &dev->op_regs->usbcmd);
 
 	DBG(dev, "<--- %s()\n", __func__);
-	return;
 }
 
 
@@ -1509,7 +1507,6 @@ static void langwell_udc_stop(struct langwell_udc *dev)
 	writel(usbcmd, &dev->op_regs->usbcmd);
 
 	DBG(dev, "<--- %s()\n", __func__);
-	return;
 }
 
 

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
