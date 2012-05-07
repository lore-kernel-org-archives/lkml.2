Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab2EGR4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 13:56:49 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31087 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab2EGR4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:56:48 -0400
Date: Mon, 7 May 2012 13:50:39 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: JBottomley@parallels.com, joerg@alea.gnuu.de, linux-kernel@vger.kernel.org
Subject: Re: Regression introduced by
 6f381fa344911d5a234b13574433cf23036f9467 [[SCSI] scsi_lib: use correct DMA
 device in __scsi_alloc_queue]
Message-ID: <20120507175039.GA6423@phenom.dumpdata.com>
References: <20120507135238.GC361@phenom.dumpdata.com>
 <CAF1ivSZNH3R-U=d=yBW4m9PO8TQSbSP=dHR3okdsO7EkOm2RMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF1ivSZNH3R-U=d=yBW4m9PO8TQSbSP=dHR3okdsO7EkOm2RMQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > reverting above mentioned git commit fixes the issue.
> 
> Does Jame's below patch help?
> 
> http://www.spinics.net/lists/linux-scsi/msg59106.html

Yes.  please add Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
on the latter part of that patch:


diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 351dc0b..a3a056a 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -218,6 +218,9 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
 
 	if (!shost->shost_gendev.parent)
 		shost->shost_gendev.parent = dev ? dev : &platform_bus;
+	if (!dma_dev)
+		dma_dev = shost->shost_gendev.parent;
+
 	shost->dma_dev = dma_dev;
 
 	error = device_add(&shost->shost_gendev);
