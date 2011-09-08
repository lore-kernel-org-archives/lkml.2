Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933016Ab1IHNvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 09:51:18 -0400
Received: from darkcity.gna.ch ([195.226.6.51]:51093 "EHLO mail.gna.ch"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932789Ab1IHNvQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 09:51:16 -0400
Subject: Re: [PATCH 2.6.38-10-generic] device driver: fix oops in radeon
 driver due to incorrect value from hardware
From: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: "A.R Karthick" <a.r.karthick@gmail.com>, Mayank Rungta <mr.mynk@gmail.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        karthick.linuxdreamer@gmail.com
Date: Thu, 08 Sep 2011 15:50:54 +0200
In-Reply-To: <CADnq5_Mk3oUHU+iABeFiGz=FaPnLVbtyYCA_6KnWA_QTfigfew@mail.gmail.com>
References: <4E417AF8.7090202@gmail.com>
	 <1312968271.14630.189.camel@thor.local>
	 <CADnq5_Mk3oUHU+iABeFiGz=FaPnLVbtyYCA_6KnWA_QTfigfew@mail.gmail.com>
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAAXNSR0IArs4c6QAAADBQTFRFDg4OHh4eLCwsOzs7S0tLWlpaa2treXl5hISEjY2NmJiYqKiotLS0xsbG1dXV/Pz81CO0SQAAArtJREFUOMtd1M9P01AcAHCI/4AtGq/QDfDHRfraEX8eaNeJFw1rO/DCYet7mxc1ZG0x3sStHQkmZpqtHDwAi+tMiFEzbZdwNWEJR48cjPG4g5HhELUbrHvjpYe2n7zvt++977cD/7rjsCry8uNG93Gge9OKUyAAgLB1AlpTZICmAzR15QTEiQAPAKADYLMPfhNnEJR4HvD0tT5YI2KGUcyqihQN7mDwZ3hMN4q2N4ol+gEGTSLWhorrjYXrGPwc0jTDOoKP4xi8G0W6adl2Gz6zGDwag5p5PMON7vZgJuSB976+3U6y2QdeKNet1+uum9/qwVQHvEjtKesY0EIb7CNYe+7DIRXCID/vQ4tksVAY7JFBD7yvqrWTL93xoUmOQsPIddbnuk8v+bBPsigB2KRlFxS4nL/owwEpKBSg2MU3UcDf+nATyyHEQwrHzJZFNpXeuOHDC0qW4sMhEHESFGOUrvgQpWUYFVNQdjQxca8abnSB55CmehdcLSxa1ifoQ4JBpmGYWbhsly3X0fxQ7xmkW3Y5CztLcXI+fAu2oWho3nbV6s5rH35xSC/aBR2tOpVa/Utv25tcTDPL6aT21kG17WrvaFtMBJmFhJCsVF4uu9VG76DWBaRnEiNs7pU659pYlfwtQSRy9GCYlwR7C6/dPQgBw3MsTPNWA4d9SeMDDC9JYdnqq/amdF+diGnVhXFztQ/2lJSWjulOxjRX+uC7EkOqhLRk2ejrqHVBEqCqJLO5cmEXgx8TrBiWVQh1u2DhzQlPsyIveU2YLGorGBxODoR5notlpcUieoLB1/NEmGc4AalGJpLe8WF/8txMWASAkVVViQjzP
 jycPrvgA
	R1goSzOnkp14YCYHsp7QJHAS5QcXDqG1jBxdSITVgBNkBTFloj88Q/gMkFcuItYiQPUCBGc2xh5drsD/wGZrgsgDOE4ZAAAAABJRU5ErkJggg==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1315489854.25712.60.camel@thor.local>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2011-08-10 at 09:27 -0400, Alex Deucher wrote: 
> 2011/8/10 Michel Dänzer <michel@daenzer.net>:
> > On Die, 2011-08-09 at 23:52 +0530, Mayank Rungta wrote:
> >> Added a check for the radeon ring buffer write index in r600.c which
> >> reads 0xffffffff on resume. This results in an Oops during
> >> radeon_ring_write. Masking the value averts this.
> >>
> >> This problem is not seen to be fixed in 3.0 r600.c as well.
> >>
> >> Detailed analysis of the problem can be found at -
> >>
> >> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/820746/
> >>
> >> ---
> >>
> >> BUG: unable to handle kernel paging request at fa501ffc - Oops at
> >> r600_cp_start+0x48/0x380 in r600_cp_resume+0x345/0x580 [radeon]
> >>
> >> drivers/gpu/drm/radeon/r600.c
> >>
> >>
> >>
> >> --- linux-2.6.38/drivers/gpu/drm/radeon/r600.c.orig    2011-08-05
> >> 15:39:40.824612700 +0530
> >> +++ linux-2.6.38/drivers/gpu/drm/radeon/r600.c    2011-08-08
> >> 05:29:21.744417857 +0530
> >> @@ -2218,6 +2218,8 @@ int r600_cp_resume(struct radeon_device
> >>
> >>       rdev->cp.rptr = RREG32(CP_RB_RPTR);
> >>       rdev->cp.wptr = RREG32(CP_RB_WPTR);
> >> +    /* protect against crazy HW on resume */
> >> +    rdev->cp.wptr &= rdev->cp.ptr_mask;
> >
> > Although the same workaround is already in r100.c, I wonder if we
> > shouldn't rather try and eliminate all reads from the CP_RB_WPTR
> > register, at least other than for debugging purposes. Alex, what do you
> > think?
> 
> Either this or reset the registers to 0 or a saved value on resume
> rather than reading from them.

The patch below is what I had in mind. Does this fix the problem above?


>From c564bc8e6d449216d74ee134d5bf470221f79e8d Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>
Date: Thu, 8 Sep 2011 11:09:39 +0200
Subject: [PATCH] drm/radeon: Don't read from CP ring write pointer registers.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Apparently this doesn't always work reliably, e.g. at resume time.

Just initialize to 0, so the ring is considered empty.

Tested with hibernation on Sumo and Cayman cards.

Should fix https://bugs.launchpad.net/ubuntu/+source/linux/+bug/820746/ .

Signed-off-by: Michel Dänzer <michel.daenzer@amd.com>
---
 drivers/gpu/drm/radeon/evergreen.c |    4 ++--
 drivers/gpu/drm/radeon/ni.c        |   12 ++++++------
 drivers/gpu/drm/radeon/r100.c      |    6 ++----
 drivers/gpu/drm/radeon/r600.c      |    4 ++--
 4 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/radeon/evergreen.c b/drivers/gpu/drm/radeon/evergreen.c
index 15bd047..f2bd90a 100644
--- a/drivers/gpu/drm/radeon/evergreen.c
+++ b/drivers/gpu/drm/radeon/evergreen.c
@@ -1378,7 +1378,8 @@ int evergreen_cp_resume(struct radeon_device *rdev)
 	/* Initialize the ring buffer's read and write pointers */
 	WREG32(CP_RB_CNTL, tmp | RB_RPTR_WR_ENA);
 	WREG32(CP_RB_RPTR_WR, 0);
-	WREG32(CP_RB_WPTR, 0);
+	rdev->cp.wptr = 0;
+	WREG32(CP_RB_WPTR, rdev->cp.wptr);
 
 	/* set the wb address wether it's enabled or not */
 	WREG32(CP_RB_RPTR_ADDR,
@@ -1403,7 +1404,6 @@ int evergreen_cp_resume(struct radeon_device *rdev)
 	WREG32(CP_DEBUG, (1 << 27) | (1 << 28));
 
 	rdev->cp.rptr = RREG32(CP_RB_RPTR);
-	rdev->cp.wptr = RREG32(CP_RB_WPTR);
 
 	evergreen_cp_start(rdev);
 	rdev->cp.ready = true;
diff --git a/drivers/gpu/drm/radeon/ni.c b/drivers/gpu/drm/radeon/ni.c
index 559dbd4..e3489ee 100644
--- a/drivers/gpu/drm/radeon/ni.c
+++ b/drivers/gpu/drm/radeon/ni.c
@@ -1182,7 +1182,8 @@ int cayman_cp_resume(struct radeon_device *rdev)
 
 	/* Initialize the ring buffer's read and write pointers */
 	WREG32(CP_RB0_CNTL, tmp | RB_RPTR_WR_ENA);
-	WREG32(CP_RB0_WPTR, 0);
+	rdev->cp.wptr = 0;
+	WREG32(CP_RB0_WPTR, rdev->cp.wptr);
 
 	/* set the wb address wether it's enabled or not */
 	WREG32(CP_RB0_RPTR_ADDR, (rdev->wb.gpu_addr + RADEON_WB_CP_RPTR_OFFSET) & 0xFFFFFFFC);
@@ -1202,7 +1203,6 @@ int cayman_cp_resume(struct radeon_device *rdev)
 	WREG32(CP_RB0_BASE, rdev->cp.gpu_addr >> 8);
 
 	rdev->cp.rptr = RREG32(CP_RB0_RPTR);
-	rdev->cp.wptr = RREG32(CP_RB0_WPTR);
 
 	/* ring1  - compute only */
 	/* Set ring buffer size */
@@ -1215,7 +1215,8 @@ int cayman_cp_resume(struct radeon_device *rdev)
 
 	/* Initialize the ring buffer's read and write pointers */
 	WREG32(CP_RB1_CNTL, tmp | RB_RPTR_WR_ENA);
-	WREG32(CP_RB1_WPTR, 0);
+	rdev->cp1.wptr = 0;
+	WREG32(CP_RB1_WPTR, rdev->cp1.wptr);
 
 	/* set the wb address wether it's enabled or not */
 	WREG32(CP_RB1_RPTR_ADDR, (rdev->wb.gpu_addr + RADEON_WB_CP1_RPTR_OFFSET) & 0xFFFFFFFC);
@@ -1227,7 +1228,6 @@ int cayman_cp_resume(struct radeon_device *rdev)
 	WREG32(CP_RB1_BASE, rdev->cp1.gpu_addr >> 8);
 
 	rdev->cp1.rptr = RREG32(CP_RB1_RPTR);
-	rdev->cp1.wptr = RREG32(CP_RB1_WPTR);
 
 	/* ring2 - compute only */
 	/* Set ring buffer size */
@@ -1240,7 +1240,8 @@ int cayman_cp_resume(struct radeon_device *rdev)
 
 	/* Initialize the ring buffer's read and write pointers */
 	WREG32(CP_RB2_CNTL, tmp | RB_RPTR_WR_ENA);
-	WREG32(CP_RB2_WPTR, 0);
+	rdev->cp2.wptr = 0;
+	WREG32(CP_RB2_WPTR, rdev->cp2.wptr);
 
 	/* set the wb address wether it's enabled or not */
 	WREG32(CP_RB2_RPTR_ADDR, (rdev->wb.gpu_addr + RADEON_WB_CP2_RPTR_OFFSET) & 0xFFFFFFFC);
@@ -1252,7 +1253,6 @@ int cayman_cp_resume(struct radeon_device *rdev)
 	WREG32(CP_RB2_BASE, rdev->cp2.gpu_addr >> 8);
 
 	rdev->cp2.rptr = RREG32(CP_RB2_RPTR);
-	rdev->cp2.wptr = RREG32(CP_RB2_WPTR);
 
 	/* start the rings */
 	cayman_cp_start(rdev);
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index f2204cb..11e44a3 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -990,7 +990,8 @@ int r100_cp_init(struct radeon_device *rdev, unsigned ring_size)
 	/* Force read & write ptr to 0 */
 	WREG32(RADEON_CP_RB_CNTL, tmp | RADEON_RB_RPTR_WR_ENA | RADEON_RB_NO_UPDATE);
 	WREG32(RADEON_CP_RB_RPTR_WR, 0);
-	WREG32(RADEON_CP_RB_WPTR, 0);
+	rdev->cp.wptr = 0;
+	WREG32(RADEON_CP_RB_WPTR, rdev->cp.wptr);
 
 	/* set the wb address whether it's enabled or not */
 	WREG32(R_00070C_CP_RB_RPTR_ADDR,
@@ -1007,9 +1008,6 @@ int r100_cp_init(struct radeon_device *rdev, unsigned ring_size)
 	WREG32(RADEON_CP_RB_CNTL, tmp);
 	udelay(10);
 	rdev->cp.rptr = RREG32(RADEON_CP_RB_RPTR);
-	rdev->cp.wptr = RREG32(RADEON_CP_RB_WPTR);
-	/* protect against crazy HW on resume */
-	rdev->cp.wptr &= rdev->cp.ptr_mask;
 	/* Set cp mode to bus mastering & enable cp*/
 	WREG32(RADEON_CP_CSQ_MODE,
 	       REG_SET(RADEON_INDIRECT2_START, indirect2_start) |
diff --git a/drivers/gpu/drm/radeon/r600.c b/drivers/gpu/drm/radeon/r600.c
index bc54b26..8ca098d 100644
--- a/drivers/gpu/drm/radeon/r600.c
+++ b/drivers/gpu/drm/radeon/r600.c
@@ -2208,7 +2208,8 @@ int r600_cp_resume(struct radeon_device *rdev)
 	/* Initialize the ring buffer's read and write pointers */
 	WREG32(CP_RB_CNTL, tmp | RB_RPTR_WR_ENA);
 	WREG32(CP_RB_RPTR_WR, 0);
-	WREG32(CP_RB_WPTR, 0);
+	rdev->cp.wptr = 0;
+	WREG32(CP_RB_WPTR, rdev->cp.wptr);
 
 	/* set the wb address whether it's enabled or not */
 	WREG32(CP_RB_RPTR_ADDR,
@@ -2233,7 +2234,6 @@ int r600_cp_resume(struct radeon_device *rdev)
 	WREG32(CP_DEBUG, (1 << 27) | (1 << 28));
 
 	rdev->cp.rptr = RREG32(CP_RB_RPTR);
-	rdev->cp.wptr = RREG32(CP_RB_WPTR);
 
 	r600_cp_start(rdev);
 	rdev->cp.ready = true;
-- 
1.7.5.4

-- 
Earthling Michel Dänzer           |                   http://www.amd.com
Libre software enthusiast         |          Debian, X and DRI developer
