Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133Ab2GZKy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 06:54:58 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57923 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751962Ab2GZKy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 06:54:56 -0400
Message-ID: <501121C9.7080806@mvista.com>
Date: Thu, 26 Jul 2012 14:54:01 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@amd.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jeff Garzik <jgarzik@pobox.com>, Lin Ming <minggr@gmail.com>,
        Jeff Wu <jeff.wu@amd.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
Subject: Re: [PATCH v3 6/7] scsi: sr: balance sr disk events block depth
References: <1343297129-28174-1-git-send-email-aaron.lu@amd.com> <1343297129-28174-7-git-send-email-aaron.lu@amd.com>
In-Reply-To: <1343297129-28174-7-git-send-email-aaron.lu@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 26-07-2012 14:05, Aaron Lu wrote:

> When the ODD is resumed, disk_unblock_events should be called when:
> 1 The ODD is runtime resumed;
> 2 System is resuming from S3 and the ODD is runtime suspended before S3;
> But not when the system is resuming from S3 and the ODD is runtime
> active before S3.

> So seperate the resume calls, one for system resume and one for runtime
> resume to do different things accordingly.

> Signed-off-by: Aaron Lu <aaron.lu@amd.com>
> ---
>   drivers/scsi/sr.c | 21 +++++++++++++++++++++
>   1 file changed, 21 insertions(+)

> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index fd1c2f6..b8c2f9d 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
[...]
> @@ -211,6 +217,21 @@ static int sr_suspend(struct device *dev, pm_message_t msg)
>
>   static int sr_resume(struct device *dev)
>   {
> +	struct scsi_cd *cd = dev_get_drvdata(dev);
> +
> +	/*
> +	 * If ODD is runtime suspended before system pm, unblock disk
> +	 * events now since on system resume, we will fully resume it

    Comma not needed.

> +	 * and set its rumtime status to active.

    s/rumtime/runtime/. Nice typo. %-)

WBR, Sergei

