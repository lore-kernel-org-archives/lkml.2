Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758906Ab0HLHwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 03:52:10 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35725 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab0HLHwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 03:52:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=eqstxTxK7bbDt98YONMVHPHE2oKmKgBmaLWrCmPohl6GVwfQytwntVgkIPVjc+m9Bg
         VNbUZydwb3MLUIkX+6gFfQeJUQPp0HBfgyGAfXfy1w/bKh/9kU8VwjNOqKAGHFvas5j/
         czgKwGZl1wANNQQqftTaTux9zXLfzcy6R0xYI=
Date: Thu, 12 Aug 2010 09:51:41 +0200
From: Dan Carpenter <error27@gmail.com>
To: "Michael H. Warfield" <mhw@wittsend.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Rakib Mullick <rakib.mullick@gmail.com>, linux-kernel@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>, kernel-janitors@vger.kernel.org
Subject: [patch 1/2] ip2: remove unneeded NULL check
Message-ID: <20100812075141.GL645@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	"Michael H. Warfield" <mhw@wittsend.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Rakib Mullick <rakib.mullick@gmail.com>,
	linux-kernel@vger.kernel.org, Ben Hutchings <ben@decadent.org.uk>,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't pass NULL tty pointers to the close function, and anyway we
already dereferenced it at this point.  This check can be removed.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 07f3ea3..8fa041e 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -1650,7 +1650,7 @@ ip2_close( PTTY tty, struct file *pFile )
 	/* disable DSS reporting */
 	i2QueueCommands(PTYPE_INLINE, pCh, 100, 4,
 				CMD_DCD_NREP, CMD_CTS_NREP, CMD_DSR_NREP, CMD_RI_NREP);
-	if ( !tty || (tty->termios->c_cflag & HUPCL) ) {
+	if (tty->termios->c_cflag & HUPCL) {
 		i2QueueCommands(PTYPE_INLINE, pCh, 100, 2, CMD_RTSDN, CMD_DTRDN);
 		pCh->dataSetOut &= ~(I2_DTR | I2_RTS);
 		i2QueueCommands( PTYPE_INLINE, pCh, 100, 1, CMD_PAUSE(25));
