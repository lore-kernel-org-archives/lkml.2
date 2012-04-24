Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496Ab2DXIpL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 04:45:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44562 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756043Ab2DXIpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 04:45:05 -0400
Message-ID: <4F966802.10907@canonical.com>
Date: Tue, 24 Apr 2012 16:44:50 +0800
From: Alex Hung <alex.hung@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alex Hung <alex.hung@canonical.com>
CC: ibm-acpi@hmh.eng.br, mjg@redhat.com, ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ibm-acpi-devel] [PATCH] thinkpad-acpi: fix issuing duplicated
 key events for brightness up/down
References: <1335256852-19146-1-git-send-email-alex.hung@canonical.com>
In-Reply-To: <1335256852-19146-1-git-send-email-alex.hung@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 04:40 PM, Alex Hung wrote:
> The tp_features.bright_acpimode will not be set correctly for brightness
> control because ACPI_VIDEO_HID will not be located in ACPI. As a result,
> a duplicated key event will always be sent. acpi_video_backlight_support()
> is sufficient to detect standard ACPI brightness control.
>
> Signed-off-by: Alex Hung<alex.hung@canonical.com>
> ---
>   drivers/platform/x86/thinkpad_acpi.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
> index 7b82868..7d032d5 100644
> --- a/drivers/platform/x86/thinkpad_acpi.c
> +++ b/drivers/platform/x86/thinkpad_acpi.c
> @@ -3405,7 +3405,7 @@ static int __init hotkey_init(struct ibm_init_struct *iibm)
>   	/* Do not issue duplicate brightness change events to
>   	 * userspace. tpacpi_detect_brightness_capabilities() must have
>   	 * been called before this point  */
> -	if (tp_features.bright_acpimode&&  acpi_video_backlight_support()) {
> +	if (acpi_video_backlight_support()) {
>   		pr_info("This ThinkPad has standard ACPI backlight "
>   			"brightness control, supported by the ACPI "
>   			"video driver\n");

Hi,
I tested the patch on thinkpad x200 and x220, and the brightness up/down 
key presses will no longer generate a duplicated event, i.e. output from 
"sudo showkey".

Best Regards,
Alex Hung
