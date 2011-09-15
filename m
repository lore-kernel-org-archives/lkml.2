Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934821Ab1IOUNc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 16:13:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:48932 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934742Ab1IOUKG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 16:10:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="48873442"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: Andi Kleen <ak@linux.intel.com>, mchehab@infradead.org
Subject: [PATCH 15/27] Initconst section fixes for media
Date: Thu, 15 Sep 2011 13:09:42 -0700
Message-Id: <1316117394-21666-16-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
References: <1316117394-21666-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Cc: mchehab@infradead.org
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/media/dvb/ngene/ngene-cards.c |    2 +-
 drivers/media/video/cx88/cx88-alsa.c  |    2 +-
 drivers/media/video/timblogiw.c       |    6 +++---
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/dvb/ngene/ngene-cards.c b/drivers/media/dvb/ngene/ngene-cards.c
index 0564192..75b16f5 100644
--- a/drivers/media/dvb/ngene/ngene-cards.c
+++ b/drivers/media/dvb/ngene/ngene-cards.c
@@ -477,7 +477,7 @@ static struct ngene_info ngene_info_m780 = {
 
 /****************************************************************************/
 
-static const struct pci_device_id ngene_id_tbl[] __devinitdata = {
+static const struct pci_device_id ngene_id_tbl[] __devinitconst = {
 	NGENE_ID(0x18c3, 0xabc3, ngene_info_cineS2),
 	NGENE_ID(0x18c3, 0xabc4, ngene_info_cineS2),
 	NGENE_ID(0x18c3, 0xdb01, ngene_info_satixS2),
diff --git a/drivers/media/video/cx88/cx88-alsa.c b/drivers/media/video/cx88/cx88-alsa.c
index 68d1240..46b32eb 100644
--- a/drivers/media/video/cx88/cx88-alsa.c
+++ b/drivers/media/video/cx88/cx88-alsa.c
@@ -766,7 +766,7 @@ static struct snd_kcontrol_new snd_cx88_alc_switch = {
  * Only boards with eeprom and byte 1 at eeprom=1 have it
  */
 
-static const struct pci_device_id const cx88_audio_pci_tbl[] __devinitdata = {
+static const struct pci_device_id const cx88_audio_pci_tbl[] __devinitconst = {
 	{0x14f1,0x8801,PCI_ANY_ID,PCI_ANY_ID,0,0,0},
 	{0x14f1,0x8811,PCI_ANY_ID,PCI_ANY_ID,0,0,0},
 	{0, }
diff --git a/drivers/media/video/timblogiw.c b/drivers/media/video/timblogiw.c
index 84cd1b6..586706b 100644
--- a/drivers/media/video/timblogiw.c
+++ b/drivers/media/video/timblogiw.c
@@ -744,7 +744,7 @@ static int timblogiw_mmap(struct file *file, struct vm_area_struct *vma)
 
 /* Platform device functions */
 
-static __devinitconst struct v4l2_ioctl_ops timblogiw_ioctl_ops = {
+static const __devinitconst struct v4l2_ioctl_ops timblogiw_ioctl_ops = {
 	.vidioc_querycap		= timblogiw_querycap,
 	.vidioc_enum_fmt_vid_cap	= timblogiw_enum_fmt,
 	.vidioc_g_fmt_vid_cap		= timblogiw_g_fmt,
@@ -766,7 +766,7 @@ static __devinitconst struct v4l2_ioctl_ops timblogiw_ioctl_ops = {
 	.vidioc_enum_framesizes		= timblogiw_enum_framesizes,
 };
 
-static __devinitconst struct v4l2_file_operations timblogiw_fops = {
+static const __devinitconst struct v4l2_file_operations timblogiw_fops = {
 	.owner		= THIS_MODULE,
 	.open		= timblogiw_open,
 	.release	= timblogiw_close,
@@ -776,7 +776,7 @@ static __devinitconst struct v4l2_file_operations timblogiw_fops = {
 	.poll		= timblogiw_poll,
 };
 
-static __devinitconst struct video_device timblogiw_template = {
+static const __devinitconst struct video_device timblogiw_template = {
 	.name		= TIMBLOGIWIN_NAME,
 	.fops		= &timblogiw_fops,
 	.ioctl_ops	= &timblogiw_ioctl_ops,
-- 
1.7.4.4

