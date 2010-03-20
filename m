Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab0CTLS4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 07:18:56 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:46513 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab0CTLSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 07:18:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=rjQUuoorhC3ucxGYkOXXuA8OzZwNyFghKiyrL8Y4ZwHUJy/e4eD/fNxF0XP50mERxT
         lDMleebZoERPG77NsBHGJXqJZy7/GPljBVK4Q9gCLZ1zxYK3WwkpgdTZFwA5nns0fdoz
         s9kwOKsFAcL+6b9tdlcblaPmB3YybRHCdw9qE=
Date: Sat, 20 Mar 2010 14:18:43 +0300
From: Dan Carpenter <error27@gmail.com>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
       Matthew Garrett <mjg@redhat.com>,
       Thierry Reding <thierry.reding@avionic-design.de>,
       Emese Revfy <re.emese@gmail.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [patch] backlight: backlight_device_register() return ERR_PTR()
Message-ID: <20100320111843.GS5331@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>,
	Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>,
	Matthew Garrett <mjg@redhat.com>,
	Thierry Reding <thierry.reding@avionic-design.de>,
	Emese Revfy <re.emese@gmail.com>, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

backlight_device_register() returns a valid pointer or ERR_PTR() 
never NULL.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/video/backlight/adx_bl.c b/drivers/video/backlight/adx_bl.c
index b0624b9..c02b851 100644
--- a/drivers/video/backlight/adx_bl.c
+++ b/drivers/video/backlight/adx_bl.c
@@ -106,8 +106,8 @@ static int __devinit adx_backlight_probe(struct platform_device *pdev)
 	props.max_brightness = 0xff;
 	bldev = backlight_device_register(dev_name(&pdev->dev), &pdev->dev,
 					  bl, &adx_backlight_ops, &props);
-	if (!bldev) {
-		ret = -ENOMEM;
+	if (IS_ERR(bldev)) {
+		ret = PTR_ERR(bldev);
 		goto out;
 	}
 
