Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757405Ab2KCQfh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 12:35:37 -0400
Received: from jacques.telenet-ops.be ([195.130.132.50]:60144 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245Ab2KCQfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 12:35:36 -0400
Message-ID: <509547D5.2020800@acm.org>
Date: Sat, 03 Nov 2012 17:35:33 +0100
From: Bart Van Assche <bvanassche@acm.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121025 Thunderbird/16.0.2
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [patch,v2 01/10] scsi: add scsi_host_alloc_node
References: <1351892763-21325-1-git-send-email-jmoyer@redhat.com> <1351892763-21325-2-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1351892763-21325-2-git-send-email-jmoyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/12 22:45, Jeff Moyer wrote:
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 593085a..7d7ad8b 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -336,16 +336,25 @@ static struct device_type scsi_host_type = {
>    **/
>   struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>   {
> +	return scsi_host_alloc_node(sht, privsize, -1);

Using NUMA_NO_NODE here might improve readability.

> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index 4908480..a1b5c8e 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -733,6 +733,12 @@ struct Scsi_Host {
>   	struct device *dma_dev;
>
>   	/*
> +	 * Numa node this device is closest to, used for allocating
> +	 * data structures locally.
> +	 */
> +	int numa_node;

Have you considered using #ifdef CONFIG_NUMA / #endif here ? I've 
noticed that all other numa_node members in structures under include/ 
have this.

Bart.

