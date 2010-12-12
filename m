Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab0LLNQD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 08:16:03 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:45996 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab0LLNP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 08:15:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=JS4aRhyV+cPrgMgl4CWMWlYjPLiJC7AxXswe25ltZ2sI+tfjYg1s6TQS6PHQSfj1gg
         4ja87iYFPHb/51ITOihdduTfYsc6HgKFD8VUEH4z25QcE+37x7nzQl+mTjhSVspURVX9
         GGSddKxe1Hux0bOvDHAzOJig++/wP5jpmkIHI=
Date: Sun, 12 Dec 2010 21:15:50 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Chris Clayton <chris2553@googlemail.com>
Subject: [PATCH] bttv: fix mutex use before init
Message-ID: <20101212131550.GA2608@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

oops happen in bttv_open while locking uninitialized mutex fh->cap.vb_lock
add mutex_init before usage

Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
Tested-by: Chris Clayton <chris2553@googlemail.com>
---
 drivers/media/video/bt8xx/bttv-driver.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.orig/drivers/media/video/bt8xx/bttv-driver.c	2010-11-27 11:21:30.000000000 +0800
+++ linux-2.6/drivers/media/video/bt8xx/bttv-driver.c	2010-12-12 16:31:39.633333338 +0800
@@ -3291,6 +3291,8 @@ static int bttv_open(struct file *file)
 	fh = kmalloc(sizeof(*fh), GFP_KERNEL);
 	if (unlikely(!fh))
 		return -ENOMEM;
+
+	mutex_init(&fh->cap.vb_lock);
 	file->private_data = fh;
 
 	/*
