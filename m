Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab2GDQ0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 12:26:19 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65368 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932133Ab2GDQ0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 12:26:08 -0400
Message-ID: <1341419217.18786.3.camel@lappy>
Subject: Re: [PATCH] virtio-blk: allow toggling host cache between writeback
 and writethrough
From: Sasha Levin <levinsasha928@gmail.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, kvm@vger.kernel.org
Date: Wed, 04 Jul 2012 18:26:57 +0200
In-Reply-To: <1341321577-24435-1-git-send-email-pbonzini@redhat.com>
References: <1341321577-24435-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-03 at 15:19 +0200, Paolo Bonzini wrote:
> diff --git a/include/linux/virtio_blk.h b/include/linux/virtio_blk.h
> index e0edb40..18a1027 100644
> --- a/include/linux/virtio_blk.h
> +++ b/include/linux/virtio_blk.h
> @@ -37,8 +37,9 @@
>  #define VIRTIO_BLK_F_RO                5       /* Disk is read-only */
>  #define VIRTIO_BLK_F_BLK_SIZE  6       /* Block size of disk is available*/
>  #define VIRTIO_BLK_F_SCSI      7       /* Supports scsi command passthru */
> -#define VIRTIO_BLK_F_FLUSH     9       /* Cache flush command support */
> +#define VIRTIO_BLK_F_WCE       9       /* Writeback mode enabled after reset */
>  #define VIRTIO_BLK_F_TOPOLOGY  10      /* Topology information is available */
> +#define VIRTIO_BLK_F_CONFIG_WCE        11      /* Writeback mode available in config */ 

Wouldn't this change break any usermode code that implements virtio-blk?

