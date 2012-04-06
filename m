Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044Ab2DFUpV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 16:45:21 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:37832 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935Ab2DFUpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 16:45:18 -0400
Date: Fri, 6 Apr 2012 13:45:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: James Bottomley <JBottomley@parallels.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 1/2] sysfs: handle 'parent deleted before child added'
Message-ID: <20120406204514.GA20237@kroah.com>
References: <20120406203619.22624.69445.stgit@dwillia2-linux.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120406203619.22624.69445.stgit@dwillia2-linux.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2012 at 01:41:06PM -0700, Dan Williams wrote:
> In scsi at least two cases of the parent device being deleted before the
> child is added have been observed.
> 
> 1/ scsi is performing async scans and the device is removed prior to the
>    async can thread running (can happen with an in-opportune / unlikely
>    unplug during initial scan).

That sounds like a bug in the scsi code, doesn't it?

> 2/ libsas discovery event running after the parent port has been torn
>    down (this is a bug in libsas).

Is this fixed somewhere?

I don't want to paper over bugs like this by changing the sysfs core.
We went through this a lot years ago when scsi changed to use the driver
core, and I thought we had fixed all of these types of errors properly.

So, any chance to fix these properly as well?

thanks,

greg k-h
