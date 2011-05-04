Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab1EDJTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 05:19:44 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:38846 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1EDJTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 05:19:43 -0400
Date: Wed, 4 May 2011 05:19:34 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost6.localdomain6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Greg KH <greg@kroah.com>
Subject: [PATCH] RAW driver: Remove call to kobject_put().
Message-ID: <alpine.DEB.2.00.1105040519250.4439@localhost6.localdomain6>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If cdev_add() fails, there is no justification for subsequently
calling kobject_put().

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>

---

  argh, earlier submission had equal signs rather than hyphens for
marker line.  my mistake, so this is just a resubmit.  sorry.

diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index b4b9d5a..e2b4829 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -319,7 +319,6 @@ static int __init raw_init(void)
 	cdev_init(&raw_cdev, &raw_fops);
 	ret = cdev_add(&raw_cdev, dev, MAX_RAW_MINORS);
 	if (ret) {
-		kobject_put(&raw_cdev.kobj);
 		goto error_region;
 	}


-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
