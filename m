Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab0GHIgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 04:36:21 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:36866 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754663Ab0GHIgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 04:36:19 -0400
Message-ID: <4C358DFF.9090401@kernel.dk>
Date: Thu, 08 Jul 2010 10:36:15 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/7] block: push down BKL into .locked_ioctl
References: <1278514289-21054-1-git-send-email-arnd@arndb.de> <1278514289-21054-3-git-send-email-arnd@arndb.de>
In-Reply-To: <1278514289-21054-3-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-07 16:51, Arnd Bergmann wrote:
> As a preparation for the removal of the big kernel
> lock in the block layer, this removes the BKL
> from the common ioctl handling code, moving it
> into every single driver still using it.
>
> diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
> index ad3ddef..fc593fb 100644
> --- a/drivers/message/i2o/i2o_block.c
> +++ b/drivers/message/i2o/i2o_block.c
> @@ -941,8 +930,7 @@ static const struct block_device_operations i2o_block_fops = {
>  	.owner = THIS_MODULE,
>  	.open = i2o_block_open,
>  	.release = i2o_block_release,
> -	.ioctl = i2o_block_ioctl,
> -	.compat_ioctl = i2o_block_ioctl,
> +	.locked_ioctl = i2o_block_ioctl,
>  	.getgeo = i2o_block_getgeo,
>  	.media_changed = i2o_block_media_changed
>  };

Hmm?

-- 
Jens Axboe

