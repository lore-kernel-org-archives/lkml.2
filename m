Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829Ab0JEHts (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 03:49:48 -0400
Received: from senator.holtmann.net ([87.106.208.187]:56736 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757413Ab0JEHtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 03:49:46 -0400
Subject: Re: [PATCH] Added firmware load patch to crap directory.
From: Marcel Holtmann <marcel@holtmann.org>
To: Bala Shanmugam <sbalashanmugam@atheros.com>
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1286118002-2354-1-git-send-email-sbalashanmugam@atheros.com>
References: <1286118002-2354-1-git-send-email-sbalashanmugam@atheros.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 05 Oct 2010 09:46:43 +0200
Message-ID: <1286264803.17473.21.camel@aeonflux>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bala,

> This patch in crap directory enables btusb to load firmware 
> to device RAM when it is plugged in.
>  Signed-off-by: Bala Shanmugam <sbalashanmugam@atheros.com>
> ---
>  crap/0003-btusb-Add-fw-load-support.patch |  424 +++++++++++++++++++++++++++++
>  1 files changed, 424 insertions(+), 0 deletions(-)
>  create mode 100644 crap/0003-btusb-Add-fw-load-support.patch
> 
> diff --git a/crap/0003-btusb-Add-fw-load-support.patch b/crap/0003-btusb-Add-fw-load-support.patch
> new file mode 100644
> index 0000000..6642d6b
> --- /dev/null
> +++ b/crap/0003-btusb-Add-fw-load-support.patch
> @@ -0,0 +1,424 @@
> +Reason for not yet publishing: Marcel feels that Atheros sflash based BT device
> +doesn't follow bluetooth H:2 specification and HCI commands should be supported
> +in firmware if it is detected as bluetooth device. Using HCI command, firmware
> +should be loaded.
> +
> +In sflash based device there is not enough memory to support HCI commands in firmware.
> +So load firmware from btusb when the device comes up.

and why are you just not fixing this properly. You can have a custom
firmware loader with a different product ID. Load the firmware and then
on reset it brings it up with proper Bluetooth USB class identifiers.

Nothing demands that the firmware loading happens via HCI. You can
invent your own protocol easily. See bcm203x firmware loader driver that
has been around since the beginning of Bluetooth.

Regards

Marcel


