Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933321Ab2BJWuk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:50:40 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:55384 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933278Ab2BJWub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:50:31 -0500
MIME-Version: 1.0
Message-Id: <20120210224851.711452933@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:47:49 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Rodrigo Vivi <rodrigo.vivi@gmail.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Keith Packard <keithp@keithp.com>,
        Eugeni Dodonov <eugeni.dodonov@intel.com>
Subject: [10/21] drm/i915: Fix TV Out refresh rate.
In-Reply-To: <20120210224858.GA30752@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Rodrigo Vivi <rodrigo.vivi@gmail.com>

commit 23bd15ec662344dc10e9918fdd0dbc58bc71526d upstream.

TV Out refresh rate was half of the specification for almost all modes.
Due to this reason pixel clock was so low for some modes causing flickering screen.

Signed-off-by: Rodrigo Vivi <rodrigo.vivi@gmail.com>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_tv.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/gpu/drm/i915/intel_tv.c
+++ b/drivers/gpu/drm/i915/intel_tv.c
@@ -415,7 +415,7 @@ static const struct tv_mode tv_modes[] =
 	{
 		.name		= "NTSC-M",
 		.clock		= 108000,
-		.refresh	= 29970,
+		.refresh	= 59940,
 		.oversample	= TV_OVERSAMPLE_8X,
 		.component_only = 0,
 		/* 525 Lines, 60 Fields, 15.734KHz line, Sub-Carrier 3.580MHz */
@@ -458,7 +458,7 @@ static const struct tv_mode tv_modes[] =
 	{
 		.name		= "NTSC-443",
 		.clock		= 108000,
-		.refresh	= 29970,
+		.refresh	= 59940,
 		.oversample	= TV_OVERSAMPLE_8X,
 		.component_only = 0,
 		/* 525 Lines, 60 Fields, 15.734KHz line, Sub-Carrier 4.43MHz */
@@ -500,7 +500,7 @@ static const struct tv_mode tv_modes[] =
 	{
 		.name		= "NTSC-J",
 		.clock		= 108000,
-		.refresh	= 29970,
+		.refresh	= 59940,
 		.oversample	= TV_OVERSAMPLE_8X,
 		.component_only = 0,
 
@@ -543,7 +543,7 @@ static const struct tv_mode tv_modes[] =
 	{
 		.name		= "PAL-M",
 		.clock		= 108000,
-		.refresh	= 29970,
+		.refresh	= 59940,
 		.oversample	= TV_OVERSAMPLE_8X,
 		.component_only = 0,
 
@@ -587,7 +587,7 @@ static const struct tv_mode tv_modes[] =
 		/* 625 Lines, 50 Fields, 15.625KHz line, Sub-Carrier 4.434MHz */
 		.name	    = "PAL-N",
 		.clock		= 108000,
-		.refresh	= 25000,
+		.refresh	= 50000,
 		.oversample	= TV_OVERSAMPLE_8X,
 		.component_only = 0,
 
@@ -632,7 +632,7 @@ static const struct tv_mode tv_modes[] =
 		/* 625 Lines, 50 Fields, 15.625KHz line, Sub-Carrier 4.434MHz */
 		.name	    = "PAL",
 		.clock		= 108000,
-		.refresh	= 25000,
+		.refresh	= 50000,
 		.oversample	= TV_OVERSAMPLE_8X,
 		.component_only = 0,
 
@@ -819,7 +819,7 @@ static const struct tv_mode tv_modes[] =
 	{
 		.name       = "1080i@50Hz",
 		.clock		= 148800,
-		.refresh	= 25000,
+		.refresh	= 50000,
 		.oversample     = TV_OVERSAMPLE_2X,
 		.component_only = 1,
 
@@ -845,7 +845,7 @@ static const struct tv_mode tv_modes[] =
 	{
 		.name       = "1080i@60Hz",
 		.clock		= 148800,
-		.refresh	= 30000,
+		.refresh	= 60000,
 		.oversample     = TV_OVERSAMPLE_2X,
 		.component_only = 1,
 


