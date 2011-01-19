Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973Ab1ASPaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 10:30:22 -0500
Received: from www.hansjkoch.de ([178.63.77.200]:51736 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab1ASPaV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 10:30:21 -0500
X-Greylist: delayed 2060 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Jan 2011 10:30:21 EST
Date: Wed, 19 Jan 2011 15:56:20 +0100
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: Earl Chew <echew@ixiacom.com>
Cc: linux-kernel@vger.kernel.org, "Hans J. Koch" <hjk@linutronix.de>,
        Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: RFC: UIO  null parent for __uio_register_device and
 uio_device_name()
Message-ID: <20110119145619.GA17399@local>
References: <4D366104.1000400@ixiacom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D366104.1000400@ixiacom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 07:56:52PM -0800, Earl Chew wrote:
> Hans,

Hi Earl,

> 
> I had a two UIO changes queued up from earlier which I
> forgot to ask you about.
> 
> Would you consider these changes for inclusion in the mainline ?
> 
> 
> o Allow a null parent during uio_register_device. We've had
>   situations where there was no convenient parent. We could
>   concoct a parent, but it seemed to make sense to allow
>   for a null.

Hmm. I saw many UIO drivers over the years but we never had that
problem. In the probe() function of your UIO driver you get a
suitable device as parameter. Why don't you just use it?

> 
> o Introduce uio_device_name() to allow callers to query for the
>   name of the created uio device. Without this, there doesn't seem
>   to be a straightforward way for a client to figure out the name of the
>   device.

Yes, we intentionally defined struct uio_device in uio.c and not in
a header file to prevent driver authors from using it ;-)

> 
> --- /tmp/uio.c.orig     2011-01-18 17:38:17.157452875 -0800
> +++ /tmp/uio.c  2011-01-18 19:46:48.367453578 -0800
> @@ -808,6 +808,18 @@
>  }
> 
>  /**
> + * uio_device_name - obtain the name of the registered device
> + * @info:      UIO device capabilities
> + *
> + * returns name of device.
> + */
> +const char *uio_device_name(struct uio_info *info)
> +{
> +       return dev_name(info->uio_dev->dev);

No NULL checks? Note that info->uio_dev can be NULL if uio_register_device()
failed...

> +}
> +EXPORT_SYMBOL_GPL(uio_device_name);

The function above returns strings like "uio0", "uio1", and so on. What's
the value of that? To identify a certain driver or distinguish several
instances of it, the "name" member of struct uio_info should be used.

But maybe I just miss the point. What's your use case?

Thanks,
Hans

