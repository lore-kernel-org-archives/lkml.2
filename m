Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab1HVVmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 17:42:00 -0400
Received: from mga03.intel.com ([143.182.124.21]:38350 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649Ab1HVVl6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 17:41:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,265,1312182000"; 
   d="scan'208";a="41235802"
Date: Mon, 22 Aug 2011 14:41:54 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-usb@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/20] drivers_base: platform: use always ->name for
 uevent
Message-ID: <20110822214154.GB20451@xanatos>
References: <1313419901-13492-1-git-send-email-bigeasy@linutronix.de>
 <1313419901-13492-2-git-send-email-bigeasy@linutronix.de>
 <CACxGe6us1vaUgMmiZR-D9iSCQdw+vbVyZdBCkET_9p3AGyHwRQ@mail.gmail.com>
 <4E4937A4.5070204@linutronix.de>
 <CACxGe6sAOYf3r4i1no=+-RgTLuiRbxYkcy+9VFXaCZOXUOi_uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACxGe6sAOYf3r4i1no=+-RgTLuiRbxYkcy+9VFXaCZOXUOi_uw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 15, 2011 at 09:17:41AM -0600, Grant Likely wrote:
> On Mon, Aug 15, 2011 at 9:13 AM, Sebastian Andrzej Siewior
> <bigeasy@linutronix.de> wrote:
> > Grant Likely wrote:
> >>>
> >>> --- a/drivers/base/platform.c
> >>> +++ b/drivers/base/platform.c
> >>> @@ -614,7 +614,7 @@ static int platform_uevent(struct device *dev, struct
> >>> kobj_uevent_env *env)
> >>>               return rc;
> >>>
> >>>       add_uevent_var(env, "MODALIAS=%s%s", PLATFORM_MODULE_PREFIX,
> >>> -               (pdev->id_entry) ? pdev->id_entry->name : pdev->name);
> >>> +                       pdev->name);
> >>
> >> Yes, this looks like the right thing to do to me.  Also, I think the
> >> original code is suspect because it causes the uevent data to be
> >> different after binding a driver to a device.
> >
> > Why different? The code matches (pdev->name == id->name) or
> > (pdev->name ==  driver->name) so in both cases it should be equal to
> > pdev->name.
> >
> > Are you or Greg taking this?
> 
> This one is all Greg.

Greg, do you want to take this patch through your driver core tree, or
would you prefer to have it come through the xHCI tree?

Sarah Sharp
