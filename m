Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065Ab0DAPwA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 11:52:00 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43056 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756658Ab0DAPvw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 11:51:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=fver0owcdV/2jvLkG2U6rO2IWorKrDJPo7ydB+vENjpUQybTNrS2MOMkTOi89Ae/Ox
         y1NWdtRHXH3+XRhe0uITd/Hgbk/iKRnhSDCxhg2ZSjqrbChPPJ2H6XdDIUYLqiygrvt2
         m2TiEC9Cdu9m2S41p0Fgg4QX1uj0pvDfdjb5Y=
Date: Thu, 1 Apr 2010 18:51:43 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] mxser: spin_lock() => spin_lock_irq()
Message-ID: <20100401155143.GC5265@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@linux.intel.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should be spin_lock_irq() to match the spin_unlock_irq().
Originally it was a lock_kernel() but we switched everything to
spin_lock_irq() last November.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index e0c5d2a..ecb2d8b 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -1768,7 +1768,7 @@ static int mxser_ioctl(struct tty_struct *tty, struct file *file,
 		int len, lsr;
 
 		len = mxser_chars_in_buffer(tty);
-		spin_lock(&info->slock);
+		spin_lock_irq(&info->slock);
 		lsr = inb(info->ioaddr + UART_LSR) & UART_LSR_THRE;
 		spin_unlock_irq(&info->slock);
 		len += (lsr ? 0 : 1);
