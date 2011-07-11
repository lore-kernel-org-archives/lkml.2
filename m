Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383Ab1GKIIQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 04:08:16 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58239 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335Ab1GKIIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 04:08:15 -0400
Date: Mon, 11 Jul 2011 11:06:44 +0300
From: Dan Carpenter <error27@gmail.com>
To: Ravishankar <ravishankarkm32@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH 8/8] Staging: comedi: fix printk() issue in pcl818.c
Message-ID: <20110711080644.GF18655@shale.localdomain>
References: <1310368754-25560-1-git-send-email-ravishankarkm32@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310368754-25560-1-git-send-email-ravishankarkm32@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 12:49:14PM +0530, Ravishankar wrote:
> From: Ravishankar <ravi.shankar@greenturtles.in>
> 
> This is a patch to the pcl818.c file that fixes up a printk warning found by the checkpatch.pl tool
> 
> Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
> ---
>  drivers/staging/comedi/drivers/pcl818.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
> index ae097b3..21f1cc9 100644
> --- a/drivers/staging/comedi/drivers/pcl818.c
> +++ b/drivers/staging/comedi/drivers/pcl818.c
> @@ -1447,7 +1447,7 @@ static int ai_cmd(struct comedi_device *dev, struct comedi_subdevice *s)
>  	struct comedi_cmd *cmd = &s->async->cmd;
>  	int retval;
>  
> -	printk("pcl818_ai_cmd()\n");
> +	printk(KERN_INFO "pcl818_ai_cmd()\n");

KERN_INFO is too high a level here.  Ideally this would just be
removed.  Possibly made into a dev_dbg().

The same is true for some other printks in this series.

regards,
dan carpenter

