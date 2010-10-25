Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751948Ab0JYF2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 01:28:19 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65115 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296Ab0JYF2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 01:28:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=vXIcTrLizHfvmIr5LIZE0wlEkkcLHMNbtBfbhDlXvNQZTkrasCOYPYEM5Os+LbI75s
         1k3dzNf7dD2OtZwx2VtaY8D6R3azYd91Ij+zy7Hv46iOsMfVe15O+c4CDLeLkIuxEscV
         tq0tDQ7gxv8GO8p++xElJWyPyyLk6LQUCudf4=
Date: Mon, 25 Oct 2010 07:28:03 +0200
From: Dan Carpenter <error27@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@linux.intel.com>, Feng Tang <feng.tang@intel.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] serial/mrst_max3110: make buffer larger
Message-ID: <20101025052802.GY5985@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Alan Cox <alan@linux.intel.com>, Feng Tang <feng.tang@intel.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is used to store the spi_device ->modalias so they have to be the same
size.  SPI_NAME_SIZE is 32.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/serial/mrst_max3110.c b/drivers/serial/mrst_max3110.c
index b62857b..37e13c3 100644
--- a/drivers/serial/mrst_max3110.c
+++ b/drivers/serial/mrst_max3110.c
@@ -51,7 +51,7 @@
 struct uart_max3110 {
 	struct uart_port port;
 	struct spi_device *spi;
-	char name[24];
+	char name[SPI_NAME_SIZE];
 
 	wait_queue_head_t wq;
 	struct task_struct *main_thread;
