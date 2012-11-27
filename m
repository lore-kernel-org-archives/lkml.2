Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab2K0P6i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 10:58:38 -0500
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:52632 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753382Ab2K0P6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 10:58:37 -0500
Message-ID: <50B4E329.7020502@akamai.com>
Date: Tue, 27 Nov 2012 09:58:33 -0600
From: Josh Hunt <johunt@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: "jaxboe@fusionio.com" <jaxboe@fusionio.com>
CC: Josh Hunt <johunt@akamai.com>,
        "kay.sievers@vrfy.org" <kay.sievers@vrfy.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] block: Restore /proc/partitions to not display non-partitionable
 removable devices
References: <1353380209-23799-1-git-send-email-johunt@akamai.com>
In-Reply-To: <1353380209-23799-1-git-send-email-johunt@akamai.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ping?

On 11/19/2012 08:56 PM, Josh Hunt wrote:
> We found with newer kernels we started seeing the cdrom device showing
> up in /proc/partitions, but it was not there before. Looking into this I found
> that commit d27769ec... block: add GENHD_FL_NO_PART_SCAN introduces this change
> in behavior. It's not clear to me from the commit's changelog if this change was
> intentional or not. This comment still remains:
> /* Don't show non-partitionable removeable devices or empty devices */
> so I've decided to send a patch to restore the behavior of not printing
> unpartitionable removable devices.
>
> Thanks
> Josh
> ---
>
> After commit d27769ec... block: add GENHD_FL_NO_PART_SCAN, /proc/partitions
> started printing removable devices with only one partition. This is different
> than prior to the commit. This restores /proc/partitions to behave as it did before.
>
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> ---
>   block/genhd.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/block/genhd.c b/block/genhd.c
> index 6cace66..6bfeb2a 100644
> --- a/block/genhd.c
> +++ b/block/genhd.c
> @@ -851,7 +851,7 @@ static int show_partition(struct seq_file *seqf, void *v)
>   	char buf[BDEVNAME_SIZE];
>
>   	/* Don't show non-partitionable removeable devices or empty devices */
> -	if (!get_capacity(sgp) || (!disk_max_parts(sgp) &&
> +	if (!get_capacity(sgp) || (!(disk_max_parts(sgp) > 1) &&
>   				   (sgp->flags & GENHD_FL_REMOVABLE)))
>   		return 0;
>   	if (sgp->flags & GENHD_FL_SUPPRESS_PARTITION_INFO)
>
