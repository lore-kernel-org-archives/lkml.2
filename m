Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295Ab0J0KIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 06:08:01 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54546 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759752Ab0J0KH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 06:07:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=kTg03w2s7IA9kUCLhqTMXsJWX3td3Y8/vV3IY69E5VbGS8iezmkN87LSHTrJPImxYO
         DDW2e52JfOBJiUK6G1iQuRvFiHGgUbso2O2QT+DgzrG/NfhZ0Gxnd83entkVJwbtAHos
         U4tZ29IKrOzPeXRjBeB5Y/xhxhHnSKasJuhVU=
Date: Wed, 27 Oct 2010 12:07:35 +0200
From: Dan Carpenter <error27@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>, joel.becker@oracle.com
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] configfs: documentation: remove unneeded check
Message-ID: <20101027100735.GE6062@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Randy Dunlap <rdunlap@xenotime.net>, joel.becker@oracle.com,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If "p" is NULL then it will cause an oops when we pass it to
simple_strtoul().  In this case "p" can not be NULL so I removed the
check and cleaned up the rest of the if condition as well.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/Documentation/filesystems/configfs/configfs_example_explicit.c b/Documentation/filesystems/configfs/configfs_example_explicit.c
index d428cc9..63ff248 100644
--- a/Documentation/filesystems/configfs/configfs_example_explicit.c
+++ b/Documentation/filesystems/configfs/configfs_example_explicit.c
@@ -89,7 +89,7 @@ static ssize_t childless_storeme_write(struct childless *childless,
 	char *p = (char *) page;
 
 	tmp = simple_strtoul(p, &p, 10);
-	if (!p || (*p && (*p != '\n')))
+	if (*p != '\0' && *p != '\n')
 		return -EINVAL;
 
 	if (tmp > INT_MAX)
