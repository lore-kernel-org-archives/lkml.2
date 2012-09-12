Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab2ILUYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 16:24:45 -0400
Received: from [205.233.59.134] ([205.233.59.134]:52592 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab2ILUYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 16:24:43 -0400
Message-ID: <5050EF35.6090903@kernel.dk>
Date: Wed, 12 Sep 2012 22:23:17 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: David Milburn <dmilburn@redhat.com>
CC: asamymuthupa@micron.com, linux-kernel@vger.kernel.org, thenzl@redhat.com
Subject: Re: [PATCH] mtip32xx: fix user_buffer check in exec_drive_command
References: <1347476772-21798-1-git-send-email-dmilburn@redhat.com>
In-Reply-To: <1347476772-21798-1-git-send-email-dmilburn@redhat.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-12 21:06, David Milburn wrote:
> Current user_buffer check is incorrect and causes hdparm to fail
> 
> # hdparm -I /dev/rssda
>  HDIO_DRIVE_CMD(identify) failed: Input/output error
> 
> /dev/rssda:
> 
> Patching linux-3.6-rc5 hdparm works as expected
> 
> # hdparm -I /dev/rssda
> /dev/rssda:
> 
> ATA device, with non-removable media
> 	Model Number:       DELL_P320h-MTFDGAL350SAH                
> 	Serial Number:      00000000121302025F01
> 	Firmware Revision:  B1442808
> <snip>
> 
> Reported-by: Tomas Henzl <thenzl@redhat.com>
> Signed-off-by: David Milburn <dmilburn@redhat.com>
> ---
>  drivers/block/mtip32xx/mtip32xx.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
> index a8fddeb..b24efe3 100644
> --- a/drivers/block/mtip32xx/mtip32xx.c
> +++ b/drivers/block/mtip32xx/mtip32xx.c
> @@ -1900,7 +1900,7 @@ static int exec_drive_command(struct mtip_port *port, u8 *command,
>  	int rv = 0, xfer_sz = command[3];
>  
>  	if (xfer_sz) {
> -		if (user_buffer)
> +		if (!user_buffer)
>  			return -EFAULT;
>  
>  		buf = dmam_alloc_coherent(&port->dd->pdev->dev,

Thanks, that's clearly a bug. Applied.

-- 
Jens Axboe

