Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab0KFMKX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 08:10:23 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50702 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753866Ab0KFMKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 08:10:21 -0400
Date: Sat, 6 Nov 2010 13:10:14 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org
Subject: Re: [PATCH] IDE: ide-floppy, remove unnecessary NULL check
Message-ID: <20101106121014.GA25287@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Jiri Slaby <jslaby@suse.cz>, jirislaby@gmail.com,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	"David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org
References: <1289034412-24278-1-git-send-email-jslaby@suse.cz>
 <1289034412-24278-3-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1289034412-24278-3-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 06, 2010 at 10:06:51AM +0100, Jiri Slaby wrote:
> Stanse founf that rq in ide_floppy_callback cannot be NULL, because it
> is dereferenced all around. So remove the superfluous check.
> 
> This appeared after blk_* macors removal.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: linux-ide@vger.kernel.org
> ---
>  drivers/ide/ide-floppy.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
> index 5406b6e..536ff68 100644
> --- a/drivers/ide/ide-floppy.c
> +++ b/drivers/ide/ide-floppy.c
> @@ -73,7 +73,7 @@ static int ide_floppy_callback(ide_drive_t *drive, int dsc)
>  		drive->failed_pc = NULL;
>  
>  	if (pc->c[0] == GPCMD_READ_10 || pc->c[0] == GPCMD_WRITE_10 ||
> -	    (rq && rq->cmd_type == REQ_TYPE_BLOCK_PC))
> +	    rq->cmd_type == REQ_TYPE_BLOCK_PC)
>  		uptodate = 1; /* FIXME */
>  	else if (pc->c[0] == GPCMD_REQUEST_SENSE) {

If this isn't a fix for a real bug, then there's no need for it since
IDE is deprecated and thus in bugfix mode only.

-- 
Regards/Gruss,
    Boris.
