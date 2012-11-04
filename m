Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178Ab2KDK2q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 05:28:46 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:58291 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154Ab2KDK2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 05:28:44 -0500
Date: Sun, 4 Nov 2012 11:28:40 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org, Karsten Keil <isdn@linux-pingi.de>,
        netdev@vger.kernel.org
Subject: [PATCH v2 8/9] isdn: Remove unused variable causing a compile build
 warning
Message-ID: <20121104102840.GA27124@gmail.com>
References: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
 <1351980150-24145-9-git-send-email-lee.jones@linaro.org>
 <1351982441.1434.5.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1351982441.1434.5.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for reviewing Paul. Here's the result:

Author: Lee Jones <lee.jones@linaro.org>
Date:   Sat Nov 3 22:06:02 2012 +0100

    isdn: Encapsulate variable 's' in same CONFIG_NETDEVICES guards as code using it
    
    In the current case, variable 's' of type 'char *' is defined but then
    not used if !CONFIG_NETDEVICES, casing the compile-time warning below.
    In this change we surround the declaration using the same guards as
    the pre-processed code which makes use of it.
    
    This patch fixes:
    drivers/isdn/i4l/isdn_common.c: In function ‘isdn_ioctl’:
    drivers/isdn/i4l/isdn_common.c:1278:8: warning: unused variable ‘s’ [-Wunused-variable]
    
    Cc: Karsten Keil <isdn@linux-pingi.de>
    Cc: netdev@vger.kernel.org
    Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index 8c610fa..2875f31 100644
--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -1275,7 +1275,6 @@ isdn_ioctl(struct file *file, uint cmd, ulong arg)
 	int ret;
 	int i;
 	char __user *p;
-	char *s;
 	union iocpar {
 		char name[10];
 		char bname[22];
@@ -1284,6 +1283,9 @@ isdn_ioctl(struct file *file, uint cmd, ulong arg)
 		isdn_net_ioctl_cfg cfg;
 	} iocpar;
 	void __user *argp = (void __user *)arg;
+#ifdef CONFIG_NETDEVICES
+	char *s;
+#endif
 
 #define name  iocpar.name
 #define bname iocpar.bname
