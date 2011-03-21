Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab1CUTCg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 15:02:36 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:48959 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752908Ab1CUTCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 15:02:33 -0400
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Mon, 21 Mar 2011 20:06:07 +0100
To: Benjamin Tissoires <benjamin.tissoires@enac.fr>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 5/5] hid-multitouch: migrate 3M PCT touch screens to
 hid-multitouch
Message-ID: <20110321190606.GA1792@polaris.bitmath.org>
References: <1300454876-5017-1-git-send-email-benjamin.tissoires@enac.fr>
 <1300454876-5017-6-git-send-email-benjamin.tissoires@enac.fr>
 <20110321090533.GE3784@polaris.bitmath.org>
 <AANLkTinAPFnHA=MWbb=Yu7U0AXrxHv2-95M=OequsAL7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinAPFnHA=MWbb=Yu7U0AXrxHv2-95M=OequsAL7@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 83.254.52.20
X-Scan-Result: No virus found in message 1Q1kMu-0002YF-8Z.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1Q1kMu-0002YF-8Z 8a143a3639b09e549fc4fbf7424eaade
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benjamin,

> I tested it against 3M1968. I'll try to have it again to make more testing.
> What symptoms do you have?

With the modification below, it works as expected, and you can add

    Reviewed-and-tested-by: Henrik Rydberg <rydberg@euromail.se>

Thanks!

Henrik

---

diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index 7684e96..0f5b89f 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -424,6 +424,8 @@ static int mt_event(struct hid_device *hid, struct hid_field *field,
 			break;
 
 		default:
+			if (td->last_field_index && field->index == td->last_field_index)
+				break;
 			/* fallback to the generic hidinput handling */
 			return 0;
 		}

