Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab2CESHZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 13:07:25 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:26524 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab2CESHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 13:07:24 -0500
Date: Mon, 5 Mar 2012 21:07:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch v2] tty: cyclades: TIOCSERGETLSR should should store to a uint
Message-ID: <20120305180711.GB26880@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F511DAD.1060108@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090206.4F5500D7.010E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

TIOCSERGETLSR should be saved in a uint so the cast here to unsigned
long is a bug.

Reported-by: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: completely different from v1.

diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index c9bf779..5575fee 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -2413,7 +2413,7 @@ static int get_lsr_info(struct cyclades_port *info, unsigned int __user *value)
 		/* Not supported yet */
 		return -EINVAL;
 	}
-	return put_user(result, (unsigned long __user *)value);
+	return put_user(result, value);
 }
 
 static int cy_tiocmget(struct tty_struct *tty)
