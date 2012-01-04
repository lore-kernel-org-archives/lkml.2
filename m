Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab2ADMlc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 07:41:32 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47296 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550Ab2ADMl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 07:41:28 -0500
From: Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        dan.carpenter@oracle.com, rmallon@gmail.com, joe@perches.com,
        valdis.kletnieks@vt.edu,
        Ravishankar karkala Mallikarjunayya 
	<ravishankar.km@greenturtles.in>
Subject: [PATCH 10/11] Staging: comedi: fix line over 80 character issue in jr3_pci.c
Date: Wed,  4 Jan 2012 18:10:05 +0530
Message-Id: <1325680806-10917-10-git-send-email-ravishankar.km@greenturtles.in>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1325680806-10917-1-git-send-email-ravishankar.km@greenturtles.in>
References: <1325680806-10917-1-git-send-email-ravishankar.km@greenturtles.in>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the jr3_pci.c file that fixes up a line
over 80 character warning found by the checkpatch.pl tool.

Signed-off-by: Ravishankar Karkala Mallikarjunayya <ravishankar.km@greenturtles.in>
---
 drivers/staging/comedi/drivers/jr3_pci.c |   18 ++++++++++++++----
 1 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/comedi/drivers/jr3_pci.c b/drivers/staging/comedi/drivers/jr3_pci.c
index 6a79ba1..98f617c 100644
--- a/drivers/staging/comedi/drivers/jr3_pci.c
+++ b/drivers/staging/comedi/drivers/jr3_pci.c
@@ -461,7 +461,10 @@ static int jr3_download_firmware(struct comedi_device *dev, const u8 * data,
 					i, count, addr);
 				while (more && count > 0) {
 					if (addr & 0x4000) {
-						/*  16 bit data, never seen in real life!! */
+						/*
+						 * 16 bit data, never seen
+						 * in real life!!
+						 */
 						unsigned int data1;
 
 						more = more
@@ -547,7 +550,10 @@ static struct poll_delay_t jr3_pci_poll_subdevice(struct comedi_subdevice *s)
 		case state_jr3_init_wait_for_offset:{
 				p->retries++;
 				if (p->retries < 10) {
-					/*  Wait for offeset to stabilize (< 10 s according to manual) */
+					/*
+					 * Wait for offeset to stabilize
+					 * (< 10 s according to manual)
+					 */
 					result = poll_delay_min_max(1000, 2000);
 				} else {
 					struct transform_t transf;
@@ -576,7 +582,8 @@ static struct poll_delay_t jr3_pci_poll_subdevice(struct comedi_subdevice *s)
 					use_transform(channel, 0);
 					p->state =
 					    state_jr3_init_transform_complete;
-					result = poll_delay_min_max(20, 100);	/*  Allow 20 ms for completion */
+					/* Allow 20 ms for completion */
+					result = poll_delay_min_max(20, 100);
 				}
 			} break;
 		case state_jr3_init_transform_complete:{
@@ -630,7 +637,10 @@ static struct poll_delay_t jr3_pci_poll_subdevice(struct comedi_subdevice *s)
 				} else {
 					volatile struct force_array *full_scale;
 
-					/*  Use ranges in kN or we will overflow arount 2000N! */
+					/*
+					 * Use ranges in kN or we will
+					 * overflow around 2000N!
+					 */
 					full_scale = &channel->full_scale;
 					p->range[0].range.min =
 					    -get_s16(&full_scale->fx) * 1000;
-- 
1.7.0.4

