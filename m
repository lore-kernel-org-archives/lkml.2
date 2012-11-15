Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768608Ab2KORww (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 12:52:52 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60472 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768567Ab2KORwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 12:52:50 -0500
Date: Thu, 15 Nov 2012 15:52:43 -0200
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [ 27/82] gpiolib: Dont return -EPROBE_DEFER to sysfs, or for
 invalid gpios
Message-ID: <20121115175242.GA10102@herton-Z68MA-D2H-B3>
References: <20121114053933.726869752@decadent.org.uk>
 <20121114053937.652708298@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121114053937.652708298@decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 05:40:00AM +0000, Ben Hutchings wrote:
> 3.2-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Mathias Nyman <mathias.nyman@linux.intel.com>
> 
> commit ad2fab36d7922401c4576fb7ea9b21a47a29a17f upstream.
> 
> gpios requested with invalid numbers, or gpios requested from userspace via sysfs
> should not try to be deferred on failure.
> 
> Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  drivers/gpio/gpiolib.c |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 5d6c71e..1c8d9e3 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -623,9 +623,11 @@ static ssize_t export_store(struct class *class,
>  	 */
>  
>  	status = gpio_request(gpio, "sysfs");
> -	if (status < 0)
> +	if (status < 0) {
> +		if (status == -EPROBE_DEFER)

This one fails to build here:
linux/drivers/gpio/gpiolib.c: In function 'export_store':
linux/drivers/gpio/gpiolib.c:625:18: error: 'EPROBE_DEFER' undeclared (first use in this function)
linux/drivers/gpio/gpiolib.c:625:18: note: each undeclared identifier is reported only once for each function it appears in

There is no EPROBE_DEFER functionality on 3.2 and in gpio_request, so I
think the patch can be safely dropped.

[...]

-- 
[]'s
Herton
