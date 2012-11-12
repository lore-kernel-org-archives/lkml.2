Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab2KLV4P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 16:56:15 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:65469 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab2KLV4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 16:56:10 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Dave Airlie <airlied@redhat.com>
Cc: Rob Clark <robdclark@gmail.com>, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] NVIDIA Tegra DRM driver
Date: Mon, 12 Nov 2012 22:55:56 +0100
Message-Id: <1352757358-14001-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.0
X-Provags-ID: V02:K0:BzJTGsEIctAjgFDqPacV559Be8WtJxQEPNKV1ISQLlK
 B4riJ8gmth/Tw8qAqaPw2YqqVW6rI4FMpgKWuXoGy7lnbYfTCV
 S6wXrHSX4ntS4BwtfbDIoikVmGfjJ/6PsetpxAwB9RJmQFIM1n
 weunvDugfGN9eRIVq5dsOj5j2uWNPzTAMtss7xHK8KrZDTYDST
 gZ/EDa4UmL2P0EEe74vwWHEUQCfWyz95iGhFbQW/ejiZ91CKNr
 Wt7TZ7RzvTXHz9zCy7WI4ro6wGLrnMEc6XdMXo+S6/bFO2I5MX
 GGQqmjsz2Pq583okQvQJueQ5y48NEwWDnbWdhOr9TPE9UNe9ke
 2wKE8mfgxoFE8ULRKdF4iOCo8eX/FhGDHTz1tFrK9zlczuDHaq
 HsAq07LtDNTQJTWzJlGbo7v/+Y2zaz/ZZs4HnK7Y4SMteRGWU2
 97lEw
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This second version of this patch series addresses all the comments
received so far. Most notably it takes advantage of the debugfs helpers
provided by the DRM core. Oddly enough this actually increases the line
count, but that's because the helpers don't fit with the subdevices
approach as implemented by this driver. However some quick discussions
with Rob Clark showed that Tegra DRM is not special in this respect but
other drivers may need the same functionality. Eventually the debugfs
code could be reworked on top of helpers that are better suited at the
design of embedded, multi-device DRM drivers.

Other than that there is some removal of code that was actually supposed
to go into a later patch because it has dependencies that haven't been
merged yet and some moving around of #defines and the device tree
bindings documentation. Finally the driver now uses the DRM core's
drm_compat_ioctl() instead of a custom and unimplemented (!) version.

Thierry

Thierry Reding (2):
  drm: Add NVIDIA Tegra20 support
  drm: tegra: Add HDMI support

 .../bindings/gpu/nvidia,tegra20-host1x.txt         |  191 +++
 drivers/gpu/drm/Kconfig                            |    2 +
 drivers/gpu/drm/Makefile                           |    1 +
 drivers/gpu/drm/tegra/Kconfig                      |   23 +
 drivers/gpu/drm/tegra/Makefile                     |    7 +
 drivers/gpu/drm/tegra/dc.c                         |  846 +++++++++++++
 drivers/gpu/drm/tegra/dc.h                         |  388 ++++++
 drivers/gpu/drm/tegra/drm.c                        |  115 ++
 drivers/gpu/drm/tegra/drm.h                        |  233 ++++
 drivers/gpu/drm/tegra/fb.c                         |   56 +
 drivers/gpu/drm/tegra/hdmi.c                       | 1324 ++++++++++++++++++++
 drivers/gpu/drm/tegra/hdmi.h                       |  575 +++++++++
 drivers/gpu/drm/tegra/host1x.c                     |  321 +++++
 drivers/gpu/drm/tegra/output.c                     |  262 ++++
 drivers/gpu/drm/tegra/rgb.c                        |  200 +++
 15 files changed, 4544 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/gpu/nvidia,tegra20-host1x.txt
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

