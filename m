Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759019Ab0HLHw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 03:52:58 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46213 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758393Ab0HLHw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 03:52:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=ugxY55eIA989O0UwElMrN2I5ulFoCVzEwlE8Ru0rINAUHkSUuLToZlSDkB4NDNLVJ9
         uSIYzE4qWWoYHH1dB91fd74Raljsq66IG3RdTzV61LaG0mUkdxkh0ybG1wWV8/fvwOjh
         rQmvbULTYFR/tLcZ/5Yh6gYMRuTK7zBXH0hGk=
Date: Thu, 12 Aug 2010 09:52:36 +0200
From: Dan Carpenter <error27@gmail.com>
To: "Michael H. Warfield" <mhw@wittsend.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Rakib Mullick <rakib.mullick@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch 2/2] ip2: return -EFAULT on copy_to_user errors
Message-ID: <20100812075236.GM645@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	"Michael H. Warfield" <mhw@wittsend.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Rakib Mullick <rakib.mullick@gmail.com>,
	Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

copy_to_user() returns the number of bytes remaining but we want to
return a negative error code on errors.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 8fa041e..d4b71e8 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -2930,6 +2930,8 @@ ip2_ipl_ioctl (struct file *pFile, UINT cmd, ULONG arg )
 				if ( pCh )
 				{
 					rc = copy_to_user(argp, pCh, sizeof(i2ChanStr));
+					if (rc)
+						rc = -EFAULT;
 				} else {
 					rc = -ENODEV;
 				}
