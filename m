Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab2KCQhl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 12:37:41 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:60989 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756502Ab2KCQhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 12:37:39 -0400
Message-ID: <50954852.5050209@acm.org>
Date: Sat, 03 Nov 2012 17:37:38 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [patch,v2 05/10] sd: use alloc_disk_node
References: <1351892763-21325-1-git-send-email-jmoyer@redhat.com> <1351892763-21325-6-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1351892763-21325-6-git-send-email-jmoyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/12 22:45, Jeff Moyer wrote:
> Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
> ---
>   drivers/scsi/sd.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 12f6fdf..8deb915 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2714,7 +2714,7 @@ static int sd_probe(struct device *dev)
>   	if (!sdkp)
>   		goto out;
>
> -	gd = alloc_disk(SD_MINORS);
> +	gd = alloc_disk_node(SD_MINORS, dev_to_node(dev));
>   	if (!gd)
>   		goto out_free;

shost->numa_node can be another NUMA node than dev_to_node(dev). Have 
you considered using shost->numa_node here ?

Bart.

