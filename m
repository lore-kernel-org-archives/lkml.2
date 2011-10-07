Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569Ab1JGHje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 03:39:34 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:40562 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab1JGHjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 03:39:33 -0400
Subject: Re: [PATCH 2/2] leds: turn the blink_timer off before starting to
 blink
From: Johannes Berg <johannes@sipsolutions.net>
To: Antonio Ospite <ospite@studenti.unina.it>
Cc: Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1317938611-4418-3-git-send-email-ospite@studenti.unina.it>
References: <1317938611-4418-1-git-send-email-ospite@studenti.unina.it>
	 <1317938611-4418-3-git-send-email-ospite@studenti.unina.it>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Oct 2011 09:39:25 +0200
Message-ID: <1317973165.3988.3.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 22:03 +0000, Antonio Ospite wrote:
> Depending on the implementation of the hardware blinking function in
> blink_set(), the led can support hardware blinking for some values of
> delay_on and delay_off and fall-back to software blinking for some other
> values.
> 
> Turning off the blink_timer unconditionally before starting to blink
> make sure that a sequence like:
> 
>   OFF
>   hardware blinking
>   software blinking
>   hardware blinking
> 
> does not leave the software blinking timer active.
> 
> Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> ---
>  drivers/leds/led-class.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
> index 939f24a..a7f0b29 100644
> --- a/drivers/leds/led-class.c
> +++ b/drivers/leds/led-class.c
> @@ -266,6 +266,8 @@ void led_blink_set(struct led_classdev *led_cdev,
>                    unsigned long *delay_on,
>                    unsigned long *delay_off)
>  {
> +       del_timer_sync(&led_cdev->blink_timer);
> +
>         if (led_cdev->blink_set &&
>             !led_cdev->blink_set(led_cdev, delay_on, delay_off)) {
>                 led_cdev->blink_delay_on = *delay_on;

Makes sense, good catch!

Reviewed-by: Johannes Berg <johannes@sipsolutions.net>

johannes

