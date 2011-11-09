Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934262Ab1KJDXj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:23:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41950 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933986Ab1KJDXg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:23:36 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:07 2011
Message-Id: <20111109212707.854786850@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Herrmann <dh.herrmann@googlemail.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: [074/262] Platform: Fix error path in samsung-laptop init
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Herrmann <dh.herrmann@googlemail.com>

commit a7ea19926ffba86f373f6050a106cd162dbb9a78 upstream.

samsung_init() should not return success if not all devices are initialized.
Otherwise, samsung_exit() will dereference sdev NULL pointers and others.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Matthew Garrett <mjg@redhat.com>

---
 drivers/platform/x86/samsung-laptop.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -789,7 +789,7 @@ static int __init samsung_init(void)
 	sabi_iface = ioremap_nocache(ifaceP, 16);
 	if (!sabi_iface) {
 		pr_err("Can't remap %x\n", ifaceP);
-		goto exit;
+		goto error_no_signature;
 	}
 	if (debug) {
 		printk(KERN_DEBUG "ifaceP = 0x%08x\n", ifaceP);
@@ -841,7 +841,6 @@ static int __init samsung_init(void)
 	if (retval)
 		goto error_file_create;
 
-exit:
 	return 0;
 
 error_file_create:


