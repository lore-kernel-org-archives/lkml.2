Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab2HAPxx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:53:53 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56400 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755556Ab2HAPxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:53:51 -0400
Message-ID: <50195108.1090105@redhat.com>
Date: Wed, 01 Aug 2012 17:53:44 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: axboe@kernel.dk
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] sg_io: allow UNMAP and WRITE SAME without CAP_SYS_RAWIO
References: <1342801801-15617-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1342801801-15617-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 20/07/2012 18:30, Paolo Bonzini ha scritto:
> These commands cannot be issued right now without giving CAP_SYS_RAWIO to
> the process who wishes to send them.  These commands can be useful also to
> non-privileged programs who have access to the block devices.  For example
> a virtual machine monitor needs them to forward trim/discard to host disks.
> 
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  block/scsi_ioctl.c |    3 ++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
> index 260fa80..dd71f18 100644
> --- a/block/scsi_ioctl.c
> +++ b/block/scsi_ioctl.c
> @@ -168,13 +168,16 @@ static void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter)
>  	/* Basic writing commands */
>  	__set_bit(WRITE_6, filter->write_ok);
>  	__set_bit(WRITE_10, filter->write_ok);
> +	__set_bit(WRITE_SAME, filter->write_ok);
>  	__set_bit(WRITE_VERIFY, filter->write_ok);
>  	__set_bit(WRITE_12, filter->write_ok);
>  	__set_bit(WRITE_VERIFY_12, filter->write_ok);
>  	__set_bit(WRITE_16, filter->write_ok);
> +	__set_bit(WRITE_SAME_16, filter->write_ok);
>  	__set_bit(WRITE_LONG, filter->write_ok);
>  	__set_bit(WRITE_LONG_2, filter->write_ok);
>  	__set_bit(ERASE, filter->write_ok);
> +	__set_bit(UNMAP, filter->write_ok);
>  	__set_bit(GPCMD_MODE_SELECT_10, filter->write_ok);
>  	__set_bit(MODE_SELECT, filter->write_ok);
>  	__set_bit(LOG_SELECT, filter->write_ok);
> 

Jens,

can this go in 3.6 as well?

Paolo
