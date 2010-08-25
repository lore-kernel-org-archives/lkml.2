Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053Ab0HYHNK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 03:13:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:35062 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751680Ab0HYHNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 03:13:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=SmdA5DIrqHR6ftbDKk7qoUWCTJPSrTmoYyBz+QrELkJjWvzc1gT7oETxf13pQYaJJL
         h/j5sCsNKQcUuQ9J5m2Bk16qrG3Hk4LwLszNWr2n35q+9fyvdRlRpWgtZMZgSTsk2f8z
         JWc8D6q4Yn248ArWS3+NAo9oUpg1yKkKRXHjc=
Date: Wed, 25 Aug 2010 09:12:29 +0200
From: Dan Carpenter <error27@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serue@us.ibm.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] sysfs: checking for NULL instead of ERR_PTR
Message-ID: <20100825071229.GP29330@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Serge Hallyn <serue@us.ibm.com>,
	Stephen Hemminger <shemminger@vyatta.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

d_path() returns an ERR_PTR and it doesn't return NULL.

CC:stable@kernel.org
Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 1b27b56..da3fefe 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -340,7 +340,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
 	char *p;
 
 	p = d_path(&file->f_path, last_sysfs_file, sizeof(last_sysfs_file));
-	if (p)
+	if (!IS_ERR(p))
 		memmove(last_sysfs_file, p, strlen(p) + 1);
 
 	/* need attr_sd for attr and ops, its parent for kobj */
