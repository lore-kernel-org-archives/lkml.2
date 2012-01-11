Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720Ab2AKCSS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 21:18:18 -0500
Received: from emcscan.emc.com.tw ([192.72.220.5]:50450 "EHLO
	emcscan.emc.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932437Ab2AKCSQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 21:18:16 -0500
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jan 2012 21:18:16 EST
From: JJ Ding <jj_ding@emc.com.tw>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, JJ Ding <dgdunix@gmail.com>
Subject: Re: [PATCH TRIVIAL 1/5] Input: keyboard: use macro module_platform_driver()
In-Reply-To: <CAMuHMdU1fv-Qx1dRstFjBkqcKswWCu34Hkeusk1vW3ReXB7CDA@mail.gmail.com>
References: <1321952446-7591-1-git-send-email-jj_ding@emc.com.tw> <1321952446-7591-2-git-send-email-jj_ding@emc.com.tw> <CAMuHMdWVedppkaO5sF4WH78e8rdVJKXJknFVEZQo+VD2Rxmk=A@mail.gmail.com> <CAMuHMdU1fv-Qx1dRstFjBkqcKswWCu34Hkeusk1vW3ReXB7CDA@mail.gmail.com>
User-Agent: Notmuch/0.10.2 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 11 Jan 2012 10:07:38 +0800
Message-ID: <87lipf9el1.fsf@emc.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Tue, 10 Jan 2012 21:57:08 +0100, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> On Tue, Jan 10, 2012 at 21:47, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> 
> And looking for platform_driver_probe() in recent changesets, I found
> a few more:
> 
> drivers/input/touchscreen/atmel-wm97xx.c atmel_wm97xx_probe
> drivers/input/touchscreen/mc13783_ts.c mc13783_ts_probe
> drivers/input/serio/at32psif.c psif_probe
> drivers/input/mouse/amimouse.c amimouse_probe
> 
> Interestingly, in drivers/input/misc/twl4030-pwrbutton.c you did make
> platform_driver.probe point to twl4030_pwrbutton_probe().
> But that one is also broken, as twl4030_pwrbutton_probe() is marked __init,
> which is no longer correct.
> 
> Still, setting up platform_driver.probe and removing __init from all probe
> functions is not the right thing to do, as this make (non-__init) kernel code
> size bigger, while none of these devices are hotpluggable and thus cannot
> appear after bootup. That's why we have platform_driver_probe() in the
> first place. So I think all of this should be reverted for non-hotpluggable
> drivers.

Thank you for explaining this.
I am sorry for the trouble.

jj

> Gr{oetje,eeting}s,
> 
>                         Geert
> 
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
> 
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                 -- Linus Torvalds
> 
