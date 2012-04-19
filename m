Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570Ab2DSVMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:12:16 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44862 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259Ab2DSVMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:12:13 -0400
Message-Id: <20120419210303.569477922@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:03:08 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alex Deucher <alexander.deucher@amd.com>,
        Jean Delvare <khali@linux-fr.org>, Dave Airlie <airlied@redhat.com>
Subject: [ 05/75] drm/radeon: only add the mm i2c bus if the hw_i2c module param is set
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

commit 46783150a6552f9513f08e62cfcc07125d6e502b upstream.

It seems it can corrupt the monitor EDID in certain cases on certain
boards when running sensors detect.  It's rarely used anyway outside
of AIW boards.

http://lists.lm-sensors.org/pipermail/lm-sensors/2012-April/035847.html
http://lists.freedesktop.org/archives/xorg/2011-January/052239.html

Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_i2c.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_i2c.c
+++ b/drivers/gpu/drm/radeon/radeon_i2c.c
@@ -890,6 +890,10 @@ struct radeon_i2c_chan *radeon_i2c_creat
 	struct radeon_i2c_chan *i2c;
 	int ret;
 
+	/* don't add the mm_i2c bus unless hw_i2c is enabled */
+	if (rec->mm_i2c && (radeon_hw_i2c == 0))
+		return NULL;
+
 	i2c = kzalloc(sizeof(struct radeon_i2c_chan), GFP_KERNEL);
 	if (i2c == NULL)
 		return NULL;


