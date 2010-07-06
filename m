Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab0GFCBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 22:01:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41339 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752354Ab0GFCBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 22:01:18 -0400
Date: Tue, 6 Jul 2010 12:01:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>
Subject: linux-next: manual merge of the v4l-dvb tree with Linus' tree
Message-Id: <20100706120113.407d588c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

Today's linux-next merge of the v4l-dvb tree got a conflict in
drivers/staging/tm6000/tm6000-alsa.c between commit
4ef09889d7b4c7be2aa3e132efb77029f51c95b7 ("v4l-dvb: update gfp/slab.h
includes") from Linus' tree and commit
813605a98db924123530784d29964e99a705482d ("tm6000-alsa: rework audio
buffer allocation/deallocation") from the v4l-dvb tree.

Just overlapping additions.  I fixed ti up (see below) and can carry the
fix for a while.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/tm6000/tm6000-alsa.c
index 273e26e,aa38577..0000000
--- a/drivers/staging/tm6000/tm6000-alsa.c
+++ b/drivers/staging/tm6000/tm6000-alsa.c
@@@ -15,7 -15,7 +15,8 @@@
  #include <linux/device.h>
  #include <linux/interrupt.h>
  #include <linux/usb.h>
 +#include <linux/slab.h>
+ #include <linux/vmalloc.h>
  
  #include <asm/delay.h>
  #include <sound/core.h>
