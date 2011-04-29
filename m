Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612Ab1D2TFE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:05:04 -0400
Received: from kroah.org ([198.145.64.141]:50309 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933156Ab1D2S6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:30 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:55 2011
Message-Id: <20110429185655.361581598@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:55:52 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ike Panhc <ike.pan@canonical.com>, Matthew Garrett <mjg@redhat.com>
Subject: [29/55] ideapad: read brightness setting on brightness key notify
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ike Panhc <ike.pan@canonical.com>

commit 2165136585b5c7d6f118f1d90fbde550bb7de212 upstream.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=25922

On ideapad Y530, the brightness key notify will be blocked if the last notify
is not responsed by getting the brightness value. Read value when we get the
notify shall fix the problem and will not have any difference on other ideapads.

Signed-off-by: Ike Panhc <ike.pan@canonical.com>
Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/ideapad-laptop.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -459,6 +459,8 @@ static void ideapad_acpi_notify(struct a
 		if (test_bit(vpc_bit, &vpc1)) {
 			if (vpc_bit == 9)
 				ideapad_sync_rfk_state(adevice);
+			else if (vpc_bit == 4)
+				read_ec_data(handle, 0x12, &vpc2);
 			else
 				ideapad_input_report(priv, vpc_bit);
 		}


