Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756947Ab2BNPlU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 10:41:20 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65327 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755387Ab2BNPlQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 10:41:16 -0500
MIME-Version: 1.0
In-Reply-To: <1329230917-27567-1-git-send-email-danny.kukawka@bisect.de>
References: <1329230917-27567-1-git-send-email-danny.kukawka@bisect.de>
Date: Tue, 14 Feb 2012 10:41:15 -0500
Message-ID: <CAKPrQY8ffK4W7+bCFMKUajfSb5jGrHxcX3ceEQoQOFvAuUAzoA@mail.gmail.com>
Subject: Re: [PATCH] bcm: move DRIVER_HALT into enum LedEvents
From: Kevin McKinney <klmckinney1@gmail.com>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Danny Kukawka <dkukawka@suse.de>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Danny,

On Tue, Feb 14, 2012 at 9:48 AM, Danny Kukawka <danny.kukawka@bisect.de> wrote:
> Move DRIVER_HALT into enum LedEvents to fix:
> drivers/staging/bcm/led_control.c: In function ‘LEDControlThread’:
> drivers/staging/bcm/led_control.c:817:3: warning: case value ‘255’
>  not in enumerated type ‘LedEventInfo_t’ [-Wswitch]
>
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  drivers/staging/bcm/led_control.h |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/staging/bcm/led_control.h b/drivers/staging/bcm/led_control.h
> index 0711ac2..57c8c45 100644
> --- a/drivers/staging/bcm/led_control.h
> +++ b/drivers/staging/bcm/led_control.h
> @@ -63,12 +63,10 @@ typedef enum LedEvents {
>        IDLEMODE_CONTINUE = 0x40,
>        IDLEMODE_EXIT = 0x80,
>        LED_THREAD_INACTIVE = 0x100,  //Makes the LED thread Inactivce. It wil be equivallent to putting the thread on hold.
> -       LED_THREAD_ACTIVE = 0x200    //Makes the LED Thread Active back.
> +       LED_THREAD_ACTIVE = 0x200,    /*Makes the LED Thread Active back*/
> +       DRIVER_HALT = 0xff
>  } LedEventInfo_t;                      /*Enumerated values of different driver states*/
>
> -#define DRIVER_HALT 0xff
> -
> -
A patch to fix this issue has already been submitted and applied.

Thanks,
Kevin
