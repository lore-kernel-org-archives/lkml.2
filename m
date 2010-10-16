Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab0JPU7L (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 16:59:11 -0400
Received: from sj-iport-4.cisco.com ([171.68.10.86]:3781 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab0JPU7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 16:59:10 -0400
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAPOuuUyrR7H+/2dsb2JhbACacYY5caRgm26FSQSEVIV2hQI
X-IronPort-AV: E=Sophos;i="4.57,340,1283731200"; 
   d="scan'208";a="201888958"
From: Roland Dreier <rdreier@cisco.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ben Skeggs <bskeggs@redhat.com>,
        Maarten Maathuis <madman2003@gmail.com>
Subject: Re: 2.6.36-rc8 -- drivers/built-in.o: In function `nouveau_acpi_edid': (.text+0xf7c04): undefined reference to `acpi_video_get_edid'
References: <AANLkTik8pvkueU8YyUwjODz53QnurUqKycaTYJ-McYqB@mail.gmail.com>
X-Message-Flag: Warning: May contain useful information
Date: Sat, 16 Oct 2010 13:58:50 -0700
In-Reply-To: <AANLkTik8pvkueU8YyUwjODz53QnurUqKycaTYJ-McYqB@mail.gmail.com>
	(Miles Lane's message of "Thu, 14 Oct 2010 22:46:51 -0400")
Message-ID: <adad3r9hn1x.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > drivers/built-in.o: In function `nouveau_acpi_edid':
 > (.text+0xf7c04): undefined reference to `acpi_video_get_edid'
 > make: *** [.tmp_vmlinux1] Error 1

The problem is:

 > CONFIG_ACPI=y
 > CONFIG_ACPI_VIDEO=m

but

 > CONFIG_DRM_NOUVEAU=y

So the built-in nouveau code tries to reference the modular acpi video
code.  I'm not sure what the correct fix is... does the following make
things work?

 drivers/gpu/drm/nouveau/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/Makefile b/drivers/gpu/drm/nouveau/Makefile
index e9b06e4..4e295b5 100644
--- a/drivers/gpu/drm/nouveau/Makefile
+++ b/drivers/gpu/drm/nouveau/Makefile
@@ -28,6 +28,6 @@ nouveau-y := nouveau_drv.o nouveau_state.o nouveau_channel.o nouveau_mem.o \
 nouveau-$(CONFIG_DRM_NOUVEAU_DEBUG) += nouveau_debugfs.o
 nouveau-$(CONFIG_COMPAT) += nouveau_ioc32.o
 nouveau-$(CONFIG_DRM_NOUVEAU_BACKLIGHT) += nouveau_backlight.o
-nouveau-$(CONFIG_ACPI) += nouveau_acpi.o
+nouveau-$(CONFIG_ACPI_VIDEO) += nouveau_acpi.o
 
 obj-$(CONFIG_DRM_NOUVEAU)+= nouveau.o
