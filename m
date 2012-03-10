Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab2CJVFd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 16:05:33 -0500
Received: from toro.web-alm.net ([62.245.132.31]:54317 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab2CJVFc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 16:05:32 -0500
X-Greylist: delayed 858 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Mar 2012 16:05:31 EST
Message-Id: <20120310202014.828058552@osadl.org>
User-Agent: quilt/0.48-1
Date: Sat, 10 Mar 2012 21:20:14 +0100
From: Carsten Emde <C.Emde@osadl.org>
To: David Airlie <airlied@linux.ie>
Cc: Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] Provide workarounds to use DRM/KMS with broken graphics hardware
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the good old days when graphics parameters were configured explicitly
in a file called xorg.conf, even broken hardware could be managed.

Today, with the advent of Kernel Mode Setting, a graphics board is
either correctly working because all components follow the standards -
or the computer is unusable, because the screen remains dark after
booting or displays the wrong area. Cases when this happens are:
- The BIOS assumes that an LVDS is always connected, even if it isn't.
- The graphics board does not recognize the monitor.
- The graphics board is unable to detect any EDID data.
- The graphics board incorrectly forwards EDID data to the driver.
- The monitor sends bogus EDID data.
- A KVM sends its own EDID data instead of querying the connected monitor.
- The brightness setting of the panel backlight does not work.
- Any combination of the above.
Adding the kernel parameter "nomodeset" helps in most cases, but causes
restrictions later on.

The three patches of this series add module parameters to the
drm_kms_helper module that
1. allow to load an EDID data set via the firmware interface,
2. provide a module parameter to selectively enable or disable a
graphics port,
3. provide a module parameter to select inverted brightness.

EDID data sets along with source files are provided for commonly used
screen resolutions (1024x768, 1280x1024, 1680x1050, 1920x1080).

Please note that these patches neither fix a kernel bug nor provide any
extra functionality. They simply work around broken hardware that
otherwise would be either unusable or usable in a very restricted way.
The patches do not modify the current functionality of the related
components in any way, unless the kernel is configured accordingly
and/or the newly provided module parameters are set.

	-Carsten. 

