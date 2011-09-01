Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab1IAW40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 18:56:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49215 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932634Ab1IAW4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 18:56:21 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Sep  1 15:53:31 2011
Message-Id: <20110901225331.122692921@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 01 Sep 2011 15:50:07 -0700
From: gregkh@suse.de
To: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, greg@kroah.com,
        David Herrmann <dh.herrmann@googlemail.com>,
        stable <stable@kernel.org>
Subject: [patch 5/8] Platform: Fix error path in samsung-laptop init
In-Reply-To: <20110901225401.GA26870@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

samsung_init() should not return success if not all devices are initialized.
Otherwise, samsung_exit() will dereference sdev NULL pointers and others.

Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/platform/x86/samsung-laptop.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -799,7 +799,7 @@ static int __init samsung_init(void)
 	sabi_iface = ioremap_nocache(ifaceP, 16);
 	if (!sabi_iface) {
 		pr_err("Can't remap %x\n", ifaceP);
-		goto exit;
+		goto error_no_signature;
 	}
 	if (debug) {
 		printk(KERN_DEBUG "ifaceP = 0x%08x\n", ifaceP);
@@ -851,7 +851,6 @@ static int __init samsung_init(void)
 	if (retval)
 		goto error_file_create;
 
-exit:
 	return 0;
 
 error_file_create:


