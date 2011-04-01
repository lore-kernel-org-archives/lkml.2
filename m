Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab1DAOYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 10:24:42 -0400
Received: from adelie.canonical.com ([91.189.90.139]:46309 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757196Ab1DAOY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 10:24:26 -0400
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH] v4l: subdev: initialize sd->internal_ops in v4l2_subdev_init
Date: Fri,  1 Apr 2011 11:24:17 -0300
Message-Id: <1301667857-5145-2-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301667857-5145-1-git-send-email-herton.krzesinski@canonical.com>
References: <1301667857-5145-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many v4l drivers currently don't initialize their struct v4l2_subdev
with zeros, so since the addition of internal_ops in commit 45f6f84, we
are at risk of random oopses when code in v4l2_device_register_subdev
tries to dereference sd->internal_ops->*, as can be shown by the report
at http://bugs.launchpad.net/bugs/745213

So make sure internal_ops is cleared in v4l2_subdev_init.

BugLink: http://bugs.launchpad.net/bugs/745213
Cc: <stable@kernel.org> # .38.x
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/media/video/v4l2-subdev.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/media/video/v4l2-subdev.c b/drivers/media/video/v4l2-subdev.c
index 0b80644..0f70c74 100644
--- a/drivers/media/video/v4l2-subdev.c
+++ b/drivers/media/video/v4l2-subdev.c
@@ -324,6 +324,7 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
 	sd->grp_id = 0;
 	sd->dev_priv = NULL;
 	sd->host_priv = NULL;
+	sd->internal_ops = NULL;
 #if defined(CONFIG_MEDIA_CONTROLLER)
 	sd->entity.name = sd->name;
 	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
-- 
1.7.1

