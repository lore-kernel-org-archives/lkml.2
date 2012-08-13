Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab2HMHIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 03:08:44 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:54160 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250Ab2HMHIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 03:08:43 -0400
X-Sasl-enc: 75AczJedSVvWSBAXTnk6J3HJUVvcuPc2Jt1SmsxpGJpA 1344841722
Message-ID: <5028A7F9.4040304@ladisch.de>
Date: Mon, 13 Aug 2012 09:08:41 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH] firewire: core: feed /dev/random with devices' GUIDs
References: <5027CFA7.9000100@ladisch.de> <20120812235856.65e2c7d5@stein>
In-Reply-To: <20120812235856.65e2c7d5@stein>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> On Aug 12 Clemens Ladisch wrote:
>> Send the GUIDs of newly registered controllers and devices
>> to the /dev/random driver to help seed its pools.
>
> This looks good to me, almost.  Isn't the call in fw_card_add redundant?
> The local node's fw_device instance initializer feeds the same GUID,
> although a little bit later.

Oops, indeed.  Just drop that hunk:

--8<---------------------------------------------------------------->8--
firewire: core: feed /dev/random with devices' GUIDs

Send the GUIDs of newly registered controllers and devices
to the /dev/random driver to help seed its pools.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
---
 drivers/firewire/core-device.c |    3 +++
 1 file changed, 3 insertions(+), 0 deletions(-)

--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -32,6 +32,7 @@
 #include <linux/mod_devicetable.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/random.h>
 #include <linux/rwsem.h>
 #include <linux/slab.h>
 #include <linux/spinlock.h>
@@ -1066,6 +1067,8 @@ static void fw_device_init(struct work_struct *work)
 		device->config_rom_retries = 0;

 		set_broadcast_channel(device, device->generation);
+
+		add_device_randomness(&device->config_rom[3], 8);
 	}

 	/*
