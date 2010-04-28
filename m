Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511Ab0D1GIM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 02:08:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56496 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338Ab0D1GIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 02:08:06 -0400
Date: Wed, 28 Apr 2010 16:08:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jason Baldus <jason.baldus@gmail.com>,
       H Hartley Sweeten <hartleys@visionengravers.com>
Subject: linux-next: manual merge of the staging-next tree with the
 staging.current tree
Message-Id: <20100428160803.29fc7fe8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the staging-next tree got a conflict in
drivers/staging/dt3155/dt3155_drv.c between commit
19ba984dd7d8dcf67cebc2ba55abbe454e318fb3 ("Staging: dt3155: fix 50Hz
configuration") from the staging.current tree and commit
da7bcc953ecf52d33b76b983ad5491d4d29f5f6a ("Staging: dt3155: fix
parentheses and bracket spacing style issues") from the staging-next tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/dt3155/dt3155_drv.c
index 7ac2c6d,993ed2f..0000000
--- a/drivers/staging/dt3155/dt3155_drv.c
+++ b/drivers/staging/dt3155/dt3155_drv.c
@@@ -464,9 -473,9 +465,9 @@@ static void dt3155_init_isr(int minor
    /* 50/60 Hz should be set before this point but let's make sure it is */
    /* right anyway */
  
-   ReadI2C(dt3155_lbase[ minor ], CSR2, &i2c_csr2.reg);
 -  ReadI2C(dt3155_lbase[minor], CONFIG, &i2c_csr2.reg);
++  ReadI2C(dt3155_lbase[minor], CSR2, &i2c_csr2.reg);
    i2c_csr2.fld.HZ50 = FORMAT50HZ;
-   WriteI2C(dt3155_lbase[ minor ], CSR2, i2c_csr2.reg);
 -  WriteI2C(dt3155_lbase[minor], CONFIG, i2c_config.reg);
++  WriteI2C(dt3155_lbase[minor], CSR2, i2c_csr2.reg);
  
    /* enable busmaster chip, clear flags */
  
