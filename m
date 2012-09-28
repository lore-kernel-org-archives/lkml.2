Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031669Ab2I1Trf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:47:35 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965142Ab2I1S6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:58:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alan Cox <alan@linux.intel.com>, Dave Airlie <airlied@redhat.com>
Subject: [ 101/262] gma500: Fix regression on Oaktrail devices
Date: Fri, 28 Sep 2012 11:50:30 -0700
Message-Id: <20120928183010.024854077@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit 26df641eac05abe1a3276eea441359b4d1120816 upstream.

The register map patches didn't set one value for the GMA600 which
means the Fujitsu Q550 dies on boot with the GMA500 driver enabled.

Add the map entry so we don't read from the device MMIO + 0 by mistake.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/gma500/oaktrail_device.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/gma500/oaktrail_device.c
+++ b/drivers/gpu/drm/gma500/oaktrail_device.c
@@ -476,6 +476,7 @@ static const struct psb_offset oaktrail_
 		.pos = DSPAPOS,
 		.surf = DSPASURF,
 		.addr = MRST_DSPABASE,
+		.base = MRST_DSPABASE,
 		.status = PIPEASTAT,
 		.linoff = DSPALINOFF,
 		.tileoff = DSPATILEOFF,
@@ -499,6 +500,7 @@ static const struct psb_offset oaktrail_
 		.pos = DSPBPOS,
 		.surf = DSPBSURF,
 		.addr = DSPBBASE,
+		.base = DSPBBASE,
 		.status = PIPEBSTAT,
 		.linoff = DSPBLINOFF,
 		.tileoff = DSPBTILEOFF,


