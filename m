Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab1G0MDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 08:03:31 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:56073 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab1G0MD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 08:03:28 -0400
Message-ID: <4E2FFE8B.6060904@fedoraproject.org>
Date: Wed, 27 Jul 2011 14:03:23 +0200
From: Michel Alexandre Salim <salimma@fedoraproject.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Intel graphics <Intel-gfx@lists.freedesktop.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        DRI devel <dri-devel@lists.freedesktop.org>
Subject: [PATCH] drm/i915: Add quirk to disable SSC on Sony Vaio Y2
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Using the new quirk added to support disabling SSC on Lenovo U160
(#36656, commit 435793dfb8aec7b2e19f72d5bce8a22fd0b57839), also register
the Vaio as a special case and disable SSC for it.

This patch fixes #34437 on fdo bugzilla:
https://bugs.freedesktop.org/show_bug.cgi?id=34437
- ---
 drivers/gpu/drm/i915/intel_display.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/i915/intel_display.c
b/drivers/gpu/drm/i915/intel_display.c
index 0f1c799..11eb831 100644
- --- a/drivers/gpu/drm/i915/intel_display.c
+++ b/drivers/gpu/drm/i915/intel_display.c
@@ -7851,6 +7851,9 @@ struct intel_quirk intel_quirks[] = {

        /* Lenovo U160 cannot use SSC on LVDS */
        { 0x0046, 0x17aa, 0x3920, quirk_ssc_force_disable },
+
+       /* Sony Vaio Y cannot use SSC on LVDS */
+       { 0x0046, 0x104d, 0x9076, quirk_ssc_force_disable },
 };

 static void intel_init_quirks(struct drm_device *dev)
- -- 
1.7.6

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk4v/oUACgkQNd069XiIR3gZFgCfTcZBgVMmPfo5l2/Xxstl82fj
05QAn3lbi1rNHjhbfgwdURV8oLgfQrZK
=ghae
-----END PGP SIGNATURE-----
