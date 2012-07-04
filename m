Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab2GDRKQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 13:10:16 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:49433 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab2GDRKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 13:10:12 -0400
Message-ID: <4FF4789D.508@mvista.com>
Date: Wed, 04 Jul 2012 21:08:45 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] ata: implement MODE SELECT command
References: <1341400436-2546-1-git-send-email-pbonzini@redhat.com>
In-Reply-To: <1341400436-2546-1-git-send-email-pbonzini@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/04/2012 03:13 PM, Paolo Bonzini wrote:

> The cache_type file in sysfs lets users configure the disk cache in
> write-through or write-back modes.  However, ata disks do not support
> writing to the file because they do not implement the MODE SELECT
> command.

> This patch adds a translation from MODE SELECT (for the caching page
> only) to the ATA SET FEATURES command.

> Cc: Jeff Garzik <jgarzik@pobox.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  drivers/ata/libata-scsi.c |  147 +++++++++++++++++++++++++++++++++++++++++++--
>  1 files changed, 142 insertions(+), 5 deletions(-)

> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 41cde45..e7702d3 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
[...]
> +	switch (pg) {
> +	case CACHE_MPAGE:
> +		if (ata_mselect_caching(tf, p, pg_len))
> +			goto invalid_fld;

   Error is in the data, not CDB, so returning "invalied field in CDB" doesn't
make sense...

> +		break;
> +
> +	default:		/* invalid page code */
> +		goto invalid_fld;
> +	}
> +	return 0;
> +
> + invalid_fld:
> +	ata_scsi_set_sense(scmd, ILLEGAL_REQUEST, 0x24, 0x0);
> +	/* "Invalid field in cbd" */

   s/cbd/CDB/

MBR, Sergei
