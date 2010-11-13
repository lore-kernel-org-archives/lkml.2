Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab0KMKHD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 05:07:03 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60567 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab0KMKG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 05:06:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=boKcbVe4p5wJVJI8ek4zd/v8CXNCXegvQrSUZI4ZeHb1TwIUkfr7tpOpYGqjevvln1
         6kl65tmbBLR+OgX3bzVT91QwMZleymKFh4d0R8oX082VHgm4YbLENA1yHaBfZUPBjPxn
         +flLn1ZPpqrVKPePDQDqXnedeeooCwgz9JzUs=
Date: Sat, 13 Nov 2010 13:06:38 +0300
From: Dan Carpenter <error27@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch 1/2] fbcmap: cleanup white space in fb_alloc_cmap()
Message-ID: <20101113100638.GA1795@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <20101027093716.GD6062@bicker>
 <20101105134018.2c11f283.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101105134018.2c11f283.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch.pl and Andrew Morton both complained about the indenting in
fb_alloc_cmap()

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/video/fbcmap.c b/drivers/video/fbcmap.c
index f53b9f1..a79b976 100644
--- a/drivers/video/fbcmap.c
+++ b/drivers/video/fbcmap.c
@@ -90,32 +90,38 @@ static const struct fb_cmap default_16_colors = {
 
 int fb_alloc_cmap(struct fb_cmap *cmap, int len, int transp)
 {
-    int size = len*sizeof(u16);
-
-    if (cmap->len != len) {
-	fb_dealloc_cmap(cmap);
-	if (!len)
-	    return 0;
-	if (!(cmap->red = kmalloc(size, GFP_ATOMIC)))
-	    goto fail;
-	if (!(cmap->green = kmalloc(size, GFP_ATOMIC)))
-	    goto fail;
-	if (!(cmap->blue = kmalloc(size, GFP_ATOMIC)))
-	    goto fail;
-	if (transp) {
-	    if (!(cmap->transp = kmalloc(size, GFP_ATOMIC)))
-		goto fail;
-	} else
-	    cmap->transp = NULL;
-    }
-    cmap->start = 0;
-    cmap->len = len;
-    fb_copy_cmap(fb_default_cmap(len), cmap);
-    return 0;
+	int size = len * sizeof(u16);
+
+	if (cmap->len != len) {
+		fb_dealloc_cmap(cmap);
+		if (!len)
+			return 0;
+
+		cmap->red = kmalloc(size, GFP_ATOMIC);
+		if (!cmap->red)
+			goto fail;
+		cmap->green = kmalloc(size, GFP_ATOMIC);
+		if (!cmap->green)
+			goto fail;
+		cmap->blue = kmalloc(size, GFP_ATOMIC);
+		if (!cmap->blue)
+			goto fail;
+		if (transp) {
+			cmap->transp = kmalloc(size, GFP_ATOMIC);
+			if (!cmap->transp)
+				goto fail;
+		} else {
+			cmap->transp = NULL;
+		}
+	}
+	cmap->start = 0;
+	cmap->len = len;
+	fb_copy_cmap(fb_default_cmap(len), cmap);
+	return 0;
 
 fail:
-    fb_dealloc_cmap(cmap);
-    return -ENOMEM;
+	fb_dealloc_cmap(cmap);
+	return -ENOMEM;
 }
 
 /**
