Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642Ab2BJWmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 17:42:08 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35084 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab2BJWmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:42:04 -0500
MIME-Version: 1.0
Message-Id: <20120210222948.920837690@clark.kroah.org>
User-Agent: quilt/0.51-15.1
Date: Fri, 10 Feb 2012 14:30:03 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Keith Packard <keithp@keithp.com>
Subject: [patch 44/86] drm/i915: handle 3rd pipe
In-Reply-To: <20120210223514.GA24190@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eugeni Dodonov <eugeni.dodonov@intel.com>

commit 07c1e8c1462fa7324de4c36ae9e55da2abd79cee upstream.

We don't need to check 3rd pipe specifically, as it shares PLL with some
other one.

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=41977
Signed-off-by: Eugeni Dodonov <eugeni.dodonov@intel.com>
Reviewed-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Keith Packard <keithp@keithp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_suspend.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/i915/i915_suspend.c
+++ b/drivers/gpu/drm/i915/i915_suspend.c
@@ -34,6 +34,10 @@ static bool i915_pipe_enabled(struct drm
 	struct drm_i915_private *dev_priv = dev->dev_private;
 	u32	dpll_reg;
 
+	/* On IVB, 3rd pipe shares PLL with another one */
+	if (pipe > 1)
+		return false;
+
 	if (HAS_PCH_SPLIT(dev))
 		dpll_reg = (pipe == PIPE_A) ? _PCH_DPLL_A : _PCH_DPLL_B;
 	else


