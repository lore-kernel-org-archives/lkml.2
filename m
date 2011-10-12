Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269Ab1JLOw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 10:52:57 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46008 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633Ab1JLOwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 10:52:43 -0400
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] cy82c693: fix PCI device selection
Date: Wed, 12 Oct 2011 16:52:10 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.37.6-0.7-desktop-dirty; KDE/4.6.0; x86_64; ; )
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201110111937.32501.bzolnier@gmail.com> <20111011.152040.662786307819949300.davem@davemloft.net>
In-Reply-To: <20111011.152040.662786307819949300.davem@davemloft.net>
MIME-Version: 1.0
Message-Id: <201110121652.10495.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller wrote:

> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Date: Tue, 11 Oct 2011 19:37:32 +0200
> 
> > While at it remove redundant pci_get_slot() call as cy82c693_init_one()
> > already takes care of keeping the reference on the second port's PCI
> > device.
> 
> Please do not submit unrelated changes with a bug fix, and as IDE is
> in long-term maintainence I would not accept a risky refinement like
> this anyways.

Removed code is just bogus, we cannot fail in ->set_pio_mode method.

Please take a look at the code:
 
-	/* select primary or secondary channel */
-	if (hwif->index > 0) {  /* drive is on the secondary channel */
-		dev = pci_get_slot(dev->bus, dev->devfn+1);
-		if (!dev) {
-			printk(KERN_ERR "%s: tune_drive: "
-				"Cannot find secondary interface!\n",
-				drive->name);
-			return;
-		}
-	}

Please apply the patch, libata's pata_cypress doesn't support secondary
port currently and cy82c693 driver is the only way to use this hardware.
