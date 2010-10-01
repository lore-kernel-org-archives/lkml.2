Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756018Ab0JAUrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 16:47:31 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58067 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466Ab0JAUra convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 16:47:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=RLTafKABVRQv6M5cntqmILWdkdLOvvGr40YTYo7svxIRJYRw16GEWoHOWHTtK3BHDW
         Q2Zf0HGG3ugjklWl9nUtE5wZW1d1Ds9KvSnS9p4iyCtT8u8k3wl6DB8mjcUB31jtWptf
         Y2TphoB2F0yo3n3LFgZ9ZY+qYHg/k/d0HAgkY=
MIME-Version: 1.0
In-Reply-To: <1285931572-3592-1-git-send-email-sbalashanmugam@atheros.com>
References: <1285931572-3592-1-git-send-email-sbalashanmugam@atheros.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 1 Oct 2010 13:47:08 -0700
Message-ID: <AANLkTinjiJ6FyoAi4aP=8pr9EwV0wpV7LtwQx-hwaOFs@mail.gmail.com>
Subject: Re: [PATCH] Added firmware load patch to crap directory. This patch
 loads firmware from btusb when device is plugged in.
To: Bala Shanmugam <sbalashanmugam@atheros.com>
Cc: linux-wireless@vger.kernel.org, marcel@holtmann.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 1, 2010 at 4:12 AM, Bala Shanmugam
<sbalashanmugam@atheros.com> wrote:
> Disabled staging directory compilation for bt target.

Huh? This commit log message also is unrelated to the patch below,
please separate and submit two separate patches.

> Signed-off-by: Bala Shanmugam <sbalashanmugam@atheros.com>
> ---
>  Makefile                                  |    9 +-
>  crap/0003-btusb-Add-fw-load-support.patch |  424 +++++++++++++++++++++++++++++
>  2 files changed, 428 insertions(+), 5 deletions(-)
>  create mode 100644 crap/0003-btusb-Add-fw-load-support.patch
>
> diff --git a/Makefile b/Makefile
> index e2c594a..4505080 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -31,17 +31,16 @@ obj-$(CONFIG_COMPAT_NET_USB_MODULES) += drivers/net/usb/
>
>  obj-$(CONFIG_COMPAT_NETWORK_MODULES) += drivers/net/
>  obj-$(CONFIG_COMPAT_VAR_MODULES) +=  drivers/ssb/ drivers/misc/eeprom/
> -endif
> -
> -obj-$(CONFIG_COMPAT_BLUETOOTH) += net/bluetooth/
> -obj-$(CONFIG_COMPAT_BLUETOOTH_MODULES) += drivers/bluetooth/
> -
>
>  ifeq ($(CONFIG_STAGING_EXCLUDE_BUILD),)
>  obj-$(CONFIG_COMPAT_STAGING) += drivers/staging/ath6kl/
>  obj-$(CONFIG_COMPAT_STAGING) += drivers/staging/brcm80211/
>  endif
>
> +endif
> +
> +obj-$(CONFIG_COMPAT_BLUETOOTH) += net/bluetooth/
> +obj-$(CONFIG_COMPAT_BLUETOOTH_MODULES) += drivers/bluetooth/
>
>  else
>
> diff --git a/crap/0003-btusb-Add-fw-load-support.patch b/crap/0003-btusb-Add-fw-load-support.patch
> new file mode 100644
> index 0000000..2fc1abe
> --- /dev/null
> +++ b/crap/0003-btusb-Add-fw-load-support.patch

Actually I'd like to apply this patch to linux-next-pending/ not to
crap/ as you *did* post the patch upstream right? It just is not
getting applied yet for the reasons you stated.

> @@ -0,0 +1,424 @@
> +Reason for not yet publishing:

This not accurate, you did publish the patch, this goes into
linux-next-pending and you instead need a "Reason for not being merged
yet" or for adding it to the linux-next-pending/ directory.

> Marcel feels that Atheros sflash based BT device
> +doesn't follow bluetooth H:2 specification and HCI commands should be supported
> +in firmware if it is detected as bluetooth device. Using HCI command, firmware
> +should be loaded.
> +
> +In sfash based device we don't have enough memory to support HCI commands in firmware.
> +So load firmware from btusb when the device comes up.
> +

You should still ask the maintainer for an alternative, otherwise the
device unusable. Did you submit the patch first in [PATCH] form? If
not please submit the patch, all I saw as an RFC and no followup at
all.
