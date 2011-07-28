Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab1G1QwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 12:52:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56780 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755300Ab1G1QwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 12:52:09 -0400
Subject: [PATCH] drm/i915: Add quirk to disable SSC on Sony Vaio Y2
From: Michel Alexandre Salim <salimma@fedoraproject.org>
To: intel-gfx@lists.freedesktop.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Keith Packard <keithp@keithp.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 28 Jul 2011 18:52:06 +0200
Organization: Fedora Project
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.2 (3.0.2-3.fc15)
Content-Transfer-Encoding: 7bit
Message-ID: <1311871927.21246.6.camel@fauix11.informatik.uni-erlangen.de>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the new quirk added to support disabling SSC on Lenovo U160
(#36656, commit 435793dfb8aec7b2e19f72d5bce8a22fd0b57839), also register
the Vaio as a special case and disable SSC for it.

This patch fixes #34437 on fdo bugzilla:
https://bugs.freedesktop.org/show_bug.cgi?id=34437

Signed-off-by: Michel Alexandre Salim <salimma@fedoraproject.org>
---
 drivers/gpu/drm/i915/intel_display.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
index 0f1c799..11eb831 100644
--- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7851,6 +7851,9 @@ struct intel_quirk intel_quirks[] = {
 
 	/* Lenovo U160 cannot use SSC on LVDS */
 	{ 0x0046, 0x17aa, 0x3920, quirk_ssc_force_disable },
+
+	/* Sony Vaio Y cannot use SSC on LVDS */
+	{ 0x0046, 0x104d, 0x9076, quirk_ssc_force_disable },
 };
 
 static void intel_init_quirks(struct drm_device *dev)
-- 
1.7.6



