Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab0KDN13 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 09:27:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39403 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab0KDN1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 09:27:22 -0400
Date: Thu, 4 Nov 2010 06:23:39 -0700
From: Greg KH <gregkh@suse.de>
To: Samu Onkalo <samu.p.onkalo@nokia.com>
Cc: hmh@hmh.eng.br, alan@linux.intel.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysfs: device-core: sysfs open close notify
Message-ID: <20101104132339.GC10390@suse.de>
References: <1288861417-469-1-git-send-email-samu.p.onkalo@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1288861417-469-1-git-send-email-samu.p.onkalo@nokia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 04, 2010 at 11:03:37AM +0200, Samu Onkalo wrote:
> Patch adds possibility for a driver to get open and close
> notifications from the sysfs accesses. Driver may need this
> information for enabling features and for runtime
> power management control.
> 
> Patch causes quite small overhead compared to current implementation.
> Sysfs_ops is enhanced with open_close notify method which causes
> some increase to static memory consumption. Sysfs attribute defition
> is not changed.
> 
> Device core is modified with open_close_notification function and
> corresponding sysfs_ops change. New macro is introduced which can
> be used to setup sysfs attributes with open_close notification
> in a device driver.
> 
> Sysfs control itself contains new optional calls to open_close_
> notifications and a function which controls the feature.
> By default nothing it changed at runtime.
> 
> Normal sysfs creation and remove functions can be used to control
> attributes in device drivers.
> 
> Change needed device drivers:
> For sysfs attributes which needs open_close_notification:
> Use DEVICE_ATTR_NOTIFY instead of DEVICE_ATTR with sysfs attributes.
> Call sysfs_set_open_notify for those attributes after the creation.

Can you somehow not have to make the extra call to
sysfs_set_open_notify?  The driver doesn't want to dig down and find the
kobject, and shouldn't have to do this.  Also, it will race with the
creation of the sysfs file and userspace opening the file before the
driver has the ability to set this marking on the file, so the driver
could never be notified of the original open and everyone involved will
be confused.

thanks,

greg k-h
