Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935436Ab0HFIAH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 04:00:07 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52942 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933975Ab0HFIAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 04:00:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ly43ekGxQJ9VvKWat7AW1MEcr3GmATLz+kUe8AtBVc1rbieJy7JfkgfGxgzs1rsBvo
         tM+3WXFNEhaI9Oj3cMSaZU+Ik2Wyib3WMnYgEd/I9aAtifg7mDMqN0jzSERtSSRpMxix
         bAZWFfDKeP48azWENdjDhSSOi8b/0zFmv0mVk=
Date: Fri, 6 Aug 2010 09:59:14 +0200
From: Dan Carpenter <error27@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, eric.moore@lsi.com,
        kashyap.desai@lsi.com
Subject: [PATCH] scsi: mpt2sas: Add space in printk
Message-ID: <20100806075914.GS9031@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Julia Lawall <julia@diku.dk>,
	"James E.J. Bottomley" <James.Bottomley@suse.de>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, eric.moore@lsi.com,
	kashyap.desai@lsi.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1008052219190.31692@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a space in the output:
old:  Discovery: (stop)discovery_status(0x%08x)
new:  Discovery: (stop) discovery_status(0x%08x)

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
This goes on top of Julia's [PATCH 9/42] drivers/scsi: Adjust
confusing if indentation 

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 12faf64..562b909 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -532,7 +532,7 @@ _base_display_event_data(struct MPT2SAS_ADAPTER *ioc,
 		    (event_data->ReasonCode == MPI2_EVENT_SAS_DISC_RC_STARTED) ?
 		    "start" : "stop");
 		if (event_data->DiscoveryStatus)
-			printk("discovery_status(0x%08x)",
+			printk(" discovery_status(0x%08x)",
 			    le32_to_cpu(event_data->DiscoveryStatus));
 		printk("\n");
 		return;
