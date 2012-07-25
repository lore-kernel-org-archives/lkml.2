Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933157Ab2GYOOw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 10:14:52 -0400
Received: from marvin.crapouillou.net ([109.190.31.181]:63305 "EHLO
	marvin.crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933060Ab2GYOOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 10:14:50 -0400
To: Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH 4/4] fbcon: optimize parameters parsing loop.
X-PHP-Originating-Script: 0:main.inc
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 25 Jul 2012 16:14:47 +0200
From: paul <paul@crapouillou.net>
Cc: <florianschandinat@gmx.de>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>
In-Reply-To: <1343091626-11435-4-git-send-email-paul@crapouillou.net>
References: <1343091626-11435-1-git-send-email-paul@crapouillou.net>
 <1343091626-11435-4-git-send-email-paul@crapouillou.net>
Message-ID: <a5605d66df852b08be6444bf94f6c0dc@mail.crapouillou.net>
User-Agent: Roundcube Webmail/0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 From 67cecd09d850542e00a1d9a29567232d1224cf23 Mon Sep 17 00:00:00 2001
 From: Paul Cercueil <paul@crapouillou.net>
Date: Thu, 12 Jan 2012 19:40:24 +0100
Subject: [PATCH 4/4] fbcon: optimize parameters parsing loop.


Signed-off-by: Paul Cercueil <paul@crapouillou.net>
---
  drivers/video/console/fbcon.c |    8 +++++++-
  1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/video/console/fbcon.c 
b/drivers/video/console/fbcon.c
index 9b83b75..1ecaf68 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -441,8 +441,10 @@ static int __init fb_console_setup(char *this_opt)
  		return 1;

  	while ((options = strsep(&this_opt, ",")) != NULL) {
-		if (!strncmp(options, "font:", 5))
+		if (!strncmp(options, "font:", 5)) {
  			strlcpy(fontname, options + 5, sizeof(fontname));
+			continue;
+		}

  		if (!strncmp(options, "scrollback:", 11)) {
  			char *k;
@@ -468,6 +470,7 @@ static int __init fb_console_setup(char *this_opt)
  			/* (k && *k): Check for garbage after the suffix */
  			if (ret || (k && *k))
  				pr_warn("fbcon: scrollback: incorrect value.\n");
+			continue;
  		}

  		if (!strncmp(options, "map:", 4)) {
@@ -484,6 +487,7 @@ static int __init fb_console_setup(char *this_opt)
  			} else {
  				pr_warn("fbcon: map: incorrect value.\n");
  			}
+			continue;
  		}

  		if (!strncmp(options, "vc:", 3)) {
@@ -513,6 +517,7 @@ static int __init fb_console_setup(char *this_opt)
  				fbcon_is_default = 0;
  			else
  				pr_warn("fbcon: vc: incorrect value.\n");
+			continue;
  		}

  		if (!strncmp(options, "rotate:", 7)) {
@@ -525,6 +530,7 @@ static int __init fb_console_setup(char *this_opt)
  			} else {
  				pr_warn("fbcon: rotate: incorrect value.\n");
  			}
+			continue;
  		}
  	}
  	return 1;
-- 
1.7.10.4

