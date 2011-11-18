Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab1KROeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 09:34:07 -0500
Received: from mx2.netapp.com ([216.240.18.37]:32704 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757642Ab1KROeF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 09:34:05 -0500
X-IronPort-AV: E=Sophos;i="4.69,533,1315206000"; 
   d="scan'208";a="599983796"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] scsi_dh_rdac: Fix error path
Date: Fri, 18 Nov 2011 09:34:01 -0500
Message-ID: <47D23AD8469A2B448F33C24BD7A39BD9108C7178@RTPMVEXC1-PRD.hq.netapp.com>
In-Reply-To: <1321577067-26332-1-git-send-email-richard@nod.at>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] scsi_dh_rdac: Fix error path
Thread-Index: Acyli0ST9rEBq2/SQTqw6hjO4+DfRAAc7h6w
References: <1321577067-26332-1-git-send-email-richard@nod.at>
From: "Moger, Babu" <Babu.Moger@netapp.com>
To: "Richard Weinberger" <richard@nod.at>, <JBottomley@parallels.com>
Cc: <Somasundaram.Krishnasamy@lsi.com>, <yanling.qi@lsi.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 18 Nov 2011 14:34:02.0501 (UTC) FILETIME=[1DF91B50:01CCA5FF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me..

> -----Original Message-----
> From: Richard Weinberger [mailto:richard@nod.at]
> Sent: Thursday, November 17, 2011 6:44 PM
> To: JBottomley@parallels.com
> Cc: Moger, Babu; Somasundaram.Krishnasamy@lsi.com; yanling.qi@lsi.com;
> linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org; Richard
> Weinberger
> Subject: [PATCH] scsi_dh_rdac: Fix error path
> 
> If create_singlethread_workqueue() failes, rdac_init should fail too.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  drivers/scsi/device_handler/scsi_dh_rdac.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_rdac.c
> b/drivers/scsi/device_handler/scsi_dh_rdac.c
> index 1d31279..2802394 100644
> --- a/drivers/scsi/device_handler/scsi_dh_rdac.c
> +++ b/drivers/scsi/device_handler/scsi_dh_rdac.c
> @@ -934,6 +934,8 @@ static int __init rdac_init(void)
>  	if (!kmpath_rdacd) {
>  		scsi_unregister_device_handler(&rdac_dh);
>  		printk(KERN_ERR "kmpath_rdacd creation failed.\n");
> +
> +		r = -EINVAL;
>  	}
>  done:
>  	return r;
> --
> 1.7.7.3

