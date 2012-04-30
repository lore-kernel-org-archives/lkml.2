Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab2D3S0E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 14:26:04 -0400
Received: from smtprelay-b21.telenor.se ([195.54.99.212]:60080 "EHLO
	smtprelay-b21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756227Ab2D3S0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 14:26:02 -0400
X-SENDER-IP: [85.230.169.225]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjR8APXXnk9V5qnhPGdsb2JhbABEiiqlKIFhBIEaGQEBAQEeGQ0nggkBAQQBJxMcIwULCANGFCUKGogbCbo9E4shhQtjBJV9hgaNJw
X-IronPort-AV: E=Sophos;i="4.75,506,1330902000"; 
   d="scan'208";a="324233314"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 30 Apr 2012 20:30:23 +0200
To: Benjamin Tissoires <benjamin.tissoires@gmail.com>
Cc: Jiri Kosina <jkosina@suse.cz>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Tissoires <Benjamin_Tissoires@logitech.com>,
        Stephane Chatty <chatty@enac.fr>
Subject: Re: [PATCH v3 5/6] hid-multitouch: Switch to device groups
Message-ID: <20120430183023.GA5585@polaris.bitmath.org>
References: <1335175627-2270-1-git-send-email-rydberg@euromail.se>
 <1335175627-2270-6-git-send-email-rydberg@euromail.se>
 <CAN+gG=EWHi18kb1q2xQg8mfS9o6BHVLVdU+KYUcWdM4L3gJybA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN+gG=EWHi18kb1q2xQg8mfS9o6BHVLVdU+KYUcWdM4L3gJybA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I remarked a small regression in this patch: the detection of the
> serial protocol is not handled anymore. I was indeed relying on the
> fact that the parameter "id" in mt_probe was null to know that the
> device was not already in the list of known devices.

I see. Will this suffice?

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 125c1e7..507981e 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -673,8 +673,8 @@ static int mt_probe(struct hid_device *hdev, const struct hid_device_id *id)
        if (ret)
                goto fail;
 
-       if (!id && td->touches_by_report == 1) {
-               /* the device has been sent by hid-generic */
+       /* unknown serial devices need special quirks */
+       if ((!id || id->product == HID_ANY_ID) && td->touches_by_report == 1) {
                mtclass = &td->mtclass;
                mtclass->quirks |= MT_QUIRK_ALWAYS_VALID;
                mtclass->quirks &= ~MT_QUIRK_NOT_SEEN_MEANS_UP;

Cheers,
Henrik
