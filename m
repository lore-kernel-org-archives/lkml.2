Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab1EGTLA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 15:11:00 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65300 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754973Ab1EGTK4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 15:10:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=txVcGHHkpgkbNc1DtXu+8dU6tm4MbYwQocVcjCMckQftltLq9lhTfysF4aQYdumjf+
         BDIOrhCSBNMCE0DA1vfa7XF8MCUDoz/c2aa2+JOhkfACacjfdggYPx8GdTCBDyM7P9Sn
         e4cIJCssag5pxmJih1rXqTpbsu4yVEruA/p5Q=
MIME-Version: 1.0
In-Reply-To: <20110504091619.GV2092@atomide.com>
References: <1304363786-30376-1-git-send-email-linus.walleij@stericsson.com>
	<20110504091619.GV2092@atomide.com>
Date: Sat, 7 May 2011 22:10:56 +0300
Message-ID: <BANLkTimrGP1ohGX1B4teaNMbgVjSb5Mw5Q@mail.gmail.com>
Subject: Re: [PATCH 1/4] drivers: create a pinmux subsystem
From: Mike Rapoport <mike.rapoport@gmail.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 4, 2011 at 12:16 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Linus Walleij <linus.walleij@stericsson.com> [110502 12:13]:
>
> Good to see this, looks like this should work for omaps too.
>
> The numbering solves the issue where we have multiple
> pinmux domains (base + offset for each domain).
>
> Then I would assume that for most cases the pin access can be
> described with:
>
> unsigned long pinmux_base;      /* Can have multiple pinux domains */
> u16 pinmux_reg_offset;          /* Register offset from pinmux_base */
> u16 flags;                      /* Register width etc */
>
> Which can be accessed with read[bwl] and write[bwl], so we
> can have default access functions in the pinux framework and
> don't necessarily have to implement them for each platform.

On some platforms setting the pin configuration won't require to keep
that lot of data, see, e.g. Orion and it's successors.

> Does this work for you? If so, then we can have the data in the
> same format for all the architectures for devicetree.
>
> And then we can have pin_get and pin_set functions, so platforms
> can implement their custom flags like wake-up trigger etc with
> just read[bwl] and write[bwl].
>
> Also noticed one typo:
>
>> +/* Plobal array of descriptors, one for each physical pin */
>> +static DEFINE_SPINLOCK(pin_desc_lock);
>> +static struct pin_desc pin_desc[MACH_NR_PINS];
>
> s/Plobal/Global/
>
> Regards,
>
> Tony
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
    Sincerely Yours,
        Mike.
