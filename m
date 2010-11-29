Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab0K2NmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 08:42:20 -0500
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:57379 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753822Ab0K2NmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 08:42:18 -0500
Message-ID: <4CF3AD99.9050400@euromail.se>
Date: Mon, 29 Nov 2010 14:41:45 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Philipp Merkel <mail@philmerk.de>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] hid: egalax: Rework to include Joojoo and Wetab support
References: <1291016612-25102-1-git-send-email-rydberg@euromail.se> <alpine.LNX.2.00.1011291248290.981@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1011291248290.981@pobox.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.64
X-Scan-Result: No virus found in message 1PN3zG-0002Nv-7A.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PN3zG-0002Nv-7A e0055dc7c69361b06ece1e9c55782e75
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2010 12:50 PM, Jiri Kosina wrote:

> On Mon, 29 Nov 2010, Henrik Rydberg wrote:
> 
>> Hi Jiri,
>>
>> This is the second version of this patchset, extended to also support
>> the Wetab. The input core changes aside, the patches provide exactly
>> the same changes, except for a better signal-to-noise value provided
>> by Phillip.
>>
>> The first patch is already in your tree, but provided for completeness
>> (the present set is against -rc3). The second patch no longer sets up
>> the events per packet, since it is handled during slots
>> initialization. The third and fourth patch are identical, the fifth
>> has that new value, and the sixth is further simplified by using the
>> new input core interface. The seventh patch adds support for the
>> Wetab.
>>
>> The driver has been tested succesfully on all three supported device
>> ids.
>>
>> Cheers,
>> Henrik
>>
>> Henrik Rydberg (7):
>>   hid: egalax: Use kzalloc
>>   hid: egalax: Setup input device manually (rev2)
>>   hid: egalax: Correct for device resolution report error (rev2)
>>   hid: egalax: Report zero as minimum pressure (rev2)
>>   hid: egalax: Add event filtering (rev3)
>>   hid: egalax: Convert to MT slots (rev2)
>>   hid: egalax: Add support for Wetab
>>
>>  drivers/hid/hid-core.c   |    1 +
>>  drivers/hid/hid-egalax.c |  129 +++++++++++++++++++---------------------------
>>  drivers/hid/hid-ids.h    |    1 +
>>  3 files changed, 56 insertions(+), 75 deletions(-)
> 
> From a quick look, it looks basically fine to me, thanks!
> 
> Just a very minor nit: it'd be nice to have the Kconfig help text entry 
> updated, as the eGalax driver now supports more than what is described 
> there.


Something like this, perhaps?

>From c6675000b59412b22f4f798de4268318e39b628c Mon Sep 17 00:00:00 2001
From: Henrik Rydberg <rydberg@euromail.se>
Date: Mon, 29 Nov 2010 14:40:11 +0100
Subject: [PATCH] hid: egalax: Document the newly supported models in Kconfig

Signed-off-by: Henrik Rydberg <rydberg@euromail.se>
---
 drivers/hid/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 3052e29..401acec 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -154,7 +154,8 @@ config HID_EGALAX
 	tristate "eGalax multi-touch panel"
 	depends on USB_HID
 	---help---
-	Support for the eGalax dual-touch panel.
+	Support for the eGalax dual-touch panels, including the
+	Joojoo and Wetab tablets.

 config HID_ELECOM

Thanks,
Henrik
