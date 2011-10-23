Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab1JWGeD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 02:34:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40008 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab1JWGeB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 02:34:01 -0400
X-Mailbox-Line: From gregkh@pistachio.kroah.org Sun Oct 23 08:25:39 2011
Message-Id: <20111023062539.025479749@pistachio.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Sun, 23 Oct 2011 08:24:39 +0200
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: stable-review@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Josh Boyer <jwboyer@redhat.com>
Subject: [11/27] [media] uvcvideo: Fix crash when linking entities
In-Reply-To: <20111023062833.GA8126@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

commit 4d9b2ebd335d83044b9e6656d0e604e8e1300334 upstream.

The uvc_mc_register_entity() function wrongfully selects the
media_entity associated with a UVC entity when creating links. This
results in access to uninitialized media_entity structures and can hit a
BUG_ON statement in media_entity_create_link(). Fix it.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Josh Boyer <jwboyer@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/uvc/uvc_entity.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/video/uvc/uvc_entity.c
+++ b/drivers/media/video/uvc/uvc_entity.c
@@ -49,7 +49,7 @@ static int uvc_mc_register_entity(struct
 		if (remote == NULL)
 			return -EINVAL;
 
-		source = (UVC_ENTITY_TYPE(remote) != UVC_TT_STREAMING)
+		source = (UVC_ENTITY_TYPE(remote) == UVC_TT_STREAMING)
 		       ? (remote->vdev ? &remote->vdev->entity : NULL)
 		       : &remote->subdev.entity;
 		if (source == NULL)


