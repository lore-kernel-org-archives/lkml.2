Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031889Ab2I1Vxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:53:54 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43081 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032028Ab2I1UXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:23:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [ 034/218] cciss: fix handling of protocol error
Date: Fri, 28 Sep 2012 13:14:11 -0700
Message-Id: <20120928201505.304687200@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>

commit 2453f5f992717251cfadab6184fbb3ec2f2e8b40 upstream.

If a command completes with a status of CMD_PROTOCOL_ERR, this
information should be conveyed to the SCSI mid layer, not dropped
on the floor.  Unlike a similar bug in the hpsa driver, this bug
only affects tape drives and CD and DVD ROM drives in the cciss
driver, and to induce it, you have to disconnect (or damage) a
cable, so it is not a very likely scenario (which would explain
why the bug has gone undetected for the last 10 years.)

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/cciss_scsi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/cciss_scsi.c
+++ b/drivers/block/cciss_scsi.c
@@ -795,6 +795,7 @@ static void complete_scsi_command(Comman
 				}
 			break;
 			case CMD_PROTOCOL_ERR:
+				cmd->result = DID_ERROR << 16;
 				dev_warn(&h->pdev->dev,
 					"%p has protocol error\n", c);
                         break;


