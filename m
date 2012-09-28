Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890Ab2I1MZy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:25:54 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30677 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757865Ab2I1MZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:25:52 -0400
Date: Fri, 28 Sep 2012 15:25:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: smani@micron.com
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: re: mtip32xx:Added appropriate timeout value for secure erase
Message-ID: <20120928122531.GA9260@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Selvan Mani,

The patch 75e152877069: "mtip32xx:Added appropriate timeout value for 
secure erase" from Sep 27, 2012, leads to the following warning:
drivers/block/mtip32xx/mtip32xx.c:2222 exec_drive_taskfile()
	 error: potential NULL dereference 'outbuf'.

  2220          /* check for erase mode support during secure erase.*/
  2221          if ((fis.command == ATA_CMD_SEC_ERASE_UNIT)
  2222                                          && (outbuf[0] & MTIP_SEC_ERASE_MODE)) {
                                                    ^^^^^^
Smatch complains that if taskout is zero this is a NULL dereference.
Obviously that's not normal, but it looks like it might be possible.

  2223                  erasemode = 1;
  2224          }

regards,
dan carpenter

