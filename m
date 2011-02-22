Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab1BVTrH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 14:47:07 -0500
Received: from mga03.intel.com ([143.182.124.21]:50087 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754763Ab1BVTrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 14:47:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,207,1297065600"; 
   d="scan'208";a="392483376"
From: "Luck, Tony" <tony.luck@intel.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 4/6] tty: now phase out the ioctl file pointer for good
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20110214162717.10571.70962.stgit@bob.linux.org.uk>
Date: Tue, 22 Feb 2011 11:47:04 -0800
Message-Id: <4d6412b86905e0230@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luck, Tony" <tony.luck@intel.com>

Alan missed the ia64 simulator serial driver (because it was hidden
in arch/... rather than located under drivers/... where one might
expect to find a driver).  Drop the "file *" argument from rs_ioctl()
in arch/ia64/hp/sim/simserial.c

Signed-off-by: Tony Luck <tony.luck@intel.com>

---

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index 13633da..bff0824 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -390,8 +390,7 @@ static void rs_unthrottle(struct tty_struct * tty)
 }
 
 
-static int rs_ioctl(struct tty_struct *tty, struct file * file,
-		    unsigned int cmd, unsigned long arg)
+static int rs_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
 {
 	if ((cmd != TIOCGSERIAL) && (cmd != TIOCSSERIAL) &&
 	    (cmd != TIOCSERCONFIG) && (cmd != TIOCSERGSTRUCT) &&
