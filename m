Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab2CGKFL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 05:05:11 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:34294 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab2CGKFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 05:05:09 -0500
Date: Wed, 7 Mar 2012 13:05:00 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] tty: moxa: fix bit test in moxa_start()
Message-ID: <20120307100500.GD25452@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090205.4F5732D3.0058,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is supposed to be doing a shift before the comparison instead of
just doing a bitwise AND directly.  The current code means the start()
just returns without doing anything.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index d15a071..0174d2d 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -1331,7 +1331,7 @@ static void moxa_start(struct tty_struct *tty)
 	if (ch == NULL)
 		return;
 
-	if (!(ch->statusflags & TXSTOPPED))
+	if (!test_bit(TXSTOPPED, &ch->statusflags))
 		return;
 
 	MoxaPortTxEnable(ch);
