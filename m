Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab2G3FuR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 01:50:17 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:45851 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab2G3FuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 01:50:15 -0400
Date: Sun, 29 Jul 2012 22:50:09 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Benson Leung <bleung@chromium.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: gpio_keys - Report wakeup events if device may
 wakeup
Message-ID: <20120730055009.GB5830@core.coreip.homeip.net>
References: <1343283113-16952-1-git-send-email-bleung@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343283113-16952-1-git-send-email-bleung@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Benson,

On Wed, Jul 25, 2012 at 11:11:53PM -0700, Benson Leung wrote:
> If a button is configured to wake the system, report a pm wakeup event.
> 

Thank you for your patch, however I applied more complete patch sent by
NeilBrown.

> Signed-off-by: Benson Leung <bleung@chromium.org>
> ---
>  drivers/input/keyboard/gpio_keys.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
> index cbb1add..15a80e2 100644
> --- a/drivers/input/keyboard/gpio_keys.c
> +++ b/drivers/input/keyboard/gpio_keys.c
> @@ -328,9 +328,13 @@ static void gpio_keys_gpio_report_event(struct gpio_button_data *bdata)
>  {
>  	const struct gpio_keys_button *button = bdata->button;
>  	struct input_dev *input = bdata->input;
> +	struct device *dev = input->dev.parent;
>  	unsigned int type = button->type ?: EV_KEY;
>  	int state = (gpio_get_value_cansleep(button->gpio) ? 1 : 0) ^ button->active_low;
>  
> +	if (button->wakeup && device_may_wakeup(dev))
> +		pm_wakeup_event(dev, 0);
> +
>  	if (type == EV_ABS) {
>  		if (state)
>  			input_event(input, type, button->code, button->value);
> -- 
> 1.7.7.3
> 

-- 
Dmitry
