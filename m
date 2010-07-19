Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967010Ab0GSVnB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 17:43:01 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58446 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966904Ab0GSVm4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 17:42:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=WC81SDmGgtZXAgCGo1j87BLD9XZl9p+UORYxX4FX0kSiKewACFSbvkaoS2ZN93U1TM
         HZ127gShUZSJ8dzER5E5KKNoPN0Cfa2FezgtydZYasMWM6c84fPjSRRUt8Epg57BNRQ6
         LuR/sJTi5izJplen18pzDaGoOHGg8hjRDcJYA=
Date: Tue, 20 Jul 2010 01:42:51 +0400
From: "Alexander Y. Fomichev" <git.user@gmail.com>
To: Dave Airlie <airlied@redhat.com>, Alex Deucher <alexdeucher@gmail.com>,
        Robert Noland <rnoland@2hip.net>, Matt Turner <mattst88@gmail.com>,
        Jerome Glisse <jglisse@redhat.com>, akpm@linux-foundation.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: drivers/gpu/drm/radeon/r600_blit.c: fix possible NULL pointer
 derefernce
Message-ID: <20100720014251.46b91cdd@mad-cat.localdomain>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix possible NULL pointer dereference when
r600_prepare_blit_copy tries to fill dev_priv->blit_vb->file_priv
without check of dev_priv->blit_vb. dev_priv->blit_vb should be
filled by r600_nomm_get_vb but latest can fail with EAGAIN.
Addresses: https://bugzilla.kernel.org/show_bug.cgi?id=16375

---
 drivers/gpu/drm/radeon/r600_blit.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/gpu/drm/radeon/r600_blit.c b/drivers/gpu/drm/radeon/r600_blit.c
index f4fb88e..0df4a2b 100644
--- a/drivers/gpu/drm/radeon/r600_blit.c
+++ b/drivers/gpu/drm/radeon/r600_blit.c
@@ -541,6 +541,8 @@ r600_prepare_blit_copy(struct drm_device *dev, struct drm_file *file_priv)
        DRM_DEBUG("\n");

        r600_nomm_get_vb(dev);
+       if (!dev_priv->blit_vb)
+               return;

        dev_priv->blit_vb->file_priv = file_priv;

--
1.7.1.1
