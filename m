Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab2KIIsK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 03:48:10 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43842 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812Ab2KIIsI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 03:48:08 -0500
Message-ID: <509CC342.80700@redhat.com>
Date: Fri, 09 Nov 2012 09:48:02 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Eric Northup <digitaleric@google.com>
CC: "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] virtio_scsi: fix memory leak on full queue condition.
References: <1352368550-6694-1-git-send-email-digitaleric@google.com>
In-Reply-To: <1352368550-6694-1-git-send-email-digitaleric@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 08/11/2012 10:55, Eric Northup ha scritto:
> virtscsi_queuecommand was leaking memory when the virtio queue was full.
> 
> Tested: Guest operates correctly even with very small queue sizes, validated
> we're not leaking kmalloc-192 sized allocations anymore.
> 
> Signed-off-by: Eric Northup <digitaleric@google.com>
> ---
>  drivers/scsi/virtio_scsi.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 595af1a..dd8dc27 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -469,6 +469,8 @@ static int virtscsi_queuecommand(struct Scsi_Host *sh, struct scsi_cmnd *sc)
>  			      sizeof cmd->req.cmd, sizeof cmd->resp.cmd,
>  			      GFP_ATOMIC) >= 0)
>  		ret = 0;
> +	else
> +		mempool_free(cmd, virtscsi_cmd_pool);
>  
>  out:
>  	return ret;
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo
