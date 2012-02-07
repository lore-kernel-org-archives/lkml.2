Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756386Ab2BGMnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 07:43:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59759 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756245Ab2BGMng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 07:43:36 -0500
Date: Tue, 7 Feb 2012 13:43:31 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Przemo Firszt <przemo@firszt.eu>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, chris@cnpbagwell.com,
        pinglinux@gmail.com, linuxwacom-devel@lists.sourceforge.net,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: wacom: Fix invalid power_supply_powers calls
In-Reply-To: <b24d411c05c013317690ef4cec330c71.squirrel@webmail.firszt.eu>
Message-ID: <alpine.LNX.2.00.1202071342540.24127@pobox.suse.cz>
References: <1328481324-7241-1-git-send-email-przemo@firszt.eu>    <alpine.LNX.2.00.1202061326150.24127@pobox.suse.cz>    <d2139519eb66f9b7bfd8f56d3b4e2d96.squirrel@webmail.firszt.eu>    <alpine.LNX.2.00.1202061342090.24127@pobox.suse.cz>    <4F300F2C.9030308@goop.org>
 <b24d411c05c013317690ef4cec330c71.squirrel@webmail.firszt.eu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Feb 2012, przemo@firszt.eu wrote:

> >>>> Hmm, seems valid. How did you notice? Have you seen crashes because of
> >>>> wild pointers?
> >>> Hi Jiri,
> >>> Yes, the driver was unusable - 100% crashes during connection.
> >> Okay, I thought that'd be the case.
> >
> > Very sorry about that.  I don't have a device to test with, so I should
> > have reviewed the code extra carefully.
> >
> > Does the same bug apply to the Wii changes, which were of the same form?
> >
> Hi Jeremy,
> The wii code looks the same, so probably it's affected as well. Can you
> make a patch?
> 
> power_supply_powers call in wiimote driver:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blob;f=drivers/hid/hid-wiimote-core.c#l1229

I have now queued the patch below for the same pile as well.
Thanks for spotting it.


From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] HID: wiimote: fix invalid power_supply_powers call

Analogically to d7cb3dbd1 ("HID: wacom: Fix invalid power_supply_powers
calls"), fix also the same occurence in wiimote driver.

Reported-by: przemo@firszt.eu
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/hid/hid-wiimote-core.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-wiimote-core.c b/drivers/hid/hid-wiimote-core.c
index fc253b4..cac3589 100644
--- a/drivers/hid/hid-wiimote-core.c
+++ b/drivers/hid/hid-wiimote-core.c
@@ -1226,14 +1226,14 @@ static int wiimote_hid_probe(struct hid_device *hdev,
 	wdata->battery.type = POWER_SUPPLY_TYPE_BATTERY;
 	wdata->battery.use_for_apm = 0;
 
-	power_supply_powers(&wdata->battery, &hdev->dev);
-
 	ret = power_supply_register(&wdata->hdev->dev, &wdata->battery);
 	if (ret) {
 		hid_err(hdev, "Cannot register battery device\n");
 		goto err_battery;
 	}
 
+	power_supply_powers(&wdata->battery, &hdev->dev);
+
 	ret = wiimote_leds_create(wdata);
 	if (ret)
 		goto err_free;

-- 
Jiri Kosina
SUSE Labs
