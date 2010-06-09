Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab0FISzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 14:55:32 -0400
Received: from suva.vyatta.com ([76.74.103.44]:59654 "EHLO suva.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758219Ab0FISyT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 14:54:19 -0400
X-Greylist: delayed 867 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jun 2010 14:54:17 EDT
Message-Id: <20100609183625.996513194@vyatta.com>
User-Agent: quilt/0.48-1
Date: Wed, 09 Jun 2010 11:34:55 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] floppy: fix signed/unsigned warnings
References: <20100609183449.110905403@vyatta.com>
Content-Disposition: inline; filename=floppy-sparse-signed.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ioctl cmd value is unsigned, so change normalize_ioctl

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>

--- a/drivers/block/floppy.c	2010-06-08 23:08:29.136934127 -0700
+++ b/drivers/block/floppy.c	2010-06-08 23:08:32.697067816 -0700
@@ -3337,7 +3337,7 @@ static int set_geometry(unsigned int cmd
 }
 
 /* handle obsolete ioctl's */
-static int ioctl_table[] = {
+static unsigned int ioctl_table[] = {
 	FDCLRPRM,
 	FDSETPRM,
 	FDDEFPRM,
@@ -3365,7 +3365,7 @@ static int ioctl_table[] = {
 	FDTWADDLE
 };
 
-static int normalize_ioctl(int *cmd, int *size)
+static int normalize_ioctl(unsigned int *cmd, int *size)
 {
 	int i;
 


