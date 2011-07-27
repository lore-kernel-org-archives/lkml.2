Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab1G0MMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 08:12:20 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:43541 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab1G0MMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 08:12:18 -0400
Message-ID: <4E30009E.3080702@fedoraproject.org>
Date: Wed, 27 Jul 2011 14:12:14 +0200
From: Michel Alexandre Salim <salimma@fedoraproject.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Intel graphics <Intel-gfx@lists.freedesktop.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        DRI devel <dri-devel@lists.freedesktop.org>
Subject: Re: [PATCH] drm/i915: Add quirk to disable SSC on Sony Vaio Y2
References: <4E2FFE8B.6060904@fedoraproject.org>
In-Reply-To: <4E2FFE8B.6060904@fedoraproject.org>
X-Enigmail-Version: 1.2
Content-Type: multipart/mixed;
 boundary="------------080000080306000604040506"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080000080306000604040506
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 07/27/2011 02:03 PM, Michel Alexandre Salim wrote:
> Using the new quirk added to support disabling SSC on Lenovo U160
> (#36656, commit 435793dfb8aec7b2e19f72d5bce8a22fd0b57839), also
> register the Vaio as a special case and disable SSC for it.
>
Apologies; Thunderbird mangled the patch. I'm attaching it to make sure
it arrives intact.

- -- 
Michel Alexandre Salim
µblog:      http://identi.ca/hircus
            http://twitter.com/hircus
GPG key ID: 78884778

()  ascii ribbon campaign - against html e-mail
/\  www.asciiribbon.org   - against proprietary attachments
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk4wAJ4ACgkQNd069XiIR3gN3QCfehYUPl1e46D/0fahZkwwMOyp
i7AAnRhqEZOVfigArWU00dS+tr4HMOvC
=Y243
-----END PGP SIGNATURE-----

--------------080000080306000604040506
Content-Type: text/plain;
 name="0001-drm-i915-Add-quirk-to-disable-SSC-on-Sony-Vaio-Y2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-drm-i915-Add-quirk-to-disable-SSC-on-Sony-Vaio-Y2.patch"

>From dc5ed070efda5e4d3c8aed79f9b3e2c97c489fcb Mon Sep 17 00:00:00 2001
From: Michel Alexandre Salim <salimma@fedoraproject.org>
Date: Wed, 27 Jul 2011 10:08:25 +0200
Subject: [PATCH] drm/i915: Add quirk to disable SSC on Sony Vaio Y2

Using the new quirk added to support disabling SSC on Lenovo U160
(#36656, commit 435793dfb8aec7b2e19f72d5bce8a22fd0b57839), also register
the Vaio as a special case and disable SSC for it.

This patch fixes #34437 on fdo bugzilla:
https://bugs.freedesktop.org/show_bug.cgi?id=34437
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


--------------080000080306000604040506--
