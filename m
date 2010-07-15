Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933835Ab0GOQ5Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 12:57:24 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:64063 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933757Ab0GOQ5V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 12:57:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qSkJvL0MwV8jN4A4Du9VJDRylN00dfKEAt5wPGBAPxpI449tEihl6j/56iR/upKB2T
         HjlL/K8wBmzthimfAoD1ONip1I5v3Xg0KmuKWxaf4AoC928o0H34E4Bsp7s3+21UcXU5
         CipHsNxPoWNxwb0mFRlW7KAXk8nmN/pvjp0IU=
Date: Thu, 15 Jul 2010 09:57:06 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: x0r <x0r@dv-life.ru>
Cc: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] hid: ACRUX game controller force feedback support
Message-ID: <20100715165706.GA20371@core.coreip.homeip.net>
References: <4C3E7850.2010802@dv-life.ru>
 <4C3ED9C4.5080800@jic23.retrosnub.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C3ED9C4.5080800@jic23.retrosnub.co.uk>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Jul 15, 2010 at 10:49:56AM +0100, Jonathan Cameron wrote:
> > +
> > +static int ax_probe(struct hid_device *hdev, const struct hid_device_id *id)
> > +{
> > +    int ret;
> > +
> > +    dev_dbg(&hdev->dev, "ACRUX HID hardware probe...");
> > +
> > +    ret = hid_parse(hdev);
> > +    if (ret) {
> > +        dev_err(&hdev->dev, "parse failed\n");
> > +        goto err;
> > +    }
> > +
> > +    ret = hid_hw_start(hdev, HID_CONNECT_DEFAULT&  ~HID_CONNECT_FF);
> > +    if (ret) {
> > +        dev_err(&hdev->dev, "hw start failed\n");
> > +        goto err;
> > +    }
> > +
> > +    axff_init(hdev);

Error handling for axff_init() too please.

> > 
> > --- a/drivers/hid/Kconfig
> > +++ b/drivers/hid/Kconfig
> > @@ -68,6 +68,21 @@
> >      ---help---
> >      Support for A4 tech X5 and WOP-35 / Trust 450L mice.
> > 
> > +config HID_ACRUX
> > +    tristate "ACRUX support" if EMBEDDED
> > +    depends on USB_HID
> > +    default !EMBEDDED
> > +    ---help---
> > +    Say Y here if you have ACRUX game controllers.
> > +
> > +config ACRUX_FF
> > +    bool "ACRUX force feedback support"
> > +    depends on HID_ACRUX
> > +    select INPUT_FF_MEMLESS
> > +    ---help---
> > +    Say Y here if you want to enable force feedback support for ACRUX
> > +    game controllers.
> > +

Why 2 separate CONFIG options? I do not see any special handling except
for force feedback control itself; doesn't the device work with vanilla
kernel (sans FF of course)?

I also have a string suspicion the file is indented with 4 spaces, please
make sure it is indented with tabs.

And since it is HID device please make sure you copy Jiri Kosina
(CCed).

Thanks.

-- 
Dmitry
