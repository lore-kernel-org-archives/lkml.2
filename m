Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932400Ab0DBLge (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 07:36:34 -0400
Received: from mail-bw0-f217.google.com ([209.85.218.217]:34917 "EHLO
	mail-bw0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932293Ab0DBLgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 07:36:25 -0400
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Apr 2010 07:36:24 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=iroC9hg1qZNV/TtbHbKIDB+ZnYLVMgb9RECRvcGeRCPJPXAWma56bCiD54f0iQ+z3Z
         8tEzyyR8GJLlZwDfRNT8vgPb3vzZeU96RZRuWWaTTpYWGHCvqJK5WB16D83f4O4xwmXu
         /kYIBypQOSus/3WG0oQa0i/ykkapY7+DH8yp0=
Date: Fri, 2 Apr 2010 14:30:10 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Hans Verkuil <hverkuil@xs4all.nl>,
       Srinivasa Deevi <srinivasa.deevi@conexant.com>,
       Trent Piepho <xyzzy@speakeasy.org>, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] cx231xx: improve error handling
Message-ID: <20100402113010.GK5265@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Srinivasa Deevi <srinivasa.deevi@conexant.com>,
	Trent Piepho <xyzzy@speakeasy.org>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -EINVAL if we don't find the control id.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/cx231xx/cx231xx-video.c b/drivers/media/video/cx231xx/cx231xx-video.c
index d4f546f..5a74ef8 100644
--- a/drivers/media/video/cx231xx/cx231xx-video.c
+++ b/drivers/media/video/cx231xx/cx231xx-video.c
@@ -1901,9 +1901,12 @@ static int radio_queryctrl(struct file *file, void *priv,
 	if (c->id < V4L2_CID_BASE || c->id >= V4L2_CID_LASTP1)
 		return -EINVAL;
 	if (c->id == V4L2_CID_AUDIO_MUTE) {
-		for (i = 0; i < CX231XX_CTLS; i++)
+		for (i = 0; i < CX231XX_CTLS; i++) {
 			if (cx231xx_ctls[i].v.id == c->id)
 				break;
+		}
+		if (i == CX231XX_CTLS)
+			return -EINVAL;
 		*c = cx231xx_ctls[i].v;
 	} else
 		*c = no_ctl;
