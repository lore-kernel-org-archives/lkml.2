Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760947Ab0J0LjO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 07:39:14 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53795 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab0J0LjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 07:39:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GnA9FoLxWJWgEoU7p9fyhiXE6jP4uY8KAeMpGYiXHKJCpzLYKNgsWl2pEbAJyMBeYH
         gi089GFKlG33JNp4ub8HhUVnkii9SJIewO/YeW+eeds+5swtPd+j+X8rm6OiQQ96L4tH
         1T0CVgOKg1FXoRbLlT7MJRNmVEoXSBWkW7Wqo=
MIME-Version: 1.0
In-Reply-To: <AANLkTikwo++xG7SXzNPwmZgU2jbdLiMr0Wi+vaxFqb7o@mail.gmail.com>
References: <AANLkTikwo++xG7SXzNPwmZgU2jbdLiMr0Wi+vaxFqb7o@mail.gmail.com>
Date: Wed, 27 Oct 2010 13:39:10 +0200
Message-ID: <AANLkTi=NcpzcUv8jx5_NYxxBp8y0F2-Uh8aCCacb-ZWN@mail.gmail.com>
Subject: Re: drivers/platform/x86: Backlight-Add-backlight-type-v2.patch
From: Corentin Chary <corentin.chary@gmail.com>
To: sedat.dilek@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>, platform-driver-x86@vger.kernel.org,
        DRI <dri-devel@lists.freedesktop.org>,
        Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        =?UTF-8?Q?Michel_D=C3=A4nzer?= <michel@daenzer.net>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 1:06 PM, Sedat Dilek <sedat.dilek@googlemail.com> wrote:
> Hi,
>
> while testing linux-next I wanted to reactivate the backlight type
> patches laying in my build-dir.
>
> Within 2.6.36-rcX cycle I had successfully tested the backlight type
> patch [1] with an additional patch for radeon by Michel (posted to
> dri-devel ML, see [2]).
>
> The main patch needs a little refreshing.
>
> v2: drivers/platform/x86/asus-laptop.c: Refreshed to fit linux-next
> (next-20101027)
>
>
> Kind Regards,
> - Sedat -
>
> [1] https://patchwork.kernel.org/patch/163971/
> [2] https://patchwork.kernel.org/patch/182352/
>

Hi,

I think rfkill has the same problem, on some platforms, the platform
driver will add a rfkill switch, but the network (wlan/wimax/whatever)
driver may also add one. AFAIK, the platform one is more likely to be
able to power down the device completly.

For the current patch, a common pattern seems to be : video/ -> RAW,
platform/ -> PLATFORM. Couldn't we make some guess by checking the
parent of the backlight instead of doing this by hand for every
drivers ?

Thanks,

-- 
Corentin Chary
http://xf.iksaif.net
