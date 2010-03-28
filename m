Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab0C1LVb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 07:21:31 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:34260 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab0C1LV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 07:21:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=WPNEh54lcs1nyPFG3aMMhtSX1NA7/t//LbEloVhMGDdh4we/SIEEp6ByXvHTww0fR6
         AUMUADwr+prfk4JdM6dbWCyiWAxlCLusdPNYoYxmH8H0Em63yhNC8qQkMSlOl63cI/SY
         pusCFTaSKaCud6P7cHM7OeDGRgRuOPxwFmL/8=
Date: Sun, 28 Mar 2010 14:21:18 +0300
From: Dan Carpenter <error27@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
       Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] video/au0828: off by one bug
Message-ID: <20100328112118.GI5069@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Michael Krufky <mkrufky@linuxtv.org>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "AUVI_INPUT(tmp)" macro uses "tmp" as an index of an array with
AU0828_MAX_INPUT elements.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/media/video/au0828/au0828-video.c b/drivers/media/video/au0828/au0828-video.c
index dc67bc4..19a5773 100644
--- a/drivers/media/video/au0828/au0828-video.c
+++ b/drivers/media/video/au0828/au0828-video.c
@@ -1104,7 +1104,7 @@ static int vidioc_enum_input(struct file *file, void *priv,
 
 	tmp = input->index;
 
-	if (tmp > AU0828_MAX_INPUT)
+	if (tmp >= AU0828_MAX_INPUT)
 		return -EINVAL;
 	if (AUVI_INPUT(tmp).type == 0)
 		return -EINVAL;
