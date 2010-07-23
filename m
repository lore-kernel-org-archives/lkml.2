Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab0GWSue (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 14:50:34 -0400
Received: from p01c12o141.mxlogic.net ([208.65.145.64]:58214 "EHLO
	p01c12o141.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318Ab0GWSud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 14:50:33 -0400
X-MXL-Hash: 4c49e47968713d7f-83c3063ba374a92b8a36fb4a973b1ac2baae6208
X-MXL-Hash: 4c49e46e775047e2-74378205cf55f94e86c5aab948912c4edb52609c
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] Staging: dt3155: make local functions static
Date: Fri, 23 Jul 2010 11:49:25 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <gregkh@suse.de>, <ss@aao.gov.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201007231149.26015.hartleys@visionengravers.com>
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010070601)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.72]
X-AnalysisOut: [v=1.0 c=1 a=aotffO6ukj8A:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=jM3uHZP82BWpxjlUuN2t4A==:17 a=i00gxMtYAAAA:8 a=OoR]
X-AnalysisOut: [7ru7LXorzS3FmPqYA:9 a=jS6cX8wJPEcVu-1-xD4A:7 a=pp8nxvq9HiV]
X-AnalysisOut: [bZDdxHLCtxA3Q0rcA:4 a=QEXdDO2ut3YA:10 a=x1WnkoZAwusA:10 a=]
X-AnalysisOut: [0kPLrQdw3YYA:10 a=ZyMYofmC0d03tEYu:21 a=rCbehiuzG0tvYG5f:2]
X-AnalysisOut: [1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions adjust_4MB and allocate_buffers are only called locally in
dt3155_isr.c and should be static.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Scott Smedley <ss@aao.gov.au>

---

diff --git a/drivers/staging/dt3155/dt3155_isr.c b/drivers/staging/dt3155/dt3155_isr.c
index 549186f..1e91e6c 100644
--- a/drivers/staging/dt3155/dt3155_isr.c
+++ b/drivers/staging/dt3155/dt3155_isr.c
@@ -180,7 +180,7 @@ void printques(struct dt3155_fbuffer *fb)
  *  the start address up to the beginning of the
  *  next 4MB chunk (assuming bufsize < 4MB).
  *****************************************************/
-u32 adjust_4MB(u32 buf_addr, u32 bufsize)
+static u32 adjust_4MB(u32 buf_addr, u32 bufsize)
 {
     if (((buf_addr+bufsize) & UPPER_10_BITS) != (buf_addr & UPPER_10_BITS))
 	return (buf_addr+bufsize) & UPPER_10_BITS;
@@ -196,7 +196,7 @@ u32 adjust_4MB(u32 buf_addr, u32 bufsize)
  *  buffers.  If there is not enough free space
  *  try for less memory.
  *****************************************************/
-void allocate_buffers(u32 *buf_addr, u32* total_size_kbs,
+static void allocate_buffers(u32 *buf_addr, u32* total_size_kbs,
 		       u32 bufsize)
 {
   /* Compute the minimum amount of memory guaranteed to hold all
