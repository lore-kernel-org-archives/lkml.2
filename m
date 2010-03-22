Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab0CVMJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 08:09:29 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:54321 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784Ab0CVMJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 08:09:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=DFJavA6maQXtYC2jIdiWQtFPlc6/pmnF979fDxgoEgqs8remYGwA+qVxhmMxnOln+3
         s/B1s4WPzJb+TtxROxTcByBlaqkljn1IfpsUPH0Wj4JmgVNqUKwhND/REVwpU0vJUvd4
         O+yhREKibxRb4lgXQqiw740c8OLAuH5hq055U=
Date: Mon, 22 Mar 2010 15:09:18 +0300
From: Dan Carpenter <error27@gmail.com>
To: Thomas Winischhofer <thomas@winischhofer.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Krzysztof Helt <krzysztof.h1@wp.pl>, Roel Kluin <roel.kluin@gmail.com>,
       Michal Januszewski <spock@gentoo.org>,
       Wu Zhangjin <wuzhangjin@gmail.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] sis: strcpy() => strlcpy()
Message-ID: <20100322120918.GG21571@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Thomas Winischhofer <thomas@winischhofer.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Krzysztof Helt <krzysztof.h1@wp.pl>,
	Roel Kluin <roel.kluin@gmail.com>,
	Michal Januszewski <spock@gentoo.org>,
	Wu Zhangjin <wuzhangjin@gmail.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are different size buffers (40 chars vs 16), we may as well be
cautious.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index a531a0f..559bf17 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -1845,7 +1845,7 @@ sisfb_get_fix(struct fb_fix_screeninfo *fix, int con, struct fb_info *info)
 
 	memset(fix, 0, sizeof(struct fb_fix_screeninfo));
 
-	strcpy(fix->id, ivideo->myid);
+	strlcpy(fix->id, ivideo->myid, sizeof(fix->id));
 
 	mutex_lock(&info->mm_lock);
 	fix->smem_start  = ivideo->video_base + ivideo->video_offset;
