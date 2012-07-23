Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab2GWOup (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 10:50:45 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38353 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752612Ab2GWOun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 10:50:43 -0400
Date: Mon, 23 Jul 2012 10:50:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Aaron Lu <aaron.lu@amd.com>
cc: Jeff Garzik <jgarzik@pobox.com>, Lin Ming <minggr@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-ide@vger.kernel.org>,
        Aaron Lu <aaron.lwe@gmail.com>
Subject: Re: [PATCH 1/5] scsi: sr: fix for sr suspend and resume
In-Reply-To: <1343026180-22236-2-git-send-email-aaron.lu@amd.com>
Message-ID: <Pine.LNX.4.44L0.1207231049260.1633-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2012, Aaron Lu wrote:

> In sr_suspend, we do not need to do anything if it is not a runtime pm
> request, so just return by checking the PM_EVENT_AUTO flag.
> And in sr_resume, only reset the suspend_count back to 1 if the ODD is
> waken up by the user, or the usage count of the scsi device will not
> balance.
> 
> Signed-off-by: Aaron Lu <aaron.lu@amd.com>
> ---
>  drivers/scsi/sr.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 3da0879..5f4d19a 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -178,8 +178,8 @@ static int sr_suspend(struct device *dev, pm_message_t msg)
>  	struct scsi_sense_hdr sshdr;
>  	struct scsi_cd *cd = dev_get_drvdata(dev);
>  
> -	/* no action for system suspend */
> -	if (msg.event == PM_EVENT_SUSPEND)
> +	/* no action for system pm operations */
> +	if (!(msg.event & PM_EVENT_AUTO))

Please use the PMSG_IS_AUTO macro.

Alan Stern

