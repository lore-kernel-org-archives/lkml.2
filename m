Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab2KIN7y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 08:59:54 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50957 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab2KIN7v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 08:59:51 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Dave Airlie <airlied@redhat.com>
Cc: dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] NVIDIA Tegra DRM driver
Date: Fri,  9 Nov 2012 14:59:37 +0100
Message-Id: <1352469579-3337-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
X-Provags-ID: V02:K0:xwt3qEylxxfeckooxwQ52UcN/rw/pIq/TLBVMLJ+hpe
 RgVp7EuzRYn+Egvms7sgbWlV8jxzJS6wjc9xcBtgvrL3r7TzDg
 kuqEVDli0MheG3Uwb/MccLvbv7YtibTvp9PG3DzK983czyEim3
 OzDvnGUvco0x1NRWYtpaDuaVPNrWi319Hmegt3kvRBot6JsnY2
 5TbQItcCEJommvRBhYARS40YEjmKqHymgWeMk4i+nPEbPQmjA4
 gHwr69iRh6VmuqT8HMTzSOfRzULaT5CVsD71zz0P8+X0kIozPW
 PschJD1ALwQ3/N3fEjvPIKcv1hwZeaB9mMWoub+JuAgf1yK7l2
 wfyuNZU+HJvtRYhwqfA8L0CN2zfOyq+bTIBl166UZ6ZgJG0HPi
 oiIUcYxPeTI1p0Po/hLDoxo4VCBUvEUynykkt+rdcOPMGkozUQ
 jyN68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This small set of patches adds support for the host1x and a subset of
the display controller hardware available on NVIDIA Tegra SoCs.

The first patch makes the RGB output available, which is directly driven
by its parent display controller and usually connected to an LVDS bridge
in embedded and notebook applications.

The second patch adds support for the HDMI output which can be driven by
any of the two display controllers.

This set of patches uses the GEM/CMA and KMS/FB helpers by Sascha Hauer
and Lars-Peter Clausen respectively.

Note that the driver is fully functional, but a few things are still
missing from this series because they depend on other patches that have
not been included in mainline yet. One such series is Steffen Trumtrar's
display helper series that allows the display modes to be defined within
the device tree, which comes in handy for embedded applications. What's
also missing from this series is the glue to wire up a backlight device
with a DRM connector so that the backlight can be switched on and off at
the proper time. I will submit incremental patches as the dependencies
make it into Linus' tree.

There is a full set of patches available in the tegra/next branch of my
repository on gitorious[0]. I know that a few people have already tested
the code on that branch, which has been very helpful in ironing out some
of the final details.

I fully realize that this is awfully late, but I still hope to get this
in for 3.8. I've talked about this with David Airlie and he said if I
can get the patches reviewed sometime before 3.7-rc6 or 3.7-rc7 by some
people of the embedded DRM crowd he may take them into the 3.8 merge
window. That would leave about 2 weeks for review, so if anybody could
find the time to look at this code that'd be great.

During the development of this series I've received a lot of feedback
and many helpful suggestions from the people at NVIDIA, so I owe them
big thanks.

Thierry

[0]: git://gitorious.org/thierryreding/linux.git

Thierry Reding (2):
  drm: Add NVIDIA Tegra20 support
  drm: tegra: Add HDMI support

 .../bindings/gpu/drm/nvidia,tegra20-host1x.txt     |  191 +++
 drivers/gpu/drm/Kconfig                            |    2 +
 drivers/gpu/drm/Makefile                           |    1 +
 drivers/gpu/drm/tegra/Kconfig                      |   23 +
 drivers/gpu/drm/tegra/Makefile                     |    7 +
 drivers/gpu/drm/tegra/dc.c                         |  817 +++++++++++++
 drivers/gpu/drm/tegra/dc.h                         |  384 ++++++
 drivers/gpu/drm/tegra/drm.c                        |  115 ++
 drivers/gpu/drm/tegra/drm.h                        |  235 ++++
 drivers/gpu/drm/tegra/fb.c                         |   56 +
 drivers/gpu/drm/tegra/hdmi.c                       | 1290 ++++++++++++++++++++
 drivers/gpu/drm/tegra/hdmi.h                       |  575 +++++++++
 drivers/gpu/drm/tegra/host1x.c                     |  321 +++++
 drivers/gpu/drm/tegra/output.c                     |  275 +++++
 drivers/gpu/drm/tegra/rgb.c                        |  200 +++
 15 files changed, 4492 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpu/drm/nvidia,tegra20-host1x.txt
 create mode 100644 drivers/gpu/drm/tegra/Kconfig
 create mode 100644 drivers/gpu/drm/tegra/Makefile
 create mode 100644 drivers/gpu/drm/tegra/dc.c
 create mode 100644 drivers/gpu/drm/tegra/dc.h
 create mode 100644 drivers/gpu/drm/tegra/drm.c
 create mode 100644 drivers/gpu/drm/tegra/drm.h
 create mode 100644 drivers/gpu/drm/tegra/fb.c
 create mode 100644 drivers/gpu/drm/tegra/hdmi.c
 create mode 100644 drivers/gpu/drm/tegra/hdmi.h
 create mode 100644 drivers/gpu/drm/tegra/host1x.c
 create mode 100644 drivers/gpu/drm/tegra/output.c
 create mode 100644 drivers/gpu/drm/tegra/rgb.c

-- 
1.8.0

