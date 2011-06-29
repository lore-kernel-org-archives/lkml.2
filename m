Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581Ab1F2O01 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:26:27 -0400
Received: from adelie.canonical.com ([91.189.90.139]:54590 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383Ab1F2O0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:26:23 -0400
Message-ID: <4E0B360B.5050600@canonical.com>
Date: Wed, 29 Jun 2011 22:26:19 +0800
From: Ike Panhc <ike.pan@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Keng-Yu Lin <kengyu@canonical.com>
CC: Matthew Garrett <mjg@redhat.com>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, vanhoof@canonical.com,
        kent.lin@canonical.com, sylee@canonical.com
Subject: Re: [PATCH 1/2] ideapad-laptop: Ignore an unused VPC notification
References: <1309268154-6872-1-git-send-email-kengyu@canonical.com>
In-Reply-To: <1309268154-6872-1-git-send-email-kengyu@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2011 09:35 PM, Keng-Yu Lin wrote:
> BIOS fires notifications in a constant period with VPC bit 1 set when the
> power cord is unplugged.
> 
> This event is not known yet to have any effect, but it makes the
> call to sparse_keymap_report_event() and generates many KEY_UNKNOWNs.
> 
> This causes the userspace (Gnome Power Manager in my case) unable
> to enter the idle mode. As the result there is no screensaver showing up,
> no dim backlight, etc.
> 
> Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
> ---
>  drivers/platform/x86/ideapad-laptop.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
> index bfdda33..820f013 100644
> --- a/drivers/platform/x86/ideapad-laptop.c
> +++ b/drivers/platform/x86/ideapad-laptop.c
> @@ -463,7 +463,8 @@ static void ideapad_acpi_notify(struct acpi_device *adevice, u32 event)
>  				ideapad_sync_rfk_state(adevice);
>  			else if (vpc_bit == 4)
>  				read_ec_data(handle, 0x12, &vpc2);
> -			else
> +			else if (vpc_bit == 1) {
> +			} else
>  				ideapad_input_report(priv, vpc_bit);
>  		}
>  	}

So far I know this event (coming with vpc_bit=1) is for Lenovo PM utility
on Windows. For most of the machine this event is not implemented in BIOS.

Its ok that we just ignore the event.

I think it will be better if we can let sparse-keymap or any upper level
application to ignore all unknown scancode or KEY_UNKNOWN but so far I do
not know a better way then this patch.

