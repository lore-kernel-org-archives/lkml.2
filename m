Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194Ab1LMGcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 01:32:48 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:54674 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752710Ab1LMGco (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 01:32:44 -0500
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org,
        Jaroslav Kysela <perex@perex.cz> (maintainer:SOUND),
        Takashi Iwai <tiwai@suse.de> (maintainer:SOUND),
        Paul Gortmaker <paul.gortmaker@windriver.com> (commit_signer:1/2=50%),
        =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com> (commit_signer:1/2=50%),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 10/19] wm1133-ev1: only register when running on the right machine
Date: Tue, 13 Dec 2011 07:31:42 +0100
Message-Id: <1323757911-25217-10-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1323757911-25217-1-git-send-email-eric@eukrea.com>
References: <1323757911-25217-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

without this fix, a kernel compiled with mx3_defconfig
and running on a cpuimx35sd leads to :

asoc: tlv320aic23-hifi <-> imx-ssi.0 mapping ok
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:481 sysfs_add_one+0x88/0xb0()
sysfs: cannot create duplicate filename '/devices/platform/soc-audio'
Modules linked in:
[<c0014384>] (unwind_backtrace+0x0/0xf0) from [<c0026260>] (warn_slowpath_common+0x4c/0x64)
[<c0026260>] (warn_slowpath_common+0x4c/0x64) from [<c002630c>] (warn_slowpath_fmt+0x30/0x40)
[<c002630c>] (warn_slowpath_fmt+0x30/0x40) from [<c00ebc80>] (sysfs_add_one+0x88/0xb0)
[<c00ebc80>] (sysfs_add_one+0x88/0xb0) from [<c00ebd08>] (create_dir+0x60/0xb8)
[<c00ebd08>] (create_dir+0x60/0xb8) from [<c00ebe0c>] (sysfs_create_dir+0x80/0xc8)
[<c00ebe0c>] (sysfs_create_dir+0x80/0xc8) from [<c0180d44>] (kobject_add_internal+0xac/0x1d0)
[<c0180d44>] (kobject_add_internal+0xac/0x1d0) from [<c018113c>] (kobject_add+0x50/0x98)
[<c018113c>] (kobject_add+0x50/0x98) from [<c01c4800>] (device_add+0xb0/0x5fc)
[<c01c4800>] (device_add+0xb0/0x5fc) from [<c01c8860>] (platform_device_add+0xfc/0x238)
[<c01c8860>] (platform_device_add+0xfc/0x238) from [<c0464d60>] (wm1133_ev1_audio_init+0x58/0x80)
[<c0464d60>] (wm1133_ev1_audio_init+0x58/0x80) from [<c0008670>] (do_one_initcall+0x34/0x17c)
[<c0008670>] (do_one_initcall+0x34/0x17c) from [<c045177c>] (kernel_init+0x78/0x11c)
[<c045177c>] (kernel_init+0x78/0x11c) from [<c000f514>] (kernel_thread_exit+0x0/0x8)
---[ end trace 4453d8d40de9f5ff ]---
kobject_add_internal failed for soc-audio with -EEXIST, don't try to register things with the same name in the same directory.
[<c0014384>] (unwind_backtrace+0x0/0xf0) from [<c0180e50>] (kobject_add_internal+0x1b8/0x1d0)
[<c0180e50>] (kobject_add_internal+0x1b8/0x1d0) from [<c018113c>] (kobject_add+0x50/0x98)
[<c018113c>] (kobject_add+0x50/0x98) from [<c01c4800>] (device_add+0xb0/0x5fc)
[<c01c4800>] (device_add+0xb0/0x5fc) from [<c01c8860>] (platform_device_add+0xfc/0x238)
[<c01c8860>] (platform_device_add+0xfc/0x238) from [<c0464d60>] (wm1133_ev1_audio_init+0x58/0x80)
[<c0464d60>] (wm1133_ev1_audio_init+0x58/0x80) from [<c0008670>] (do_one_initcall+0x34/0x17c)
[<c0008670>] (do_one_initcall+0x34/0x17c) from [<c045177c>] (kernel_init+0x78/0x11c)
[<c045177c>] (kernel_init+0x78/0x11c) from [<c000f514>] (kernel_thread_exit+0x0/0x8)

Signed-off-by: Eric Bénard <eric@eukrea.com>
Cc: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: alsa-devel@alsa-project.org
---
 sound/soc/imx/wm1133-ev1.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/sound/soc/imx/wm1133-ev1.c b/sound/soc/imx/wm1133-ev1.c
index 490a126..147ae69 100644
--- a/sound/soc/imx/wm1133-ev1.c
+++ b/sound/soc/imx/wm1133-ev1.c
@@ -20,6 +20,7 @@
 #include <sound/pcm.h>
 #include <sound/pcm_params.h>
 #include <sound/soc.h>
+#include <asm/mach-types.h>
 
 #include <mach/audmux.h>
 
@@ -266,6 +267,10 @@ static int __init wm1133_ev1_audio_init(void)
 	int ret;
 	unsigned int ptcr, pdcr;
 
+	if (!machine_is_mx31ads())
+		/* return happy. We might run on a totally different machine */
+		return 0;
+
 	/* SSI0 mastered by port 5 */
 	ptcr = MXC_AUDMUX_V2_PTCR_SYN |
 		MXC_AUDMUX_V2_PTCR_TFSDIR |
-- 
1.7.6.4

