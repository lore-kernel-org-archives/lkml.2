Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab0DAPzf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 11:55:35 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:39710 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757052Ab0DAPz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 11:55:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=B5e2V+2HJc3oFBFKThJsS1xt6RadzhH5co7eU33VDqalzEh0e/4fISKnZiGSy7HuoX
         Cluh6SxCjFt0VJKqFM3tMeOAz+z6XtDhnNyI8iSSxanNZuq642Ci+1Ju48JevkbIVzqC
         ECxjK7PrsHAjLD95Apzd3Hadl+feaMgRUNAuI=
Date: Thu, 1 Apr 2010 18:55:16 +0300
From: Dan Carpenter <error27@gmail.com>
To: Miroslav Zagorac <zaga@fly.cc.fer.hr>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>,
       Adam Buchbinder <adam.buchbinder@gmail.com>,
       Jiri Kosina <jkosina@suse.cz>, jgarzik@pobox.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] wd7000: typo spin_unlock_irq() => spin_lock_irq()
Message-ID: <20100401155516.GF5265@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Miroslav Zagorac <zaga@fly.cc.fer.hr>,
	"James E.J. Bottomley" <James.Bottomley@suse.de>,
	Adam Buchbinder <adam.buchbinder@gmail.com>,
	Jiri Kosina <jkosina@suse.cz>, jgarzik@pobox.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was introduced back in 2005 at the very start of the git era by:
	df0ae2497ddefd72a87f3a3b34ff32455d7d4ae0
	[SCSI] allow sleeping in ->eh_host_reset_handler()

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
Also this driver was written before some of our youngest kernel hackers
were born.  Neat.  :)

diff --git a/drivers/scsi/wd7000.c b/drivers/scsi/wd7000.c
index 2f6e9d8..bdfe59d 100644
--- a/drivers/scsi/wd7000.c
+++ b/drivers/scsi/wd7000.c
@@ -1588,7 +1588,7 @@ static int wd7000_host_reset(struct scsi_cmnd *SCpnt)
 {
 	Adapter *host = (Adapter *) SCpnt->device->host->hostdata;
 
-	spin_unlock_irq(SCpnt->device->host->host_lock);
+	spin_lock_irq(SCpnt->device->host->host_lock);
 
 	if (wd7000_adapter_reset(host) < 0) {
 		spin_unlock_irq(SCpnt->device->host->host_lock);
