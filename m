Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162635Ab2GLXEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 19:04:15 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60424 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162531Ab2GLXEJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 19:04:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Adam Jackson <ajax@redhat.com>,
        Dave Airlie <airlied@redhat.com>
Subject: [ 26/68] drm/edid: dont return stack garbage from supports_rb
Date: Thu, 12 Jul 2012 16:02:00 -0700
Message-Id: <20120712175037.761378308@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120712175035.530652872@linuxfoundation.org>
References: <20120712175057.GA9917@kroah.com>
 <20120712175035.530652872@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Vetter <daniel.vetter@ffwll.ch>

commit b196a4980ff7bb54db478e2a408dc8b12be15304 upstream.

We need to initialize this to false, because the is_rb callback only
ever sets it to true.

Noticed while reading through the code.

Signed-Off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Reviewed-by: Adam Jackson <ajax@redhat.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_edid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -584,7 +584,7 @@ static bool
 drm_monitor_supports_rb(struct edid *edid)
 {
 	if (edid->revision >= 4) {
-		bool ret;
+		bool ret = false;
 		drm_for_each_detailed_block((u8 *)edid, is_rb, &ret);
 		return ret;
 	}


