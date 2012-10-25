Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964935Ab2JYH5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 03:57:19 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:46142 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933743Ab2JYH5P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 03:57:15 -0400
Date: Thu, 25 Oct 2012 08:57:09 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org,
        Philippe Langlais <philippe.langlais@linaro.org>
Subject: Re: [PATCH 2/2] input: gpio-keys: Add runtime support
Message-ID: <20121025075709.GE971@gmail.com>
References: <1349964927-18619-1-git-send-email-lee.jones@linaro.org>
 <1349964927-18619-2-git-send-email-lee.jones@linaro.org>
 <CAM=Q2ctwTBAvKs401GgrGfz9NvaLspquje-6YfnuS5TZYeqY4Q@mail.gmail.com>
 <CACRpkdb+kWW903VD45i5s_LrZ2BKX=k6enGP2R9v2ptSRkvJ9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdb+kWW903VD45i5s_LrZ2BKX=k6enGP2R9v2ptSRkvJ9w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2012, Linus Walleij wrote:

> On Thu, Oct 11, 2012 at 4:22 PM, Shubhrajyoti Datta
> <omaplinuxkernel@gmail.com> wrote:
> 
> >> @@ -526,6 +527,7 @@ static int gpio_keys_open(struct input_dev *input)
> >>  {
> >>         struct gpio_keys_drvdata *ddata = input_get_drvdata(input);
> >>
> >> +       pm_runtime_get_sync(input->dev.parent);
> >
> > I am not an expert of the runtime.
> >
> > However would be grateful if you explain me what it actually do.
> 
> This increase the reference count of the runtime status container
> for the device. _sync makes sure it happens now.
> 
> Consult:
> Documentation/power/runtime_pm.txt
> 
> > Also I did not see any runtime suspend/ resume handlers populated.
> 
> It is not necessary to handle the power state at the driver level,
> it can just as well be handled by the voltage/power domain,
> or at the class, type or bus level.
> 
> But the individual driver has to notify the system upward if it
> needs to be powered on or when it may or must be relaxed.
>
> Yours,
> Linus Walleij

Friendly poke.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
