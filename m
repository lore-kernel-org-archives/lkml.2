Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab2EKGNm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 02:13:42 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:35306 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756085Ab2EKGNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 02:13:40 -0400
Date: Fri, 11 May 2012 09:16:49 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        fmhess@users.sourceforge.net, abbotti@mev.co.uk,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH] staging: comedi: register sysfs device attributes with
 driver core
Message-ID: <20120511061649.GW22134@mwanda>
References: <201205101805.28589.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205101805.28589.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 06:05:28PM -0700, H Hartley Sweeten wrote:
> -static const struct attribute_group comedi_sysfs_files = {
> -	.attrs	= comedi_attrs,
> +static struct device_attribute comedi_dev_attrs[] = {
> +	__ATTR(max_read_buffer_kb, S_IRUGO | S_IWUSR,
> +		show_max_read_buffer_kb, store_max_read_buffer_kb),
> +	__ATTR(read_buffer_kb, S_IRUGO | S_IWUSR | S_IWGRP,
> +		show_read_buffer_kb, store_read_buffer_kb),
> +	__ATTR(max_write_buffer_kb, S_IRUGO | S_IWUSR,
> +		show_max_write_buffer_kb, store_max_write_buffer_kb),
> +	__ATTR(write_buffer_kb, S_IRUGO | S_IWUSR | S_IWGRP,
> +		show_write_buffer_kb, store_write_buffer_kb),
> +	__ATTR_NULL

Some of these are group writable and some are only user writable so
it's not consistent.  Probably just make them user writeable.

I guess this was in the original code too, but it's just more
obvious now that they're grouped together.

regards,
dan carpenter

