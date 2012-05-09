Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab2EIUjV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:39:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:34786 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761077Ab2EIUjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:39:20 -0400
Date: Wed, 9 May 2012 13:39:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        fmhess@users.sourceforge.net, abbotti@mev.co.uk
Subject: Re: [PATCH v2] staging: comedi: refactor sysfs files in comedi_fops.c
Message-ID: <20120509203916.GA16972@kroah.com>
References: <201205090920.09769.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205090920.09769.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 09:20:08AM -0700, H Hartley Sweeten wrote:
> Refactor the sysfs attributes and functions to remove
> the need for the forward declarations and use the
> DEVICE_ATTR macro to define them.
> 
> Instead of individually creating sysfs device attribute
> files, wrap them in an attribute_group and use the
> sysfs_create_group function to create them.

This is great, and needed to be done, but you need to take this one step
further.  This attribute group needs to be registered by the driver
core, not the comedi core, so userspace doesn't get an add event before
the files are created.  To do that, assign this attribute group to the
class and the core will handle it for you.

I've taken this patch, but will you make a follow-on patch that makes
this change, which will remove this race?  It should be a net removal of
code in the comedi core overall.

thanks,

greg k-h
