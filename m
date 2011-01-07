Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab1AGFMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 00:12:44 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:48757 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751748Ab1AGFMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 00:12:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=ACK//IRTJhwNqtiKQ2zJFW285ocUXS/Q2WLlINB+jEC6ek1Dv3yMGmSHNspMNJbR5U
         SCSXUPuZWwojyX382pT7Kw8VOJOUcXJw6TqbkaA0aGwMG4YYqQyH6w/7r/1a+A52XE9g
         ath+tylEAx4ERmJgYih8jWS+6p+sJ7qITjZjA=
Date: Fri, 7 Jan 2011 08:12:27 +0300
From: Dan Carpenter <error27@gmail.com>
To: Dave Airlie <airlied@redhat.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] vga_switcheroo: comparing too few characters in strncmp()
Message-ID: <20110107051227.GD1717@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Dave Airlie <airlied@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a copy-and-paste bug.  We should be comparing 4 characters here
instead of 3.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/gpu/vga/vga_switcheroo.c b/drivers/gpu/vga/vga_switcheroo.c
index d2d8543..e01cacb 100644
--- a/drivers/gpu/vga/vga_switcheroo.c
+++ b/drivers/gpu/vga/vga_switcheroo.c
@@ -346,11 +346,11 @@ vga_switcheroo_debugfs_write(struct file *filp, const char __user *ubuf,
 	if (strncmp(usercmd, "DIS", 3) == 0)
 		client_id = VGA_SWITCHEROO_DIS;
 
-	if (strncmp(usercmd, "MIGD", 3) == 0) {
+	if (strncmp(usercmd, "MIGD", 4) == 0) {
 		just_mux = true;
 		client_id = VGA_SWITCHEROO_IGD;
 	}
-	if (strncmp(usercmd, "MDIS", 3) == 0) {
+	if (strncmp(usercmd, "MDIS", 4) == 0) {
 		just_mux = true;
 		client_id = VGA_SWITCHEROO_DIS;
 	}
