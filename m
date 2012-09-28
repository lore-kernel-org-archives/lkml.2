Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030881Ab2I1TIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:08:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33712 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030850Ab2I1THO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:07:14 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Dave Airlie <airlied@gmail.com>
Subject: [ 262/262] vmwgfx: corruption in vmw_event_fence_action_create()
Date: Fri, 28 Sep 2012 11:53:11 -0700
Message-Id: <20120928183029.476862989@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 68c4fce737c4b963e336435f225621dc21138397 upstream.

We don't allocate enough data for this struct.  As soon as we start
modifying event->event on the next lines, then we're going beyond the
end of the memory we allocated.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Dave Airlie <airlied@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_fence.c
@@ -1018,7 +1018,7 @@ int vmw_event_fence_action_create(struct
 	}
 
 
-	event = kzalloc(sizeof(event->event), GFP_KERNEL);
+	event = kzalloc(sizeof(*event), GFP_KERNEL);
 	if (unlikely(event == NULL)) {
 		DRM_ERROR("Failed to allocate an event.\n");
 		ret = -ENOMEM;


