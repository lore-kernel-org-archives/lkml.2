Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933391Ab0EZHiG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 03:38:06 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:35746 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751820Ab0EZHiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 03:38:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=lYlG2jxFEYWbSeu/D2JFepAw9VhskppjXd4fLCRmISLvj0wKTSosKLl52YYhHz8nF/
         nDyR4W0NSfnsQyt47cdqTv8AakoRTBTd5alWzK6LVmo9TEdOUay/mpGTb2QQFp0hS1Hb
         ktab+xmVCFQWeGoFVlDd2uR43UQ4//1kY9qOQ=
MIME-Version: 1.0
From: Frank Pan <frankpzh@gmail.com>
Date: Wed, 26 May 2010 15:37:43 +0800
Message-ID: <AANLkTil5HfBzgN-3ttSOUfQXxssR06nyIl1UoC9-zCiA@mail.gmail.com>
Subject: [PATCH] A little bug in scrup, vt.c
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Alan Cox <alan@linux.intel.com>, Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings

The code uses vc->vc_cols instead of vc->vc_size_row by mistake, it
will cause half of the region which is going to clear remain
uncleared.
The issue happens in background consoles, so it's hard to observe.

Frank Pan

Signed-off-by: Frank Pan <frankpzh@gmail.com>
---
diff --git a/drivers/char/vt.c b/drivers/char/vt.c
index 2c5ebd4..f523383 100644
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -304,7 +304,7 @@ static void scrup(struct vc_data *vc, unsigned int
t, unsigned int b, int nr)
 	d = (u32 *)(vc->vc_origin + vc->vc_size_row * t);
 	s = (u32 *)(vc->vc_origin + vc->vc_size_row * (t + nr));
 	scr_memmovew(d, s, (b - t - nr) * vc->vc_size_row);
-	scr_memsetw(d + (b - t - nr) * vc->vc_cols, vc->vc_video_erase_char,
+	scr_memsetw(d + (b - t - nr) * vc->vc_size_row, vc->vc_video_erase_char,
 		    vc->vc_size_row * nr);
 }
