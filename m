Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935469Ab1KJPk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 10:40:26 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:39321 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S935321Ab1KJPkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 10:40:22 -0500
Date: Thu, 10 Nov 2011 10:40:21 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Lin Ming <ming.m.lin@intel.com>
cc: linux-kernel@vger.kernel.org, <linux-ide@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <JBottomley@parallels.com>, Tejun Heo <tj@kernel.org>,
        Huang Ying <ying.huang@intel.com>, Zhang Rui <rui.zhang@intel.com>
Subject: Re: [PATCH v2 4/4] ata: add ata port runtime PM callbacks
In-Reply-To: <1320906166-15459-5-git-send-email-ming.m.lin@intel.com>
Message-ID: <Pine.LNX.4.44L0.1111101036160.2338-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Nov 2011, Lin Ming wrote:

> Add ata port runtime suspend/resume/idle callbacks.
> Set ->eh_noresume to skip the runtime PM calls on scsi host
> in the error handler to avoid dead lock.

...

> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -3377,6 +3377,7 @@ int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
>  		if (!shost)
>  			goto err_alloc;
>  
> +		shost->eh_noresume = 1;
>  		*(struct ata_port **)&shost->hostdata[0] = ap;
>  		ap->scsi_host = shost;

Are you really sure you want to keep this flag set throughout the 
lifetime of the port?

What happens if a command fails, then the port suspends, and then the 
error handler is invoked to take care of the failed command?

Alan Stern

