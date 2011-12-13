Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753944Ab1LMGc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 01:32:28 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:54157 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672Ab1LMGcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 01:32:24 -0500
From: =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com>
To: linux-arm-kernel@lists.infradead.org
Cc: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        alsa-devel@alsa-project.org,
        Jaroslav Kysela <perex@perex.cz> (maintainer:SOUND),
        Takashi Iwai <tiwai@suse.de> (maintainer:SOUND),
        =?UTF-8?q?Eric=20B=C3=A9nard?= <eric@eukrea.com> (commit_signer:1/2=50%),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 06/19] mx27vis-aic32x4: only register when running on the right machine
Date: Tue, 13 Dec 2011 07:31:38 +0100
Message-Id: <1323757911-25217-6-git-send-email-eric@eukrea.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1323757911-25217-1-git-send-email-eric@eukrea.com>
References: <1323757911-25217-1-git-send-email-eric@eukrea.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

without this fix, a kernel compiled with imx_v4_v5_defconfig
and running on a cpuimx25sd leads to :
asoc: tlv320aic23-hifi <-> imx-ssi.0 mapping ok
------------[ cut here ]------------
WARNING: at fs/sysfs/dir.c:481 sysfs_add_one+0x90/0xb8()
sysfs: cannot create duplicate filename '/devices/platform/soc-audio'
Modules linked in:
[<c00198e8>] (unwind_backtrace+0x0/0xf0) from [<c002ea5c>] (warn_slowpath_common+0x48/0x60)
[<c002ea5c>] (warn_slowpath_common+0x48/0x60) from [<c002eb08>] (warn_slowpath_fmt+0x30/0x40)
[<c002eb08>] (warn_slowpath_fmt+0x30/0x40) from [<c0120090>] (sysfs_add_one+0x90/0xb8)
[<c0120090>] (sysfs_add_one+0x90/0xb8) from [<c0120118>] (create_dir+0x60/0xc0)
[<c0120118>] (create_dir+0x60/0xc0) from [<c0120228>] (sysfs_create_dir+0x84/0xcc)
[<c0120228>] (sysfs_create_dir+0x84/0xcc) from [<c019b9e0>] (kobject_add_internal+0xac/0x1d0)
[<c019b9e0>] (kobject_add_internal+0xac/0x1d0) from [<c019bdd8>] (kobject_add+0x50/0x98)
[<c019bdd8>] (kobject_add+0x50/0x98) from [<c01f6aec>] (device_add+0xb0/0x610)
[<c01f6aec>] (device_add+0xb0/0x610) from [<c01fac8c>] (platform_device_add+0xfc/0x238)
[<c01fac8c>] (platform_device_add+0xfc/0x238) from [<c046d884>] (mx27vis_aic32x4_init+0x38/0x84)
[<c046d884>] (mx27vis_aic32x4_init+0x38/0x84) from [<c00088a0>] (do_one_initcall+0x34/0x178)
[<c00088a0>] (do_one_initcall+0x34/0x178) from [<c045978c>] (kernel_init+0x78/0x114)
[<c045978c>] (kernel_init+0x78/0x114) from [<c0014df4>] (kernel_thread_exit+0x0/0x8)
---[ end trace b6a96897e189aea3 ]---
kobject_add_internal failed for soc-audio with -EEXIST, don't try to register things with the same name in the same directory.
[<c00198e8>] (unwind_backtrace+0x0/0xf0) from [<c019baec>] (kobject_add_internal+0x1b8/0x1d0)
[<c019baec>] (kobject_add_internal+0x1b8/0x1d0) from [<c019bdd8>] (kobject_add+0x50/0x98)
[<c019bdd8>] (kobject_add+0x50/0x98) from [<c01f6aec>] (device_add+0xb0/0x610)
[<c01f6aec>] (device_add+0xb0/0x610) from [<c01fac8c>] (platform_device_add+0xfc/0x238)
[<c01fac8c>] (platform_device_add+0xfc/0x238) from [<c046d884>] (mx27vis_aic32x4_init+0x38/0x84)
[<c046d884>] (mx27vis_aic32x4_init+0x38/0x84) from [<c00088a0>] (do_one_initcall+0x34/0x178)
[<c00088a0>] (do_one_initcall+0x34/0x178) from [<c045978c>] (kernel_init+0x78/0x114)
[<c045978c>] (kernel_init+0x78/0x114) from [<c0014df4>] (kernel_thread_exit+0x0/0x8)
ASoC: Platform device allocation failed
mxc_audmux_v1_configure_port: not configured
mxc_audmux_v1_configure_port: not configured

Signed-off-by: Eric Bénard <eric@eukrea.com>
Cc: Liam Girdwood <lrg@ti.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Javier Martin <javier.martin@vista-silicon.com>
Cc: alsa-devel@alsa-project.org
---
 sound/soc/imx/mx27vis-aic32x4.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/sound/soc/imx/mx27vis-aic32x4.c b/sound/soc/imx/mx27vis-aic32x4.c
index 054110b..224ffcc 100644
--- a/sound/soc/imx/mx27vis-aic32x4.c
+++ b/sound/soc/imx/mx27vis-aic32x4.c
@@ -96,6 +96,10 @@ static int __init mx27vis_aic32x4_init(void)
 {
 	int ret;
 
+	if (!machine_is_imx27_visstrim_m10())
+		/* return happy. We might run on a totally different machine */
+		return 0;
+
 	mx27vis_aic32x4_snd_device = platform_device_alloc("soc-audio", -1);
 	if (!mx27vis_aic32x4_snd_device)
 		return -ENOMEM;
-- 
1.7.6.4

