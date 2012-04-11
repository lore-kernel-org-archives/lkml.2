Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965012Ab2DKXST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 19:18:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39063 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964999Ab2DKXSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 19:18:16 -0400
Message-Id: <20120411231031.091500541@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Wed, 11 Apr 2012 16:11:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stephen Warren <swarren@nvidia.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [ 75/78] ASoC: tegra: fix i2s compilation when !CONFIG_DEBUG_FS
In-Reply-To: <20120411231102.GA6404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Warren <swarren@nvidia.com>

commit 8abe05c6eb358967f16bce8a02c88d57c82cfbd6 upstream.

Commit d4a2eca "ASoC: Tegra I2S: Remove dependency on pdev->id" changed
the prototype of tegra_i2s_debug_add, but didn't update the dummy inline
used when !CONFIG_DEBUG_FS. Fix that.

Signed-off-by: Stephen Warren <swarren@nvidia.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 sound/soc/tegra/tegra_i2s.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/tegra/tegra_i2s.c
+++ b/sound/soc/tegra/tegra_i2s.c
@@ -112,7 +112,7 @@ static void tegra_i2s_debug_remove(struc
 		debugfs_remove(i2s->debug);
 }
 #else
-static inline void tegra_i2s_debug_add(struct tegra_i2s *i2s, int id)
+static inline void tegra_i2s_debug_add(struct tegra_i2s *i2s)
 {
 }
 


