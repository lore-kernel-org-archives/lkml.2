Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759528Ab0GVONa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 10:13:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49106 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759400Ab0GVON0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 10:13:26 -0400
Date: Thu, 22 Jul 2010 10:13:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
cc: linux-kernel@vger.kernel.org,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Denis Karpov <ext-denis.2.karpov@nokia.com>,
        Adrian Hunter <adrian.hunter@nokia.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linux-usb@vger.kernel.org>
Subject: Re: [PATCHv4 2/2] usb: gadget: storage: optional SCSI WRITE FUA bit
In-Reply-To: <1279789128-11399-2-git-send-email-ext-andriy.shevchenko@nokia.com>
Message-ID: <Pine.LNX.4.44L0.1007221007210.1725-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jul 2010, Andy Shevchenko wrote:

> MS Windows mounts removable storage in "Removal optimized mode" by
> default. All the writes to the media are synchronous which is achieved
> by setting FUA (Force Unit Access) bit in SCSI WRITE(10,12) commands.
> This prevents I/O requests aggregation in block layer dramatically
> decreasing performance.
> 
> This patch brings an option to accept or ignore mentioned bit
>  a) via specifying module parameter "nofua", or
>  b) through sysfs entry
> 	/sys/devices/platform/musb_hdrc/gadget/gadget-lun-X/nofua
> 
> Patch is based on the work that was done by Denis Karpov for Maemo 5
> platform.
> 
> Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
> Cc: Denis Karpov <ext-denis.2.karpov@nokia.com>
> Cc: Adrian Hunter <adrian.hunter@nokia.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: David Brownell <dbrownell@users.sourceforge.net>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: linux-usb@vger.kernel.org
> ---
>  .../sysfs-devices-platform-musb_hdrc-gadget        |   12 +++++++
>  drivers/usb/gadget/file_storage.c                  |   31 +++++++++++++++----
>  drivers/usb/gadget/storage_common.c                |   28 ++++++++++++++++++
>  3 files changed, 64 insertions(+), 7 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-devices-platform-musb_hdrc-gadget
> 
> diff --git a/Documentation/ABI/testing/sysfs-devices-platform-musb_hdrc-gadget b/Documentation/ABI/testing/sysfs-devices-platform-musb_hdrc-gadget
> new file mode 100644
> index 0000000..192d3f3
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-devices-platform-musb_hdrc-gadget
> @@ -0,0 +1,12 @@
> +What:           /sys/devices/platform/musb_hdrc/gadget/gadget-lun-X/nofua

The name of the new file and the path given here shouldn't mention
musb_hdrc.  That's what _you_ see because that's the device controller
driver you use, but other people will see something different.  As a
simple test, you might try using dummy_hcd instead and see what the
name turns out to be.

Just put "..." instead of "musb_hdrc", or something like that.

> +Date:           July 2010
> +Contact:        Andy Shevchenko <andy.shevchenko@gmail.com>
> +Description:
> +		Show or set the reaction on the FUA (Force Unit Access) bit in
> +		the SCSI WRITE(10,12) commands when a gadget in USB Mass
> +		Storage mode.
> +
> +		Possible values are:
> +			1 -> ignore FUA flag
> +			0 -> follow on it

Change this to "obey the FUA flag".

The rest is okay.  Subject to these changes:

Acked-by: Alan Stern <stern@rowland.harvard.edu>

