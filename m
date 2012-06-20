Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab2FTD1z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 23:27:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55503 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab2FTD1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 23:27:54 -0400
Message-ID: <4FE14333.6020209@canonical.com>
Date: Wed, 20 Jun 2012 11:27:47 +0800
From: Alex Hung <alex.hung@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Alex Hung <alex.hung@canonical.com>
CC: corentincj@iksaif.net, mjg@redhat.com,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] eeepc-wmi: change wireless key event to toggle all wireless
 devices.
References: <1340162788-531-1-git-send-email-alex.hung@canonical.com>
In-Reply-To: <1340162788-531-1-git-send-email-alex.hung@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

This patch needs to work with another fix in net/rfkill/core.c

http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next.git;a=commit;h=27e49ca95570c4685a32be9d4664f2b0b6d89368

On 06/20/2012 11:26 AM, Alex Hung wrote:
> The original key event from Fn+F2 hotkey only toggles the state of wireless
> LAN and leaves other wireless devices such as bluetooth uncontrolled. This
> fix change Fn+F2 to generate an event to toggle all wireless devices.
>
> Signed-off-by: Alex Hung<alex.hung@canonical.com>
> ---
>   drivers/platform/x86/eeepc-wmi.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/platform/x86/eeepc-wmi.c b/drivers/platform/x86/eeepc-wmi.c
> index 5568c43..ef361fc 100644
> --- a/drivers/platform/x86/eeepc-wmi.c
> +++ b/drivers/platform/x86/eeepc-wmi.c
> @@ -68,7 +68,7 @@ static const struct key_entry eeepc_wmi_keymap[] = {
>   	{ KE_KEY, 0x31, { KEY_VOLUMEDOWN } },
>   	{ KE_KEY, 0x32, { KEY_MUTE } },
>   	{ KE_KEY, 0x5c, { KEY_F15 } }, /* Power Gear key */
> -	{ KE_KEY, 0x5d, { KEY_WLAN } },
> +	{ KE_KEY, 0x5d, { KEY_RFKILL } },
>   	{ KE_KEY, 0x6b, { KEY_TOUCHPAD_TOGGLE } }, /* Toggle Touchpad */
>   	{ KE_KEY, 0x82, { KEY_CAMERA } },
>   	{ KE_KEY, 0x83, { KEY_CAMERA_ZOOMIN } },

