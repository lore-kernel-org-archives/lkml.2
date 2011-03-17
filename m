Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab1CQBlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 21:41:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab1CQBlK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 21:41:10 -0400
Date: Wed, 16 Mar 2011 21:40:59 -0400
From: Dave Jones <davej@redhat.com>
To: gregkh@suse.de
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: fix reversed memset arguments in hv_mouse
Message-ID: <20110317014059.GA31086@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, gregkh@suse.de,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

size is 3rd arg, not the 2nd.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
index 50147f8..cbe5686 100644
--- a/drivers/staging/hv/hv_mouse.c
+++ b/drivers/staging/hv/hv_mouse.c
@@ -374,7 +374,7 @@ static void MousevscOnReceiveDeviceInfo(struct mousevsc_dev *InputDevice, struct
 	       desc->desc[0].wDescriptorLength);
 
 	/* Send the ack */
-	memset(&ack, sizeof(struct mousevsc_prt_msg), 0);
+	memset(&ack, 0, sizeof(struct mousevsc_prt_msg));
 
 	ack.type = PipeMessageData;
 	ack.size = sizeof(struct synthhid_device_info_ack);
@@ -595,7 +595,7 @@ static int MousevscConnectToVsp(struct hv_device *Device)
 	/*
 	 * Now, initiate the vsc/vsp initialization protocol on the open channel
 	 */
-	memset(request, sizeof(struct mousevsc_prt_msg), 0);
+	memset(request, 0, sizeof(struct mousevsc_prt_msg));
 
 	request->type = PipeMessageData;
 	request->size = sizeof(struct synthhid_protocol_request);
