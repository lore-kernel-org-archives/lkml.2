Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab2JKPVh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 11:21:37 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63468 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab2JKPVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 11:21:34 -0400
Date: Thu, 11 Oct 2012 16:21:29 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org,
        Philippe Langlais <philippe.langlais@linaro.org>
Subject: Re: [PATCH 2/2] input: gpio-keys: Add runtime support
Message-ID: <20121011152129.GE15428@gmail.com>
References: <1349964927-18619-1-git-send-email-lee.jones@linaro.org>
 <1349964927-18619-2-git-send-email-lee.jones@linaro.org>
 <CAM=Q2ctwTBAvKs401GgrGfz9NvaLspquje-6YfnuS5TZYeqY4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM=Q2ctwTBAvKs401GgrGfz9NvaLspquje-6YfnuS5TZYeqY4Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > From: Jonas Aaberg <jonas.aberg@stericsson.com>
> Some change logs would have helped.

Granted.

Hopefully Jonas will be happy to step forward and answer any of
your following questions.

> > Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > Cc: linux-input@vger.kernel.org
> > Acked-by: Lee Jones <lee.jones@linaro.org>
> > Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
> > Signed-off-by: Philippe Langlais <philippe.langlais@linaro.org>
> > Reviewed-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> > ---
> >  drivers/input/keyboard/gpio_keys.c |   16 ++++++++++++----
> >  1 file changed, 12 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/input/keyboard/gpio_keys.c b/drivers/input/keyboard/gpio_keys.c
> > index 7947315..78de557 100644
> > --- a/drivers/input/keyboard/gpio_keys.c
> > +++ b/drivers/input/keyboard/gpio_keys.c
> > @@ -29,6 +29,7 @@
> >  #include <linux/of_platform.h>
> >  #include <linux/of_gpio.h>
> >  #include <linux/spinlock.h>
> > +#include <linux/pm_runtime.h>
> >
> >  struct gpio_button_data {
> >         const struct gpio_keys_button *button;
> > @@ -526,6 +527,7 @@ static int gpio_keys_open(struct input_dev *input)
> >  {
> >         struct gpio_keys_drvdata *ddata = input_get_drvdata(input);
> >
> > +       pm_runtime_get_sync(input->dev.parent);
> I am not an expert of the runtime.
> 
> However would be grateful if you explain me what it actually do.
> 
> Also I did not see any runtime suspend/ resume handlers populated.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
