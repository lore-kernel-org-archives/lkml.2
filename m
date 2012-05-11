Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422677Ab2EKSPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:15:38 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30918 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215Ab2EKSPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:15:36 -0400
Date: Fri, 11 May 2012 21:18:48 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH] staging: comedi: register sysfs device attributes with
 driver core
Message-ID: <20120511181848.GA16984@mwanda>
References: <201205101805.28589.hartleys@visionengravers.com>
 <20120511061649.GW22134@mwanda>
 <4FAD109A.9040607@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAD109A.9040607@mev.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 02:14:02PM +0100, Ian Abbott wrote:
> On 2012-05-11 07:16, Dan Carpenter wrote:
> >On Thu, May 10, 2012 at 06:05:28PM -0700, H Hartley Sweeten wrote:
> >>-static const struct attribute_group comedi_sysfs_files = {
> >>-	.attrs	= comedi_attrs,
> >>+static struct device_attribute comedi_dev_attrs[] = {
> >>+	__ATTR(max_read_buffer_kb, S_IRUGO | S_IWUSR,
> >>+		show_max_read_buffer_kb, store_max_read_buffer_kb),
> >>+	__ATTR(read_buffer_kb, S_IRUGO | S_IWUSR | S_IWGRP,
> >>+		show_read_buffer_kb, store_read_buffer_kb),
> >>+	__ATTR(max_write_buffer_kb, S_IRUGO | S_IWUSR,
> >>+		show_max_write_buffer_kb, store_max_write_buffer_kb),
> >>+	__ATTR(write_buffer_kb, S_IRUGO | S_IWUSR | S_IWGRP,
> >>+		show_write_buffer_kb, store_write_buffer_kb),
> >>+	__ATTR_NULL
> >
> >Some of these are group writable and some are only user writable so
> >it's not consistent.  Probably just make them user writeable.
> >
> >I guess this was in the original code too, but it's just more
> >obvious now that they're grouped together.
> 
> Is it possible to change (group) ownership of these attribute files
> using udev rules?  Ideally, users in the group that has group
> ownership on the /dev/comedi* files should be able to modify the
> read_buffer_kb and write_buffer_kb attribute files as well, but only
> super-users should be able to modify the max_read_buffer_kb and
> max_write_buffer_kb files.
> 

Oh.  Ok that's fine then.  I didn't understand what was going on.

regards,
dan carpenter

