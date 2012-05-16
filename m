Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759571Ab2EPHiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 03:38:15 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56665 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759370Ab2EPHiN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 03:38:13 -0400
Message-ID: <1337153889.2985.5.camel@dabdike.int.hansenpartnership.com>
Subject: Re: [PATCH] target: Handle ATA_PASS_THROUGH_16 passthrough
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: mc@linux.vnet.ibm.com
Cc: target-devel@vger.kernel.org,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Date: Wed, 16 May 2012 08:38:09 +0100
In-Reply-To: <1337146409.18429.11.camel@mengcong>
References: <1337146409.18429.11.camel@mengcong>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 13:33 +0800, mengcong wrote:
> The cdrecord uses ATA_PASS_THROUGH_16 command while burning CDs
> with a SATA CD-ROM. This patch adds support to it so that PSCSI 
> CD-ROM passthrough works with the cdrecord.
> 
> Signed-off-by: Cong Meng <mc@linux.vnet.ibm.com>
> ---
[...]
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index f34a5a8..f6dcd25 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -116,6 +116,7 @@ struct scsi_cmnd;
>  #define PERSISTENT_RESERVE_IN 0x5e
>  #define PERSISTENT_RESERVE_OUT 0x5f
>  #define VARIABLE_LENGTH_CMD   0x7f
> +#define ATA_PASS_THROUGH_16   0x85
>  #define REPORT_LUNS           0xa0
>  #define SECURITY_PROTOCOL_IN  0xa2
>  #define MAINTENANCE_IN        0xa3

We already have this: they're called ATA_16 (and ATA_12) in this very
file.

James


