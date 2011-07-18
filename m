Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab1GRJnt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 05:43:49 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:28183 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab1GRJns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 05:43:48 -0400
Date: Mon, 18 Jul 2011 11:43:46 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Ravishankar <ravishankarkm32@gmail.com>
cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH 30/30 v2] Staging: comedi: fix printk() issue in
 das16m1.c
In-Reply-To: <1310982260-957-1-git-send-email-ravishankarkm32@gmail.com>
Message-ID: <alpine.LNX.2.00.1107181139270.2483@swampdragon.chaosbits.net>
References: <[PATCH]Staging: comedi: fix printk() issue in das16m1.c> <1310982260-957-1-git-send-email-ravishankarkm32@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jul 2011, Ravishankar wrote:

> From: Ravishankar <ravi.shankar@greenturtles.in>
> 
> This is a patch to the das16m1.c file that fixes up a printk() warning found by the checkpatch.pl tool
> 
> Signed-off-by: Ravishankar <ravishankarkm32@gmail.com>
> ---
> 
>  After understanding code I have changed  8 printk statement in int das16m1_attach function. 
> 
>  drivers/staging/comedi/drivers/das16m1.c |   16 +++++++++-------
>  1 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/das16m1.c b/drivers/staging/comedi/drivers/das16m1.c
> index efc6132..d737ed2 100644
> --- a/drivers/staging/comedi/drivers/das16m1.c
> +++ b/drivers/staging/comedi/drivers/das16m1.c
> @@ -680,17 +680,19 @@ static int das16m1_attach(struct comedi_device *dev,
>  
>  	dev->board_name = thisboard->name;
>  
> -	printk(" io 0x%lx-0x%lx 0x%lx-0x%lx",
> +	printk(KERN_INFO " requesing the I/O region from 0x%lx-0x%lx 0x%lx-0x%lx",

Correct spelling is "requesting" and the "from" should either have a 
matching "to" or just be dropped IMHO.

Personally I'd just make it:
" requesting I/O region 0x%lx-0x%lx 0x%lx-0x%lx"


>  	       iobase, iobase + DAS16M1_SIZE,
>  	       iobase + DAS16M1_82C55, iobase + DAS16M1_82C55 + DAS16M1_SIZE2);
>  	if (!request_region(iobase, DAS16M1_SIZE, driver_das16m1.driver_name)) {
> -		printk(" I/O port conflict\n");
> -		return -EIO;
> +		printk(KERN_INFO "the IO REGION is busy, quitting\n");
> +		return -EBUSY;
>  	}
>  	if (!request_region(iobase + DAS16M1_82C55, DAS16M1_SIZE2,
>  			    driver_das16m1.driver_name)) {
>  		release_region(iobase, DAS16M1_SIZE);
> - 		printk(" I/O port conflict\n");
> +		printk(KERN_INFO " releasing  the I/O port region\n");

I think the original text was better.


-- 
Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
Don't top-post http://www.catb.org/jargon/html/T/top-post.html
Plain text mails only, please.

