Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab2K2VxE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 16:53:04 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:24863 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754678Ab2K2VxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 16:53:02 -0500
Date: Fri, 30 Nov 2012 00:52:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Laurent Navet [Mali]" <laurent.navet@gmail.com>
Cc: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        line6linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: line6: use kstrtoint() instead of
 simple_strtoul()
Message-ID: <20121129215244.GR11248@mwanda>
References: <1354219418-6882-1-git-send-email-laurent.navet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354219418-6882-1-git-send-email-laurent.navet@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 09:03:38PM +0100, Laurent Navet [Mali] wrote:
> From: "Laurent Navet [Mali]" <laurent.navet@gmail.com>
> 
> staging: line6: pcm.c
> 	call to obsolete simple_strtoul() function is replaced
>         by kstrtoint() in pcm_set_impulse_period().
> 	Also check the return code.
> 
> Signed-off-by: Laurent Navet [Mali] <laurent.navet@gmail.com>
> ---
>  drivers/staging/line6/pcm.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/line6/pcm.c b/drivers/staging/line6/pcm.c
> index a0ce781..876ab89 100644
> --- a/drivers/staging/line6/pcm.c
> +++ b/drivers/staging/line6/pcm.c
> @@ -81,7 +81,13 @@ static ssize_t pcm_set_impulse_period(struct device *dev,
>  				      struct device_attribute *attr,
>  				      const char *buf, size_t count)
>  {
> -	dev2pcm(dev)->impulse_period = simple_strtoul(buf, NULL, 10);
> +        int value;
> +        int rv;

This uses spaces instead of tabs.  Run scripts/checkpatch.pl over
the patch before submitting.

Put a blank line here between the declarations and the code.

I see that you copied "rv" from the other places in the file and
generally matching the context is good, but in this case I think
"rv" is non-standard.  Normally we would use "ret" or "rc".

> +        rv = kstrtoint(buf, 10, &value);
> +        if (rv < 0)
> +		return rv;

Could you fix up those small details and resend?

regards,
dan carpenter

