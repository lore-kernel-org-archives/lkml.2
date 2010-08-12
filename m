Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913Ab0HLHun (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 03:50:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53502 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab0HLHuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 03:50:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=MbE+I8egwBzpr67Fyahc2YWzTQTisKTWVtzbqvD2DtEpir7fynum3P7JVQB8iWdwx1
         cneEViYIrNt8U8JynwEeYB+HjVp8U5KxpXLoC7y+5gS++yY1N8udaqZTuE4jvmLUMsQw
         jymhv9IsD1jCdtTzLfWiIjYVqP4qHO/avwNKs=
Date: Thu, 12 Aug 2010 09:50:09 +0200
From: Dan Carpenter <error27@gmail.com>
To: Feng Tang <feng.tang@intel.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mfd: snprintf() returns largish values
Message-ID: <20100812075009.GK645@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Feng Tang <feng.tang@intel.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

snprintf() returns the number of bytes which would have been written so
it can be larger than the size of the buffer.  In this case it's fine,
but people copy and paste this code so I've fixed it.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/serial/mfd.c b/drivers/serial/mfd.c
index bc9af50..5aa25e5 100644
--- a/drivers/serial/mfd.c
+++ b/drivers/serial/mfd.c
@@ -171,6 +171,9 @@ static ssize_t port_show_regs(struct file *file, char __user *user_buf,
 	len += snprintf(buf + len, HSU_REGS_BUFSIZE - len,
 			"DIV: \t\t0x%08x\n", serial_in(up, UART_DIV));
 
+	if (len > HSU_REGS_BUFSIZE)
+		len = HSU_REGS_BUFSIZE;
+
 	ret =  simple_read_from_buffer(user_buf, count, ppos, buf, len);
 	kfree(buf);
 	return ret;
@@ -218,6 +221,9 @@ static ssize_t dma_show_regs(struct file *file, char __user *user_buf,
 	len += snprintf(buf + len, HSU_REGS_BUFSIZE - len,
 			"D0TSR: \t\t0x%08x\n", chan_readl(chan, HSU_CH_D3TSR));
 
+	if (len > HSU_REGS_BUFSIZE)
+		len = HSU_REGS_BUFSIZE;
+
 	ret =  simple_read_from_buffer(user_buf, count, ppos, buf, len);
 	kfree(buf);
 	return ret;
