Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab0DBLjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 07:39:00 -0400
Received: from mail-bw0-f217.google.com ([209.85.218.217]:39349 "EHLO
	mail-bw0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371Ab0DBLiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 07:38:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=aqVm3RrrkHcHI8YCudboXuuF6xY/pviCSyU220VbdxLP/2aGNnHuN0UXU1mENZB+bF
         zIko/gC4WSksOFQ8BKqxN/lDYjg0N0nSg9YlqXSm5g5wfnQAIJfsm7isCkUSsQokorn5
         SwC77U2LuZrDsnBBFUgiX2JON9Q04HBsXRHOY=
Date: Fri, 2 Apr 2010 14:31:50 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Devin Heitmueller <dheitmueller@kernellabs.com>,
       linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] cx88: improve error handling
Message-ID: <20100402113150.GL5265@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -EINVAL if we don't find the right query control id.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/cx88/cx88-video.c b/drivers/media/video/cx88/cx88-video.c
index 48c450f..b4c80cb 100644
--- a/drivers/media/video/cx88/cx88-video.c
+++ b/drivers/media/video/cx88/cx88-video.c
@@ -1537,9 +1537,12 @@ static int radio_queryctrl (struct file *file, void *priv,
 		c->id >= V4L2_CID_LASTP1)
 		return -EINVAL;
 	if (c->id == V4L2_CID_AUDIO_MUTE) {
-		for (i = 0; i < CX8800_CTLS; i++)
+		for (i = 0; i < CX8800_CTLS; i++) {
 			if (cx8800_ctls[i].v.id == c->id)
 				break;
+		}
+		if (i == CX8800_CTLS)
+			return -EINVAL;
 		*c = cx8800_ctls[i].v;
 	} else
 		*c = no_ctl;
