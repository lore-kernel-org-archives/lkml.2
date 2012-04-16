Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab2DPLM4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 07:12:56 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:39418 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab2DPLMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 07:12:55 -0400
Date: Mon, 16 Apr 2012 14:12:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: asamymuthupa@micron.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: re: mtip32xx: Add new bitwise flag 'dd_flag'
Message-ID: <20120416111245.GA26187@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090204.4F8BFEB3.00A2,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Asai Thambi S P,

The patch 45038367c271: "mtip32xx: Add new bitwise flag 'dd_flag'"
from Apr 9, 2012, leads to the following Smatch warning:
drivers/block/mtip32xx/mtip32xx.c:2516 mtip_hw_get_scatterlist()
	 warn: inconsistent returns sem:&dd->port->cmd_slot: locked (2514,2516) unlocked ()

@@ -2193,6 +2245,10 @@ static struct scatterlist *mtip_hw_get_scatterlist(struct driver_data *dd,
        down(&dd->port->cmd_slot);
        *tag = get_slot(dd->port);
 
+       if (unlikely(test_bit(MTIP_DD_FLAG_REMOVE_PENDING_BIT, &dd->dd_flag))) {
+               up(&dd->port->cmd_slot);
                ^^^^^^^^^^^^^^^^^^^^^^^
We release the lock here.

+               return NULL;
+       }
        if (unlikely(*tag < 0))
                return NULL;
                ^^^^^^^^^^^^
Should we release it here as well?

regards,
dan carpenter

