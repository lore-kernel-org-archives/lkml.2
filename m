Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab0G2HUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 03:20:19 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59259 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab0G2HUQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 03:20:16 -0400
From: "Savoy, Pavan" <pavan_savoy@ti.com>
To: "gregkh@suse.de" <gregkh@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 29 Jul 2010 12:49:59 +0530
Subject: RE: patch "Staging: ti-st: update ABI and TODO" added to
 staging-next tree
Thread-Topic: patch "Staging: ti-st: update ABI and TODO" added to
 staging-next tree
Thread-Index: AcsuaOmCkQN0g/lYTFSdExT0J6tl1gAhQQkA
Message-ID: <19F8576C6E063C45BE387C64729E7394044EE51EF4@dbde02.ent.ti.com>
References: <12803306292159@site>
In-Reply-To: <12803306292159@site>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,

 
> -----Original Message-----
> From: gregkh@suse.de [mailto:gregkh@suse.de]
> Sent: Wednesday, July 28, 2010 10:24 AM
> To: Savoy, Pavan; gregkh@suse.de
> Subject: patch "Staging: ti-st: update ABI and TODO" added to staging-next tree

Is it good enough to be moved out of staging?
I mean the multi-device thingy would be more or less a nice to have feature than being a bug, isn't it?

The ease for me would be once out of staging, I can cleanup the platform device mess too, since our L-O tree needs to be have some patches in the arch/arm/board-XX.c sort of files...

> 
> This is a note to let you know that I've just added the patch titled
> 
>     Staging: ti-st: update ABI and TODO
> 
> to my staging-next git tree which can be found at
>     git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-next-2.6.git
> in the staging-next branch.
> 
> The patch will show up in the next release of the linux-next tree
> (usually sometime within the next 24 hours during the week.)
> 
> The patch will also will be merged in the next major kernel release
> during the merge window.
> 
> If you have any questions about this process, please let me know.
> 
> 
> From 9f912212cd005f9a0a514ae982de915ff94bd765 Mon Sep 17 00:00:00 2001
> From: Pavan Savoy <pavan_savoy@ti.com>
> Date: Wed, 28 Jul 2010 02:26:00 -0500
> Subject: Staging: ti-st: update ABI and TODO
> 
> update TODO to reflect the items taken care of,
> update ABI to reflect the new debugfs entries exposed.
> 
> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> ---
>  drivers/staging/ti-st/TODO      |   10 +++-------
>  drivers/staging/ti-st/sysfs-uim |   12 ++++++++++++
>  2 files changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/staging/ti-st/TODO b/drivers/staging/ti-st/TODO
> index 3f68ea1..6a105ed 100644
> --- a/drivers/staging/ti-st/TODO
> +++ b/drivers/staging/ti-st/TODO
> @@ -11,16 +11,12 @@ a st_register() would know whether the registration from BT/FM or GPS was intend
>  2. Improve upon the way requirement of line discipline is communicated to
>  user-space, The current user-space application which open/installs ldisc
>  as and when required can be found at,
> -
> http://git.omapzoom.org/?pÿatform/hardware/ti/omap3.git;aÿob;fÿ_st/uim/uim.c;ha16c2c2b5085eb54a1bbc7096d779
> d7594eb11;hbìlair
> +http://dev.omapzoom.org/pub/scm/jsistla/L23-btfm.git
> +branch: UIM
> 
>  3. Re-view/Re-work on the locking.
> 
> -4. Re-structure to make the ldisc driver more generic for chipsets which mux
> -multiple connectivity (BT, FM, GPS) upon 1 TTY port.
> -
> -5. Remove global references by providing a context which can be moved around the driver like the other
> ldisc drivers. (ldiscs tend to use tty's disc_data and platform devices use the device's driver data)
> -
> -6. Step up and maintain this driver to ensure that it continues
> +4. Step up and maintain this driver to ensure that it continues
>  to work.  Having the hardware for this is pretty much a
>  requirement.  If this does not happen, the will be removed in
>  the 2.6.35 kernel release.
> diff --git a/drivers/staging/ti-st/sysfs-uim b/drivers/staging/ti-st/sysfs-uim
> index 10311af..626bda5 100644
> --- a/drivers/staging/ti-st/sysfs-uim
> +++ b/drivers/staging/ti-st/sysfs-uim
> @@ -14,3 +14,15 @@ Description:
>  		uninstallation would be ppolling on this device and listening
>  		on events which would suggest either to install or un-install
>  		line discipline
> +
> +What:           /sys/kernel/debug/ti-st/version
> +Contact:        Pavan Savoy <pavan_savoy@ti.com>
> +Description:
> +		WiLink chip's ROM version exposed to user-space for some
> +		proprietary protocol stacks to make use of.
> +
> +What:           /sys/kernel/debug/ti-st/protocols
> +Contact:        Pavan Savoy <pavan_savoy@ti.com>
> +Description:
> +		The reason for chip being ON, the list of protocols registered.
> +
> --
> 1.7.1
> 

