Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030986Ab2I1TZH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:25:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33712 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030436Ab2I1TDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:03:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <deathsimple@vodafone.de>,
        =?UTF-8?q?Michel=20D=C3=A4nzer?= <michel.daenzer@amd.com>
Subject: =?UTF-8?q?=5B=20187/262=5D=20drm/radeon=3A=20init=20lockup=20timeout=20on=20ring=20init?=
Date: Fri, 28 Sep 2012 11:51:56 -0700
Message-Id: <20120928183020.147971545@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <deathsimple@vodafone.de>

commit 48c0ac9911839daf188e4a0b6b132ac31050a241 upstream.

Reset the lockup timeout on ring (re-)initialisation.

Otherwise we get error messages like this on gpu resets:
[ 1559.949177] radeon 0000:01:00.0: GPU lockup CP stall for more than 1482270msec

Signed-off-by: Christian König <deathsimple@vodafone.de>
Reviewed-by: Michel Dänzer <michel.daenzer@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/radeon/radeon_ring.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/radeon/radeon_ring.c
+++ b/drivers/gpu/drm/radeon/radeon_ring.c
@@ -394,6 +394,7 @@ int radeon_ring_init(struct radeon_devic
 	if (radeon_debugfs_ring_init(rdev, ring)) {
 		DRM_ERROR("Failed to register debugfs file for rings !\n");
 	}
+	radeon_ring_lockup_update(ring);
 	return 0;
 }
 


