Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab0ITSwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 14:52:42 -0400
Received: from kroah.org ([198.145.64.141]:56624 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371Ab0ITSwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:52:41 -0400
Date: Mon, 20 Sep 2010 11:52:32 -0700
From: Greg KH <greg@kroah.com>
To: Andy Walls <awalls@md.metrocast.net>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Dave Airlie <airlied@redhat.com>, Jon Smirl <jonsmirl@gmail.com>
Subject: Re: [PATCH] drm/sysfs: Provide per connector control of DRM KMS
 polling
Message-ID: <20100920185232.GA29263@kroah.com>
References: <1284987540.2242.29.camel@morgan.silverblock.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284987540.2242.29.camel@morgan.silverblock.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 08:59:00AM -0400, Andy Walls wrote:
> DRM KMS polling of connections providing errant EDID responses, or
> polling of "connectors" that have chips responding on DDC I2C bus
> address 0xA0/0xA1 with no actual physical connector nor EDID EEPROM,
> will create perpetual noise in dmesg and the system log every 10
> seconds.  Currently the user has apparently little recourse to silence
> these messages aside from replacing the offending cable, monitor, or
> graphics adapter.  That recourse is impossible for an unused DVI-D
> "connector" of an internal graphics processor on a motherboard that
> provides no physical DVI-D connector.
> 
> This change allows the root user to disable (and re-enable) DRM KMS
> connector polling on a per connector basis via sysfs, like so:
> 
>         # cat /sys/class/drm/card0/card0-DVI-D-1/polled
>         [hotplug_detectable] connect disconnect
>         
>         # echo > /sys/class/drm/card0/card0-DVI-D-1/polled
>         # cat /sys/class/drm/card0/card0-DVI-D-1/polled
>         hotplug_detectable connect disconnect
>         
>         # echo " connect  hotplug_detectable " > \
>         	/sys/class/drm/card0/card0-DVI-D-1/polled
>         # cat /sys/class/drm/card0/card0-DVI-D-1/polled
>         [hotplug_detectable] [connect] disconnect
>         
>         # echo > /sys/class/drm/card0/card0-DVI-D-1/polled
>         # cat /sys/class/drm/card0/card0-DVI-D-1/polled
>         hotplug_detectable connect disconnect
> 
> with the enabled poll types for the connector denoted in brackets: [].
> This allows the root user to silence DRM KMS log spam for locally known
> uncorrectable conditions.
> 
> Signed-off-by Andy Walls <awalls@md.metrocast.net>

You are adding a sysfs file, yet you forgot to add a file in
Documentation/ABI.  Please fix that and resend the patch.

thanks,

greg k-h
