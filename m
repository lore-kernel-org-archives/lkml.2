Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab1ANHrc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 02:47:32 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44302 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab1ANHr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 02:47:28 -0500
Date: Fri, 14 Jan 2011 08:47:23 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: ahern.michael.t@gmail.com
Cc: gregkh@suse.de, julia@diku.dk, nikai@nikai.net, morgan.gatti@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Coding style in serial2002
Message-ID: <20110114074723.GA24920@pengutronix.de>
References: <1294967694-4840-1-git-send-email-ahern.michael.t@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1294967694-4840-1-git-send-email-ahern.michael.t@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jan 14, 2011 at 12:14:54PM +1100, ahern.michael.t@gmail.com wrote:
> @@ -329,7 +332,7 @@ static struct serial_data serial_read(struct file *f, int timeout)
>  
>  		length++;
>  		if (data < 0) {
> -			printk("serial2002 error\n");
> +			printk(KERN_ERR "serial2002 error\n");
better use pr_err

>  			break;
>  		} else if (data & 0x80) {
>  			result.value = (result.value << 7) | (data & 0x7f);
> @@ -402,7 +405,7 @@ static int serial_2002_open(struct comedi_device *dev)
>  	devpriv->tty = filp_open(port, O_RDWR, 0);
>  	if (IS_ERR(devpriv->tty)) {
>  		result = (int)PTR_ERR(devpriv->tty);
> -		printk("serial_2002: file open error = %d\n", result);
> +		printk(KERN_ERR "serial_2002: file open error = %d\n", result);
>  	} else {
>  		struct config_t {
>  
> @@ -434,7 +437,7 @@ static int serial_2002_open(struct comedi_device *dev)
>  		}
>  
>  		tty_setspeed(devpriv->tty, devpriv->speed);
> -		poll_channel(devpriv->tty, 31);	/*  Start reading configuration */
> +		poll_channel(devpriv->tty, 31);	/* Start reading config */
>  		while (1) {
>  			struct serial_data data;
>  
> @@ -451,23 +454,23 @@ static int serial_2002_open(struct comedi_device *dev)
>  				command = (data.value >> 8) & 0x3;
>  				switch (kind) {
>  				case 1:{
IMHO these braces can go away, too.

Best regards
Uwe


-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
