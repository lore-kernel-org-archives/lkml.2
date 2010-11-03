Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab0KCWcg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 18:32:36 -0400
Received: from mail.perches.com ([173.55.12.10]:3978 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab0KCWcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 18:32:33 -0400
Subject: Re: [PATCH 3/3] Staging: comedi: fix brace coding style issue in
 pcl818.c
From: Joe Perches <joe@perches.com>
To: Damian Varayud <davarayud@gmail.com>
Cc: gregkh@suse.de, harmonco@engr.orst.edu, sam.j.richardson@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Medina Raul Ezequiel <ezemed7@gmail.com>
In-Reply-To: <1288819162-6330-3-git-send-email-user@netbu>
References: <1288819162-6330-1-git-send-email-user@netbu>
	 <1288819162-6330-3-git-send-email-user@netbu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 15:32:32 -0700
Message-ID: <1288823552.10236.52.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-03 at 18:19 -0300, Damian Varayud wrote:
> This is a patch to the pcl818.c file that fixes up braces, indentation, printk() and overlines warning
> and error at initializing variable found by the checkpatch.pl tool
>  			printk
> -			    ("comedi: A/D mode1/3 FIFO - channel dropout %d!=%d !\n",
> +			    ("comedi: A/D mode1/3 FIFO - channel "
> +			     "dropout %d!=%d !\n",

Not an improvement.
Please ignore any checkpatch long line complaints about printk formats.

Another thing you could do would be to convert these to
	printk(KERN_ERR
	       "comedi: A/D mode1/3 FIFO - channel dropout %d!=%d !\n",
	       etc);

That fixes the missing KERN_<level> and as well doesn't get any
complaint from checkpatch.

[]
> @@ -1753,22 +1800,23 @@ static int pcl818_attach(struct comedi_device *dev, struct comedi_devconfig *it)
>  
>  	/* claim our I/O space */
>  	iobase = it->options[0];
> -	printk("comedi%d: pcl818:  board=%s, ioport=0x%03lx",
> +	printk(KERN_ERR "comedi%d: pcl818:  board=%s, ioport=0x%03lx",
>  	       dev->minor, this_board->name, iobase);
>  	devpriv->io_range = this_board->io_range;
> -	if ((this_board->fifo) && (it->options[2] == -1)) {	/*  we've board with FIFO and we want to use FIFO */
> +	/*  we've board with FIFO and we want to use FIFO */
> +	if ((this_board->fifo) && (it->options[2] == -1)) {
>  		devpriv->io_range = PCLx1xFIFO_RANGE;
>  		devpriv->usefifo = 1;
>  	}
>  	if (!request_region(iobase, devpriv->io_range, "pcl818")) {
> -		printk("I/O port conflict\n");
> +		printk(KERN_ERR "I/O port conflict\n");

Not correct, these and several below are actually
continuation printks not the start of new lines.
The KERN_<level> that should be used is KERN_CONT.


