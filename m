Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab0H2SYt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Aug 2010 14:24:49 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37151 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab0H2SYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Aug 2010 14:24:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=RPtEGjLgBCDNSHzA0zMQwXzzop97ASRxGQKq1IgJbjVVqWLYnyZfScFvAe+HErB2/p
         zm7ztzkwORPlCIlNnoi2RA4lx6iQq/U8zrvYrOsKW9xHvMP0oChiwbjY1odu+/Wp/uyl
         L/95tOalqVH9DpSWyrv+xzudnUfNqs5wBPNwc=
Date: Sun, 29 Aug 2010 11:24:36 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: "Murphy, Dan" <dmurphy@ti.com>
Cc: "V, Hemanth" <hemanthv@ti.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [RFC] [PATCH V2 1/2] input: CMA3000 Accelerometer driver
Message-ID: <20100829182435.GB26209@core.coreip.homeip.net>
References: <15445.10.24.255.17.1274424777.squirrel@dbdmail.itg.ti.com>
 <4BF6753B.60201@cam.ac.uk>
 <0ebd01cb3ae5$a0dcfc70$LocalHost@wipblrx0099946>
 <C9D59C82B94F474B872F2092A87F261412470D0874@dlee07.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C9D59C82B94F474B872F2092A87F261412470D0874@dlee07.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 08:34:07AM -0500, Murphy, Dan wrote:
> Hemanth
> I have a few comments on this patch.
> 
> +static ssize_t cma3000_store_attr_mdfftmr(struct device *dev,
> +					struct device_attribute *attr,
> +					const char *buf, size_t count)
> +{
> +	struct platform_device *pdev = to_platform_device(dev);
> +	struct cma3000_accl_data *data = platform_get_drvdata(pdev);
> +	unsigned long val;
> +	int error;
> +
> +	error = strict_strtoul(buf, 0, &val);
> +	if (error)
> +		return error;
> +
> +	mutex_lock(&data->mutex);
> +	data->pdata.mdfftmr = val;
> +
> +	disable_irq(data->client->irq);
> You should use disable_irq_nosync here.  This may not work properly on SMP.

This is an incorrect statement. disable_irq() is not safe to use on SMP when
caller may not sleep (since it will wait for the running handler to
complete), but in this context it is perfectly safe,

-- 
Dmitry
