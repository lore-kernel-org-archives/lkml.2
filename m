Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab1DLOi5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 10:38:57 -0400
Received: from kroah.org ([198.145.64.141]:57844 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932406Ab1DLOiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:38:54 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:58 2011
Message-Id: <20110412143558.120103212@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:35:24 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alexander Strakh <strakh@ispras.ru>, Huang Shijie <shijie8@gmail.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: [095/105] [media] drivers/media/video/tlg2300/pd-video.c: Remove second mutex_unlock in pd_vidioc_s_fmt
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alexander Strakh <cromlehg@gmail.com>

commit a07500ef690fcbec76e879ee2093d7ca69883825 upstream.

Error path in file drivers/media/video/tlg2300/pd-video.c:
1. First mutex_unlock on &pd->lock in line 767 (in function that
   called from line 805)
2. Second in line  806

 805        pd_vidioc_s_fmt(pd, &f->fmt.pix);
 806        mutex_unlock(&pd->lock);

Found by Linux Device Drivers Verification Project

Signed-off-by: Alexander Strakh <strakh@ispras.ru>
Acked-by: Huang Shijie <shijie8@gmail.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/media/video/tlg2300/pd-video.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/media/video/tlg2300/pd-video.c
+++ b/drivers/media/video/tlg2300/pd-video.c
@@ -764,10 +764,8 @@ static int pd_vidioc_s_fmt(struct poseid
 	}
 	ret |= send_set_req(pd, VIDEO_ROSOLU_SEL,
 				vid_resol, &cmd_status);
-	if (ret || cmd_status) {
-		mutex_unlock(&pd->lock);
+	if (ret || cmd_status)
 		return -EBUSY;
-	}
 
 	pix_def->pixelformat = pix->pixelformat; /* save it */
 	pix->height = (context->tvnormid & V4L2_STD_525_60) ?  480 : 576;


