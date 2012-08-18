Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab2HRRd1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 13:33:27 -0400
Received: from mga03.intel.com ([143.182.124.21]:22621 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755617Ab2HRRai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 13:30:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,791,1336374000"; 
   d="scan'208";a="182607893"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 17/31] sections: Fix section conflicts in drivers/media
Date: Sat, 18 Aug 2012 10:30:08 -0700
Message-Id: <1345311022-26328-18-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
References: <1345311022-26328-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/media/dvb/ddbridge/ddbridge-core.c |    2 +-
 drivers/media/dvb/ngene/ngene-cards.c      |    2 +-
 drivers/media/video/cx88/cx88-alsa.c       |    2 +-
 drivers/media/video/gspca/jl2005bcd.c      |    2 +-
 drivers/media/video/timblogiw.c            |    6 +++---
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/media/dvb/ddbridge/ddbridge-core.c b/drivers/media/dvb/ddbridge/ddbridge-core.c
index ebf3f05..b1f3e77 100644
--- a/drivers/media/dvb/ddbridge/ddbridge-core.c
+++ b/drivers/media/dvb/ddbridge/ddbridge-core.c
@@ -1679,7 +1679,7 @@ static struct ddb_info ddb_v6 = {
 	.subvendor   = _subvend, .subdevice = _subdev, \
 	.driver_data = (unsigned long)&_driverdata }
 
-static const struct pci_device_id ddb_id_tbl[] __devinitdata = {
+static const struct pci_device_id ddb_id_tbl[] __devinitconst = {
 	DDB_ID(DDVID, 0x0002, DDVID, 0x0001, ddb_octopus),
 	DDB_ID(DDVID, 0x0003, DDVID, 0x0001, ddb_octopus),
 	DDB_ID(DDVID, 0x0003, DDVID, 0x0002, ddb_octopus_le),
diff --git a/drivers/media/dvb/ngene/ngene-cards.c b/drivers/media/dvb/ngene/ngene-cards.c
index 72ee8de..eae0c80 100644
--- a/drivers/media/dvb/ngene/ngene-cards.c
+++ b/drivers/media/dvb/ngene/ngene-cards.c
@@ -479,7 +479,7 @@ static struct ngene_info ngene_info_m780 = {
 
 /****************************************************************************/
 
-static const struct pci_device_id ngene_id_tbl[] __devinitdata = {
+static const struct pci_device_id ngene_id_tbl[] __devinitconst = {
 	NGENE_ID(0x18c3, 0xabc3, ngene_info_cineS2),
 	NGENE_ID(0x18c3, 0xabc4, ngene_info_cineS2),
 	NGENE_ID(0x18c3, 0xdb01, ngene_info_satixS2),
diff --git a/drivers/media/video/cx88/cx88-alsa.c b/drivers/media/video/cx88/cx88-alsa.c
index dfac6e3..c26de31 100644
--- a/drivers/media/video/cx88/cx88-alsa.c
+++ b/drivers/media/video/cx88/cx88-alsa.c
@@ -749,7 +749,7 @@ static struct snd_kcontrol_new snd_cx88_alc_switch = {
  * Only boards with eeprom and byte 1 at eeprom=1 have it
  */
 
-static const struct pci_device_id const cx88_audio_pci_tbl[] __devinitdata = {
+static const struct pci_device_id const cx88_audio_pci_tbl[] __devinitconst = {
 	{0x14f1,0x8801,PCI_ANY_ID,PCI_ANY_ID,0,0,0},
 	{0x14f1,0x8811,PCI_ANY_ID,PCI_ANY_ID,0,0,0},
 	{0, }
diff --git a/drivers/media/video/gspca/jl2005bcd.c b/drivers/media/video/gspca/jl2005bcd.c
index cf9d9fc..6ebe9ec 100644
--- a/drivers/media/video/gspca/jl2005bcd.c
+++ b/drivers/media/video/gspca/jl2005bcd.c
@@ -512,7 +512,7 @@ static const struct sd_desc sd_desc = {
 };
 
 /* -- module initialisation -- */
-static const __devinitdata struct usb_device_id device_table[] = {
+static const __devinitconst struct usb_device_id device_table[] = {
 	{USB_DEVICE(0x0979, 0x0227)},
 	{}
 };
diff --git a/drivers/media/video/timblogiw.c b/drivers/media/video/timblogiw.c
index 02194c0..5f6a2cb 100644
--- a/drivers/media/video/timblogiw.c
+++ b/drivers/media/video/timblogiw.c
@@ -745,7 +745,7 @@ static int timblogiw_mmap(struct file *file, struct vm_area_struct *vma)
 
 /* Platform device functions */
 
-static __devinitconst struct v4l2_ioctl_ops timblogiw_ioctl_ops = {
+static const __devinitconst struct v4l2_ioctl_ops timblogiw_ioctl_ops = {
 	.vidioc_querycap		= timblogiw_querycap,
 	.vidioc_enum_fmt_vid_cap	= timblogiw_enum_fmt,
 	.vidioc_g_fmt_vid_cap		= timblogiw_g_fmt,
@@ -767,7 +767,7 @@ static __devinitconst struct v4l2_ioctl_ops timblogiw_ioctl_ops = {
 	.vidioc_enum_framesizes		= timblogiw_enum_framesizes,
 };
 
-static __devinitconst struct v4l2_file_operations timblogiw_fops = {
+static const __devinitconst struct v4l2_file_operations timblogiw_fops = {
 	.owner		= THIS_MODULE,
 	.open		= timblogiw_open,
 	.release	= timblogiw_close,
@@ -777,7 +777,7 @@ static __devinitconst struct v4l2_file_operations timblogiw_fops = {
 	.poll		= timblogiw_poll,
 };
 
-static __devinitconst struct video_device timblogiw_template = {
+static const __devinitconst struct video_device timblogiw_template = {
 	.name		= TIMBLOGIWIN_NAME,
 	.fops		= &timblogiw_fops,
 	.ioctl_ops	= &timblogiw_ioctl_ops,
-- 
1.7.7.6

