Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab0LHL3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 06:29:37 -0500
Received: from mail-ey0-f171.google.com ([209.85.215.171]:53809 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab0LHL3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 06:29:35 -0500
Message-ID: <4CFF6BE0.4090109@ru.mvista.com>
Date: Wed, 08 Dec 2010 14:28:32 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: Hannes Reinecke <hare@suse.de>, k-ueda@ct.jp.nec.com, michaelc@cs.wisc.edu,
        tytso@mit.edu, sshtylyov@mvista.com, linux-scsi@vger.kernel.org,
        jaxboe@fusionio.com, jack@suse.cz, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, swhiteho@redhat.com,
        linux-raid@vger.kernel.org, linux-ide@vger.kernel.org,
        dm-devel@redhat.com, James.Bottomley@suse.de,
        konishi.ryusuke@lab.ntt.co.jp, j-nomura@ce.jp.nec.com, vst@vlnb.net,
        rwheeler@redhat.com, hch@lst.de, chris.mason@oracle.com, tj@kernel.org
Subject: Re: [RFC PATCH 3/3] block: improve detail in I/O error messages
References: <1291763802-8251-1-git-send-email-snitzer@redhat.com> <1291763802-8251-4-git-send-email-snitzer@redhat.com>
In-Reply-To: <1291763802-8251-4-git-send-email-snitzer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 08-12-2010 2:16, Mike Snitzer wrote:

> Classify severity of I/O errors for target and transport errors.

> Signed-off-by: Mike Snitzer<snitzer@redhat.com>
[...]

> diff --git a/block/blk-core.c b/block/blk-core.c
> index 4ce953f..ab8c776 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -2028,9 +2028,15 @@ bool blk_update_request(struct request *req, int error, unsigned int nr_bytes)
>
>   	if (error&&  req->cmd_type == REQ_TYPE_FS&&
>   	!(req->cmd_flags&  REQ_QUIET)) {
> -		printk(KERN_ERR "end_request: I/O error, dev %s, sector %llu\n",
> -				req->rq_disk ? req->rq_disk->disk_name : "?",
> -				(unsigned long long)blk_rq_pos(req));
> +		char *error_type = "I/O";
> +
> +		if (error == -ENOLINK)
> +			error_type = "recoverable transport";
> +		else if (error == -EREMOTEIO)
> +			error_type = "critical target";

    *switch* would be more natural here.

WBR, Sergei
