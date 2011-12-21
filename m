Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986Ab1LUCfx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 21:35:53 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:37968 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751828Ab1LUCfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 21:35:51 -0500
Message-ID: <1324434950.14214.3.camel@joe2Laptop>
Subject: Re: [PATCH 1/8] IB/cxgb4: Fix formatting of physical address
From: Joe Perches <joe@perches.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Steve Wise <swise@chelsio.com>, linux-rdma@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 20 Dec 2011 18:35:50 -0800
In-Reply-To: <1324431127.2844.146.camel@deadeye>
References: <1324430940.2844.144.camel@deadeye>
	 <1324431127.2844.146.camel@deadeye>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 01:32 +0000, Ben Hutchings wrote:
> Physical addresses may be wider than virtual addresses (e.g. on i386
> with PAE) and must not be formatted with %p.
[]
> The resource could alternately be formatted with %Pr.
> diff --git a/drivers/infiniband/hw/cxgb4/device.c b/drivers/infiniband/hw/cxgb4/device.c
[]
> @@ -318,10 +318,10 @@ static int c4iw_rdev_open(struct c4iw_rdev *rdev)
>  	     rdev->lldi.vr->qp.size,
>  	     rdev->lldi.vr->cq.start,
>  	     rdev->lldi.vr->cq.size);
> -	PDBG("udb len 0x%x udb base %p db_reg %p gts_reg %p qpshift %lu "
> +	PDBG("udb len 0x%x udb base %llx db_reg %p gts_reg %p qpshift %lu "
>  	     "qpmask 0x%x cqshift %lu cqmask 0x%x\n",
>  	     (unsigned)pci_resource_len(rdev->lldi.pdev, 2),
> -	     (void *)pci_resource_start(rdev->lldi.pdev, 2),
> +	     (u64)pci_resource_start(rdev->lldi.pdev, 2),

Probably should be unsigned long long


