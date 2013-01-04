Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754022Ab3ADSzP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 13:55:15 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:26791 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab3ADSzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 13:55:12 -0500
Date: Fri, 4 Jan 2013 21:54:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] compat: return -EFAULT on error in waitid()
Message-ID: <20130104185451.GA2038@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The copy_to_user() call returns the number of bytes remaining but we
want to return -EFAULT on error.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Only needed in linux-next.

diff --git a/kernel/compat.c b/kernel/compat.c
index de6f324..19971d8 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -593,7 +593,7 @@ COMPAT_SYSCALL_DEFINE5(waitid,
 		else
 			ret = put_compat_rusage(&ru, uru);
 		if (ret)
-			return ret;
+			return -EFAULT;
 	}
 
 	BUG_ON(info.si_code & __SI_MASK);
