Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab2APSuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:50:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:43088 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756575Ab2APSt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:49:59 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 16 10:45:17 2012
Message-Id: <20120116184517.406491648@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Mon, 16 Jan 2012 10:44:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Rene Bolldorf <xsecute@googlemail.com>,
        Matthew Garrett <mjg@redhat.com>, Jonathan Nieder <jrnieder@gmail.com>
Subject: [19/48] [PATCH] ideapad: Check if acpi already handle backlight power to avoid a page fault
In-Reply-To: <20120116184527.GA11972@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rene Bollford <xsecute@googlemail.com>

commit d4afc7754a60b885b63ef23fd194984e2d53a4e6 upstream.

This patch avoid a page fault in the ideapad-laptop extras when
turning the backlight power on or off.

Signed-off-by: Rene Bolldorf <xsecute@googlemail.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Tested-by: Artem X <artem.brz@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/ideapad-laptop.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -493,6 +493,8 @@ static void ideapad_backlight_notify_pow
 	unsigned long power;
 	struct backlight_device *blightdev = priv->blightdev;
 
+	if (!blightdev)
+		return;
 	if (read_ec_data(ideapad_handle, 0x18, &power))
 		return;
 	blightdev->props.power = power ? FB_BLANK_UNBLANK : FB_BLANK_POWERDOWN;


