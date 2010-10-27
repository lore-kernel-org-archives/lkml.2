Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933428Ab0J0Ous (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 10:50:48 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58322 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab0J0Oup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 10:50:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=vjO3om3DYx8YIkdX1mk+K3u6z6zuZBNmDypuPdmAJTIb1tLoZp8Z0w+Lh9vVZaPa72
         dmhrMFAAK4TbgQYUFCxQqB4bgxfTDcFwYGsZG2aMq2ZbjXvSnjqWBggQhO0kdMI21o/F
         wpmdBHmNERdIMCFePCdASs+96Vw/Za/XbbveE=
Date: Wed, 27 Oct 2010 16:50:31 +0200
From: Dan Carpenter <error27@gmail.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch v2] configfs: documentation: remove unneeded check
Message-ID: <20101027145031.GG6062@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Joel Becker <Joel.Becker@oracle.com>,
	Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20101027100735.GE6062@bicker> <20101027112207.GA17439@mail.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101027112207.GA17439@mail.oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If "p" is NULL then it will cause an oops when we pass it to
simple_strtoul().  In this case "p" can not be NULL so I removed the
check.  I also changed the check a little to make it more explicit that
we are testing whether p points to the NUL char.

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
V2: Added some parenthesis to make the precedence more clear.

diff --git a/Documentation/filesystems/configfs/configfs_example_explicit.c b/Documentation/filesystems/configfs/configfs_example_explicit.c
index d428cc9..63ff248 100644
--- a/Documentation/filesystems/configfs/configfs_example_explicit.c
+++ b/Documentation/filesystems/configfs/configfs_example_explicit.c
@@ -89,7 +89,7 @@ static ssize_t childless_storeme_write(struct childless *childless,
 	char *p = (char *) page;
 
 	tmp = simple_strtoul(p, &p, 10);
-	if (!p || (*p && (*p != '\n')))
+	if ((*p != '\0') && (*p != '\n'))
 		return -EINVAL;
 
 	if (tmp > INT_MAX)

