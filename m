Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab1BOOlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 09:41:11 -0500
Received: from 89-230.252-81.static-ip.oleane.fr ([81.252.230.89]:43741 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124Ab1BOOlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 09:41:08 -0500
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Jiri Kosina <jkosina@suse.cz>, Stephane Chatty <chatty@lii-enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hidinput: kernel oops in out_cleanup in function hidinput_connect
Date: Tue, 15 Feb 2011 15:41:10 +0100
Message-Id: <1297780870-4006-1-git-send-email-benjamin.tissoires@enac.fr>
X-Mailer: git-send-email 1.7.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Goto out_cleanup infers a kernel oops: hidinput_disconnect calls
input_unregister_driver to all members of hid->inputs.
However, hidinput already has been added to hid->inputs even
though input_register_device was not called.

Signed-off-by: Benjamin Tissoires <benjamin.tissoires@enac.fr>
---
Hi,

while playing with hidinput_connect, I found this bug.

Cheers,
Benjamin

 drivers/hid/hid-input.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 7f552bf..f53911d 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -928,6 +928,7 @@ int hidinput_connect(struct hid_device *hid, unsigned int force)
 	return 0;
 
 out_cleanup:
+	list_del(&hidinput->list);
 	input_free_device(hidinput->input);
 	kfree(hidinput);
 out_unwind:
-- 
1.7.4

