Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751710Ab0HRFPM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 01:15:12 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64001 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab0HRFO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 01:14:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=KFB1JeEyZQaxxVAaasVEoEq8qjkuMmptDLY6UArfuS9yTPeCn0XKdw6dDiJG4/DpH4
         nLdXjBgCWWJ150hg35lvIFCPNnc5PdP7vUJcrQ/wdUnTzCVbrJaI0HYwqOaZNtzcTkqQ
         JCbcfqXrTkA7qQux1LLk8H9vVb+Y77vImQTUw=
Date: Tue, 17 Aug 2010 22:14:38 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Input: fix faulty XXinput_* calls
Message-ID: <20100818051435.GA1583@core.coreip.homeip.net>
References: <20100812162218.GA21286@core.coreip.homeip.net>
 <AANLkTikj2kqifwYo1c47+9knVejny1bR=Oe5yOkAchCk@mail.gmail.com>
 <20100817143851.GW10432@buzzloop.caiaq.de>
 <20100817162625.GA13896@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100817162625.GA13896@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 09:26:25AM -0700, Dmitry Torokhov wrote:
> On Tue, Aug 17, 2010 at 04:38:51PM +0200, Daniel Mack wrote:
> > On Sat, Aug 14, 2010 at 11:52:13PM +0200, Geert Uytterhoeven wrote:
> > > On Thu, Aug 12, 2010 at 18:22, Dmitry Torokhov
> > > <dmitry.torokhov@gmail.com> wrote:
> > > > From: Daniel Mack <daniel@caiaq.de>
> > > >
> > > > They've been introduced by 987a6c02 ("Input: switch to input_abs_*()
> > > > access functions") and they appear to be some kind of debug left-over.
> > > >
> > > > [Dmitry Torokhov: these are my fault - I added XX prefixes in places where
> > > >  I wanted to do additional review of the code but failed to actually do
> > > >  that in these particular instances.]
> > > >
> > > > Signed-off-by: Daniel Mack <daniel@caiaq.de>
> > > > Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> > > > ---
> > > >
> > > >  drivers/input/joystick/amijoy.c  |    2 +-
> > > 
> > > Thanks, amijoy.c compiles now.
> > > 
> > > But hil_kbd.c still doesn't compile:
> > > 
> > > > diff --git a/drivers/input/keyboard/hil_kbd.c b/drivers/input/keyboard/hil_kbd.c
> > > > index ddd5afd..dcc86b9 100644
> > > > --- a/drivers/input/keyboard/hil_kbd.c
> > > > +++ b/drivers/input/keyboard/hil_kbd.c
> > > > @@ -235,7 +235,7 @@ static void hil_dev_handle_ptr_events(struct hil_dev *ptr)
> > > >                        if (val < input_abs_min(dev, ABS_X + i))
> > > >                                input_abs_set_min(dev, ABS_X + i, val);
> > > >                        if (val > input_abs_max(dev, ABS_X + i))
> > > 
> > > error: implicit declaration of function ‘input_abs_max’.
> > > 
> > > And indeed, input_abs_max() does not exist, while hil_kbd.c has 4 callers.
> > 
> > Sorry about that. hil_kbd wasn't built on my system with an
> > allmodconfig, as I just got to know. Below is a fix for this unfortunate
> > trouble.
> > 
> 
> I think there still a couple of spots need to be adjusted. How about
> this one? (Sorry for the silence, I'm in the middle of a vacation).

And still there were more issues (missing semicolons, I think they were
there for a long time as TABLET_AUTOADJUST is not normally defined). I
have a fix that makes hil_kbd.c compile in my tree and I will post a
pull request in a day or so.

Thanks.

-- 
Dmitry
