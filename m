Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab2ICAam (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 20:30:42 -0400
Received: from server.atrad.com.au ([150.101.241.2]:59454 "EHLO
	server.atrad.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755134Ab2ICAal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 20:30:41 -0400
X-Greylist: delayed 413 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Sep 2012 20:30:40 EDT
Date: Mon, 3 Sep 2012 09:53:36 +0930
From: Jonathan Woithe <jwoithe@just42.net>
To: Davidlohr Bueso <dave@gnu.org>
Cc: platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, mjg@redhat.com
Subject: Re: [PATCH 4/5] platform: x86: remove acpi_bus_generate_proc_event
Message-ID: <20120903002336.GD25170@marvin.atrad.com.au>
References: <1346630611.3170.32.camel@offbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346630611.3170.32.camel@offbook>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 03, 2012 at 02:03:31AM +0200, Davidlohr Bueso wrote:
> Calling this function no longer makes sense as /proc/acpi/event
> is being removed.
> 
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> :
>  drivers/platform/x86/fujitsu-laptop.c   |    4 ----
> :
> diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
> index c4c1a54..2fac1c5 100644
> --- a/drivers/platform/x86/fujitsu-laptop.c
> +++ b/drivers/platform/x86/fujitsu-laptop.c
> @@ -773,8 +773,6 @@ static void acpi_fujitsu_notify(struct acpi_device *device, u32 event)
>  				else
>  					set_lcd_level(newb);
>  			}
> -			acpi_bus_generate_proc_event(fujitsu->dev,
> -				ACPI_VIDEO_NOTIFY_INC_BRIGHTNESS, 0);
>  			keycode = KEY_BRIGHTNESSUP;
>  		} else if (oldb > newb) {
>  			if (disable_brightness_adjust != 1) {
> @@ -783,8 +781,6 @@ static void acpi_fujitsu_notify(struct acpi_device *device, u32 event)
>  				else
>  					set_lcd_level(newb);
>  			}
> -			acpi_bus_generate_proc_event(fujitsu->dev,
> -				ACPI_VIDEO_NOTIFY_DEC_BRIGHTNESS, 0);
>  			keycode = KEY_BRIGHTNESSDOWN;
>  		}
>  		break;

Presumedly the intention here is for these events to be delivered via the
input layer after the removal of /proc/acpi/event (as is done later in the
above function).

If that's the case, then:
  Acked-by: Jonathan Woithe <jwoithe@just42.net>

Regards
  jonathan
