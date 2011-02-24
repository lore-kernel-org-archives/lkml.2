Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab1BXMbu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 07:31:50 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49046 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab1BXMbt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 07:31:49 -0500
Date: Thu, 24 Feb 2011 09:49:22 +0000
From: Jamie Iles <jamie@jamieiles.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [RFC] [PATCH 2/10] Generic Watchdog Timer Driver
Message-ID: <20110224094922.GB15118@pulham.picochip.com>
References: <20110223204228.GA7369@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110223204228.GA7369@infomag.iguana.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 09:42:28PM +0100, Wim Van Sebroeck wrote:
> commit 79a856016f4f4314360d6efbbbc334828006a79f
> Author: Wim Van Sebroeck <wim@iguana.be>
> Date:   Fri Jun 18 08:58:13 2010 +0000
> 
>     watchdog: WatchDog Timer Driver Core - Part 2
>     
>     This part add's the basic ioctl functionality to the
>     WatchDog Timer Driver Core framework. The supported
>     ioctl call's are:
>     	WDIOC_GETSUPPORT
>     	WDIOC_GETSTATUS
>     	WDIOC_GETBOOTSTATUS
>     
>     Signed-off-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
>     Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
> 
> diff --git a/Documentation/watchdog/src/watchdog-with-timer-example.c b/Documentation/watchdog/src/watchdog-with-timer-example.c
> index d0b6056..ed7852a 100644
> --- a/Documentation/watchdog/src/watchdog-with-timer-example.c
> +++ b/Documentation/watchdog/src/watchdog-with-timer-example.c
> @@ -115,6 +115,10 @@ static int wdt_stop(struct watchdog_device *wdd)
>  /*
>   * The watchdog kernel structures
>   */
> +static const struct watchdog_info wdt_info = {
> +	.identity =	DRV_NAME,
> +};
> +
>  static const struct watchdog_ops wdt_ops = {
>  	.start =	wdt_start,
>  	.stop =		wdt_stop,
> @@ -123,6 +127,7 @@ static const struct watchdog_ops wdt_ops = {
>  
>  static struct watchdog_device wdt_dev = {
>  	.name =		DRV_NAME,
> +	.info =		&wdt_info,
>  	.ops =		&wdt_ops,
>  };
>  
> diff --git a/Documentation/watchdog/watchdog-kernel-api.txt b/Documentation/watchdog/watchdog-kernel-api.txt
> index e69d1cc..9418d4c 100644
> --- a/Documentation/watchdog/watchdog-kernel-api.txt
> +++ b/Documentation/watchdog/watchdog-kernel-api.txt
> @@ -40,13 +40,19 @@ The watchdog device structure looks like this:
>  
>  struct watchdog_device {
>  	char *name;
> +	const struct watchdog_info *info;
>  	const struct watchdog_ops *ops;
> +	int bootstatus;
>  	long status;
>  };
>  
>  It contains following fields:
>  * name: a pointer to the (preferably unique) name of the watchdog timer device.
> +* info: a pointer to a watchdog_info structure. This structure gives some
> +  additional information about the watchdog timer itself.
>  * ops: a pointer to the list of watchdog operations that the watchdog supports.
> +* bootstatus: status of the device after booting (reported with watchdog
> +  WDIOF_* status bits).
>  * status: this field contains a number of status bits that give extra
>    information about the status of the device (Like: is the device opened via
>    the /dev/watchdog interface or not, ...)
> @@ -59,6 +65,7 @@ struct watchdog_ops {
>  	int (*stop)(struct watchdog_device *);
>  	/* optional operations */
>  	int (*ping)(struct watchdog_device *);
> +	int (*status)(struct watchdog_device *);

It looks like the actual addition of .status to watchdog_ops happens in 
the next patch rather than this one.

Jamie
