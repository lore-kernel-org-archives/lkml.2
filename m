Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227Ab1HaLts (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 07:49:48 -0400
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:50665 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755001Ab1HaLtr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 07:49:47 -0400
Subject: Re: [PATCH] leds: kill CONFIG_LEDS_CLASS option
From: Richard Purdie <rpurdie@rpsys.net>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, linux@arm.linux.org.uk,
        linus.walleij@linaro.org, arnd@arndb.de,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>
In-Reply-To: <CAK5ve-+J3hzVB=_b0AOJ-Q1LYewahVraMti=y=6AaQy3+iy+rg@mail.gmail.com>
References: <1314647628-21707-1-git-send-email-bryan.wu@canonical.com>
	 <alpine.LFD.2.00.1108291630020.20358@xanadu.home>
	 <1314653699.5939.299.camel@rex>
	 <CAK5ve-+J3hzVB=_b0AOJ-Q1LYewahVraMti=y=6AaQy3+iy+rg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 31 Aug 2011 12:49:01 +0100
Message-ID: <1314791341.5939.464.camel@rex>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-31 at 10:45 +0800, Bryan Wu wrote:
> On Tue, Aug 30, 2011 at 5:34 AM, Richard Purdie <rpurdie@rpsys.net> wrote:
> > On Mon, 2011-08-29 at 16:34 -0400, Nicolas Pitre wrote:
> >> On Tue, 30 Aug 2011, Bryan Wu wrote:
> >>
> >> > Almost all the new leds driver and trigger driver are depends on
> >> > CONFIG_LED_CLASS, so there is no such user with CONFIG_NEW_LEDS=y
> >> > and CONFIG_LED_CLASS=n. Moreover, lots of API functions in led-class.c
> >> > are very common and should be built-in when CONFIG_NEW_LEDS=y.
> >> >
> >> > Obviously, CONFIG_LEDS_CLASS is pointless. This patch kills it and
> >> > also updates defconfigs which contains CONFIG_LEDS_CLASS.
> >> >
> >> > Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> >> > ---
> >
> > Looking at the code I'm a little concerned to see the direction this is
> > going. There was originally a reason that there were two options, it was
> > related to being able to compile as much of the LED code as a module as
> > possible.
> >
> 
> I quite understand the original reason for 2 options, but I failed to
> see any user of CONFIG_NEW_LEDS=y and CONFIG_LEDS_CLASS=n.

Right, the intent was to support CONFIG_NEW_LEDS=y and
CONFIG_LEDS_CLASS=m and I believe that still should be possible.

> > It looks like commit 5ada28bf76752e33dce3d807bf0dfbe6d1b943ad changed
> > the tristate to a bool at which point the separate option obviously
> > becomes pointless.
> 
> Exactly, this patch added some function API which are used very widely
> as default LEDS driver behavior in some drivers.

Looking at that commit, its adds the code to leds-class.c and shouldn't
have needed to change the tristate to a bool. I know we discussed that
at the time and I think that part might have been unnecessary and just
accidentally committed. It could well be we can just revert that piece
of the patch.

> > Rather than accept the current direction and force everything builtin,
> > I'd much rather this code became modular capable again. There is no good
> > reason we should be forced to build everything into a kernel.
> >
> 
> OK, cool. I'd like to help and could you please also give some
> comments about my ledtrig-cpu driver in this patchset?

I looked at that code and in summary, I like it.

My main concerns are just around being able to build things as modules
and that cpu trigger effectively forces all of led triggers as being
built in. It would be possible to avoid that by having a function
pointer for the cpu activity function and only calling it when its not
NULL. The module removal would need to be a little careful but it
shouldn't be that difficult.

Cheers,

Richard

