Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932640Ab0EYJ4G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 05:56:06 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:57716 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632Ab0EYJ4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 05:56:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=kWkE/ZpITS4m6VYa9pYiYnCqQVR3qjZe8tIWjAGWVyXjDqSOe4XPAp+IWUhUwS/uly
         OpvZQPRXim3TYZwxhJAWJPwy/eOY78qotBoksMKaTVpmHfGcOhSUo4v2DktrqcbMZ61B
         Y+G45rGxhNhEr0mIKFLZiaUhLw3zo4bNTheQI=
Date: Tue, 25 May 2010 11:55:06 +0200
From: Dan Carpenter <error27@gmail.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Richard =?iso-8859-1?Q?R=F6jfors?= 
	<richard.rojfors@pelagicore.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch 2/2] dma/timb_dma: compile warning on 32 bit
Message-ID: <20100525095506.GJ22515@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Linus Walleij <linus.walleij@stericsson.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>,
	Richard =?iso-8859-1?Q?R=F6jfors?= <richard.rojfors@pelagicore.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This silences a compile warning on 32 bit systems:
drivers/dma/timb_dma.c:203: warning: cast to pointer from integer of different size

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/dma/timb_dma.c b/drivers/dma/timb_dma.c
index 0172fa3..debc2b7 100644
--- a/drivers/dma/timb_dma.c
+++ b/drivers/dma/timb_dma.c
@@ -200,8 +200,8 @@ static int td_fill_desc(struct timb_dma_chan *td_chan, u8 *dma_desc,
 		return -EINVAL;
 	}
 
-	dev_dbg(chan2dev(&td_chan->chan), "desc: %p, addr: %p\n",
-		dma_desc, (void *)sg_dma_address(sg));
+	dev_dbg(chan2dev(&td_chan->chan), "desc: %p, addr: 0x%llx\n",
+		dma_desc, (unsigned long long)sg_dma_address(sg));
 
 	dma_desc[7] = (sg_dma_address(sg) >> 24) & 0xff;
 	dma_desc[6] = (sg_dma_address(sg) >> 16) & 0xff;

