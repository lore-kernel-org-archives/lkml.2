Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748Ab0LIL2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 06:28:38 -0500
Received: from mail-ww0-f66.google.com ([74.125.82.66]:62080 "EHLO
	mail-ww0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab0LIL2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 06:28:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=APON2z1dAU+lrDDdzWn2P6B1SetghDMKAP3lyfw21yBGk9LeAFp1TCOwnloQHxSVBw
         QSF7DwAIAG9bXkkEcU90vvO4hlfMD6swUzVlgebFugazBS5OlfmVPxO7vrpLw49RBFPR
         KJn6sPThu8AWU3KQs5rNvEzls2ejcpYgCiIHg=
Date: Thu, 9 Dec 2010 14:28:21 +0300
From: Dan Carpenter <error27@gmail.com>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Paul Mundt <lethal@linux-sh.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
        Tilman Sauerbeck <tilman@code-monkey.de>,
        kernel-janitors@vger.kernel.org
Subject: [patch] kgdb: strlen() doesn't count the terminator
Message-ID: <20101209112821.GU10623@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Jason Wessel <jason.wessel@windriver.com>,
	Paul Mundt <lethal@linux-sh.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
	Tilman Sauerbeck <tilman@code-monkey.de>,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an off by one because strlen() doesn't count the null
terminator.  We strcpy() these strings into an array of size
MAX_CONFIG_LEN.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index 59c118c..27dc463 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -988,7 +988,7 @@ static void kgdbts_run_tests(void)
 
 static int kgdbts_option_setup(char *opt)
 {
-	if (strlen(opt) > MAX_CONFIG_LEN) {
+	if (strlen(opt) >= MAX_CONFIG_LEN) {
 		printk(KERN_ERR "kgdbts: config string too long\n");
 		return -ENOSPC;
 	}
diff --git a/drivers/serial/kgdboc.c b/drivers/serial/kgdboc.c
index 3374618..ec1748b 100644
--- a/drivers/serial/kgdboc.c
+++ b/drivers/serial/kgdboc.c
@@ -130,7 +130,7 @@ static void kgdboc_unregister_kbd(void)
 
 static int kgdboc_option_setup(char *opt)
 {
-	if (strlen(opt) > MAX_CONFIG_LEN) {
+	if (strlen(opt) >= MAX_CONFIG_LEN) {
 		printk(KERN_ERR "kgdboc: config string too long\n");
 		return -ENOSPC;
 	}
