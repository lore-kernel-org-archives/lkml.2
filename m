Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab2HTOFt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 10:05:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753912Ab2HTOFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 10:05:47 -0400
Message-ID: <50324439.1000307@redhat.com>
Date: Mon, 20 Aug 2012 16:05:45 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Richard W.M. Jones" <rjones@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] [SCSI] virtio-scsi: Initialize scatterlist structure.
References: <1345471490-17289-1-git-send-email-rjones@redhat.com>
In-Reply-To: <1345471490-17289-1-git-send-email-rjones@redhat.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/08/2012 16:04, Richard W.M. Jones ha scritto:
> From: "Richard W.M. Jones" <rjones@redhat.com>
> 
> The sg struct is used without being initialized.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=847548
> 
> Signed-off-by: Richard W.M. Jones <rjones@redhat.com>
> ---
>  drivers/scsi/virtio_scsi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index c7030fb..8a66f83 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -219,7 +219,7 @@ static int virtscsi_kick_event(struct virtio_scsi *vscsi,
>  	struct scatterlist sg;
>  	unsigned long flags;
>  
> -	sg_set_buf(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
> +	sg_init_one(&sg, &event_node->event, sizeof(struct virtio_scsi_event));
>  
>  	spin_lock_irqsave(&vscsi->event_vq.vq_lock, flags);
>  
> 

Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Paolo
