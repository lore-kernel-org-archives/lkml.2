Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020Ab2GZIwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 04:52:16 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:49280 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751279Ab2GZIwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 04:52:15 -0400
Message-ID: <1343292731.3115.17.camel@dabdike>
Subject: Re: [PATCH 1/2] virtio-scsi: fix parsing of hotplug/hot-unplug LUN
 number
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Date: Thu, 26 Jul 2012 12:52:11 +0400
In-Reply-To: <1342454751-8950-2-git-send-email-pbonzini@redhat.com>
References: <1342454751-8950-1-git-send-email-pbonzini@redhat.com>
	 <1342454751-8950-2-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-16 at 18:05 +0200, Paolo Bonzini wrote:
> Hotplug/hot-unplug of a LUN whose number is greater than 255
> uses the "flat" format for LUNs, which has bit 14 set.  Clear
> the bit when parsing the event structs.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/scsi/virtio_scsi.c |    8 ++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index c7030fb..c937232 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -252,13 +252,19 @@ static void virtscsi_cancel_event_work(struct virtio_scsi *vscsi)
>  		cancel_work_sync(&vscsi->event_list[i].work);
>  }
>  
> +static unsigned int virtscsi_get_lun(u8 *lun_bytes)
> +{
> +	unsigned int lun = (lun_bytes[2] << 8) | lun_bytes[3];
> +	return lun & 16383;
> +}
> +

Why are you rolling your own incomplete version of scsilun_to_int here?

James


