Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162335Ab1FAIz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:55:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43692 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162266Ab1FAISp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:18:45 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:05:04 2011
Message-Id: <20110601080503.707281044@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:01:15 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dave Airlie <airlied@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [139/146] drm/radeon/kms: add wait idle ioctl for eg->cayman
In-Reply-To: <20110601080606.GA522@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Airlie <airlied@redhat.com>

commit 97bfd0acd32e9639c9136e03955d574655d5cc2b upstream.

None of the latest GPUs had this hooked up, this is necessary for
correct operation in a lot of cases, however we should test this on a few
GPUs in these families as we've had problems in this area before.

Reviewed-by: Alex Deucher <alexdeucher@gmail.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/gpu/drm/radeon/radeon_asic.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/radeon/radeon_asic.c
+++ b/drivers/gpu/drm/radeon/radeon_asic.c
@@ -782,6 +782,7 @@ static struct radeon_asic evergreen_asic
 	.hpd_fini = &evergreen_hpd_fini,
 	.hpd_sense = &evergreen_hpd_sense,
 	.hpd_set_polarity = &evergreen_hpd_set_polarity,
+	.ioctl_wait_idle = r600_ioctl_wait_idle,
 	.gui_idle = &r600_gui_idle,
 	.pm_misc = &evergreen_pm_misc,
 	.pm_prepare = &evergreen_pm_prepare,
@@ -828,6 +829,7 @@ static struct radeon_asic sumo_asic = {
 	.hpd_fini = &evergreen_hpd_fini,
 	.hpd_sense = &evergreen_hpd_sense,
 	.hpd_set_polarity = &evergreen_hpd_set_polarity,
+	.ioctl_wait_idle = r600_ioctl_wait_idle,
 	.gui_idle = &r600_gui_idle,
 	.pm_misc = &evergreen_pm_misc,
 	.pm_prepare = &evergreen_pm_prepare,
@@ -874,6 +876,8 @@ static struct radeon_asic btc_asic = {
 	.hpd_fini = &evergreen_hpd_fini,
 	.hpd_sense = &evergreen_hpd_sense,
 	.hpd_set_polarity = &evergreen_hpd_set_polarity,
+	.ioctl_wait_idle = r600_ioctl_wait_idle,
+	.ioctl_wait_idle = r600_ioctl_wait_idle,
 	.gui_idle = &r600_gui_idle,
 	.pm_misc = &evergreen_pm_misc,
 	.pm_prepare = &evergreen_pm_prepare,


