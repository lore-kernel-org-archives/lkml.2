Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082Ab2BNLPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 06:15:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42039 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756536Ab2BNLPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 06:15:37 -0500
From: Stefan Bader <stefan.bader@canonical.com>
To: Rodrigo Vivi <rodrigo.vivi@gmail.com>
Cc: Keith Packard <keithp@keithp.com>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Stefan Bader <stefan.bader@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [2.6.32+drm33-longterm] Patch "drm/i915: Fix TV Out refresh rate." has been added to staging queue
Date: Tue, 14 Feb 2012 12:15:32 +0100
Message-Id: <1329218132-7147-1-git-send-email-stefan.bader@canonical.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a note to let you know that I have just added a patch titled

    drm/i915: Fix TV Out refresh rate.

to the drm-next branch of the 2.6.32+drm33-longterm tree which can be found at

  http://git.kernel.org/?p=linux/kernel/git/smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next
  or
  http://kernel.ubuntu.com/git?p=smb/linux-2.6.32.y-drm33.z.git;a=shortlog;h=refs/heads/drm-next

If you, or anyone else, feels it should not be added to the drm33-longterm tree,
please reply to this email not later than 8 days after this email was sent.

Thanks.
-Stefan

------

>From 23145ac5c650072d73beab2fee839d6129a22e72 Mon Sep 17 00:00:00 2001
From: Rodrigo Vivi <rodrigo.vivi@gmail.com>
Date: Wed, 14 Dec 2011 21:10:06 -0200
Subject: [PATCH] drm/i915: Fix TV Out refresh rate.

commit 23bd15ec662344dc10e9918fdd0dbc58bc71526d upstream.

TV Out refresh rate was half of the specification for almost all modes.
Due to this reason pixel clock was so low for some modes causing flickering screen.

Signed-off-by: Rodrigo Vivi <rodrigo.vivi@gmail.com>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
---
 drivers/gpu/drm/i915/intel_tv.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
index 5b28b4e..d156b25 100644
--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -415,7 +415,7 @@ static const struct tv_mode tv_modes[] = {
 	{
 		.name		= "NTSC-M",
 		.clock		= 108000,
-		.refresh	= 29970,
+		.refresh	= 59940,
 		.oversample	= TV_OVERSAMPLE_8X,
 		.component_only = 0,
 		/* 525 Lines, 60 Fields, 15.734KHz line, Sub-Carrier 3.580MHz */
@@ -458,7 +458,7 @@ static const struct tv_mode tv_modes[] = {
 	{
 		.name		= "NTSC-443",
 		.clock		= 108000,
-		.refresh	= 29970,
+		.refresh	= 59940,
 		.oversample	= TV_OVERSAMPLE_8X,
 		.component_only = 0,
 		/* 525 Lines, 60 Fields, 15.734KHz line, Sub-Carrier 4.43MHz */
@@ -500,7 +500,7 @@ static const struct tv_mode tv_modes[] = {
 	{
 		.name		= "NTSC-J",
 		.clock		= 108000,
-		.refresh	= 29970,
+		.refresh	= 59940,
 		.oversample	= TV_OVERSAMPLE_8X,
 		.component_only = 0,

@@ -543,7 +543,7 @@ static const struct tv_mode tv_modes[] = {
 	{
 		.name		= "PAL-M",
 		.clock		= 108000,
-		.refresh	= 29970,
+		.refresh	= 59940,
 		.oversample	= TV_OVERSAMPLE_8X,
 		.component_only = 0,

@@ -587,7 +587,7 @@ static const struct tv_mode tv_modes[] = {
 		/* 625 Lines, 50 Fields, 15.625KHz line, Sub-Carrier 4.434MHz */
 		.name	    = "PAL-N",
 		.clock		= 108000,
-		.refresh	= 25000,
+		.refresh	= 50000,
 		.oversample	= TV_OVERSAMPLE_8X,
 		.component_only = 0,

@@ -632,7 +632,7 @@ static const struct tv_mode tv_modes[] = {
 		/* 625 Lines, 50 Fields, 15.625KHz line, Sub-Carrier 4.434MHz */
 		.name	    = "PAL",
 		.clock		= 108000,
-		.refresh	= 25000,
+		.refresh	= 50000,
 		.oversample	= TV_OVERSAMPLE_8X,
 		.component_only = 0,

@@ -819,7 +819,7 @@ static const struct tv_mode tv_modes[] = {
 	{
 		.name       = "1080i@50Hz",
 		.clock		= 148800,
-		.refresh	= 25000,
+		.refresh	= 50000,
 		.oversample     = TV_OVERSAMPLE_2X,
 		.component_only = 1,

@@ -845,7 +845,7 @@ static const struct tv_mode tv_modes[] = {
 	{
 		.name       = "1080i@60Hz",
 		.clock		= 148800,
-		.refresh	= 30000,
+		.refresh	= 60000,
 		.oversample     = TV_OVERSAMPLE_2X,
 		.component_only = 1,

--
1.7.5.4

