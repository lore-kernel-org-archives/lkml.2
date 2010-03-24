Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab0CXC0O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 22:26:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55231 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230Ab0CXC0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 22:26:10 -0400
Date: Tue, 23 Mar 2010 19:23:58 -0700
From: Greg KH <gregkh@suse.de>
To: "Savoy, Pavan" <pavan_savoy@ti.com>
Cc: "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
Message-ID: <20100324022358.GB4254@suse.de>
References: <1269292756-7469-1-git-send-email-pavan_savoy@ti.com> <1269292756-7469-2-git-send-email-pavan_savoy@ti.com> <1269292756-7469-3-git-send-email-pavan_savoy@ti.com> <1269292756-7469-4-git-send-email-pavan_savoy@ti.com> <19F8576C6E063C45BE387C64729E7394044DB828A2@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19F8576C6E063C45BE387C64729E7394044DB828A2@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 03:33:50AM +0530, Savoy, Pavan wrote:
> 
> ----------------------
> Thanks & Regards,
> Pavan Savoy | x0099669

That made no sense :(

> On Mon, Mar 22, 2010 at 04:19:14PM -0500, pavan_savoy@ti.com wrote:
> > +/* structures specific for sysfs entries */
> > +static struct kobj_attribute pid_attr =
> > +__ATTR(pid, 0644, (void *)show_pid, (void *)store_pid);
> > +
> > +static struct kobj_attribute list_protocols =
> > +__ATTR(protocols, 0444, (void *)show_list, NULL);
> 
> >As you are creating sysfs attributes, you have to have
> >Documentation/ABI/ updates as well.  Please include them so we can see
> >what you are trying to do here.
> >And why "raw" attributes and not device ones?
> >thanks,
> >greg k-h
> 
> [pavan] >>>>>>>>

Ick.  Please fix your email client to quote properly.  There are
hundreds of free email programs out there that will do that.  Heck,
there are free web email clients that even get this right...

> I am creating a sysfs entry for the daemon/service to write in it's
> PID to the sysfs entry, so as to whenever a new protocol driver -
> BT/FM or GPS wants to use the N_TI_SHARED ldisc, the driver would then
> send signal to daemon on this PID.

Then document it.  All sysfs files need documentation.

Hm, writing a PID to a sysfs file?  Oh, that's going to be ripe for
problems.  What namespace is that PID in?

> The source for this problem, was that I could not install line
> discipline from kernel space.  i.e make N_TI_SHARED line discipline
> the current ldisc from kernel space itself.

Are you sure?  I thought the bluetooth core did this already.  Have you
looked at how that works?

> >From 92d89d132b5036d8ab58ce4f36b24bb1859610e0 Mon Sep 17 00:00:00 2001
> From: Pavan Savoy <pavan_savoy@ti.com>
> Date: Mon, 22 Mar 2010 18:11:32 -0400
> Subject: [PATCH 1/1] Documentation/ABI: for N_TI_SHARED ldisc
> N_TI_SHARED creates a sysfs entry to communicate
> with the application/daemon which would want to install/
> un-install the line discipline, it's documentation
> now exists in testing/ subdirectory.
> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> ---
>  Documentation/ABI/testing/sysfs-uim |   24 ++++++++++++++++++++++++
>  1 files changed, 24 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/ABI/testing/sysfs-uim
> diff --git a/Documentation/ABI/testing/sysfs-uim b/Documentation/ABI/testing/sysfs-uim
> new file mode 100644
> index 0000000..899aa4d
> --- /dev/null
> +++ b/Documentation/ABI/testing/sysfs-uim
> @@ -0,0 +1,24 @@
> +What:           /sys/uim
> +Date:           March 22
> +Contact:        Pavan Savoy <pavan_savoy@ti.com>
> +Description:
> +                Create a new kobject to pass information about the
> +  N_TI_SHARED line discipline created to application/daemon
> +  which would install/un-install line discipline.

No, you don't get to create a new root sysfs file, sorry.  Please put it
in the correct subsystem location, if anywhere at all.

thanks,

greg k-h
