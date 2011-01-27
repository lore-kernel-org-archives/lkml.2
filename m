Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab1A0GiZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 01:38:25 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54168 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866Ab1A0GiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 01:38:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rnj9714ApcF5ripASIZlpSw3FtVbRBGEeQDGyPYyJpOdNuko/P+YnKsr+qJ6y6Ru6f
         yeroGNiiguf1QoSmTPc3icwzvhaW3OdIz3CvqFJ40i95I/SQ5UP9jY96kCU55Y6/UiKY
         WttdptAphhAEzaYDUcShvTNw66Suky9tU5b2s=
Date: Wed, 26 Jan 2011 22:38:15 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110127063815.GA29924@core.coreip.homeip.net>
References: <20110125205453.GA19896@core.coreip.homeip.net>
 <4D3F4804.6070508@redhat.com>
 <4D3F4D11.9040302@teksavvy.com>
 <20110125232914.GA20130@core.coreip.homeip.net>
 <20110126020003.GA23085@core.coreip.homeip.net>
 <4D403855.4050706@teksavvy.com>
 <4D40C3D7.90608@teksavvy.com>
 <4D40C551.4020907@teksavvy.com>
 <20110127021227.GA29709@core.coreip.homeip.net>
 <4D40E41D.2030003@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D40E41D.2030003@teksavvy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 10:18:53PM -0500, Mark Lord wrote:
> On 11-01-26 09:12 PM, Dmitry Torokhov wrote:
> > On Wed, Jan 26, 2011 at 08:07:29PM -0500, Mark Lord wrote:
> >> On 11-01-26 08:01 PM, Mark Lord wrote:
> >>> On 11-01-26 10:05 AM, Mark Lord wrote:
> >>>> On 11-01-25 09:00 PM, Dmitry Torokhov wrote:
> >>> ..
> >>>>> I wonder if the patch below is all that is needed...
> >>>>
> >>>> Nope. Does not work here:
> >>>>
> >>>> $ lsinput
> >>>> protocol version mismatch (expected 65536, got 65537)
> >>>>
> >>>
> >>> Heh.. I just noticed something *new* in the bootlogs on my system:
> >>>
> >>> kernel: Registered IR keymap rc-rc5-tv
> >>> udevd-event[6438]: run_program: '/usr/bin/ir-keytable' abnormal exit
> >>> kernel: input: i2c IR (Hauppauge) as /devices/virtual/rc/rc0/input7
> >>> kernel: ir-keytable[6439]: segfault at 8 ip 00000000004012d2 sp 00007fff6d43ca60
> >>> error 4 in ir-keytable[400000+7000]
> >>> kernel: rc0: i2c IR (Hauppauge) as /devices/virtual/rc/rc0
> >>> kernel: ir-kbd-i2c: i2c IR (Hauppauge) detected at i2c-0/0-0018/ir0 [ivtv i2c
> >>> driver #0]
> >>>
> >>> That's udev invoking ir-keyboard when the ir-kbd-i2c kernel module is loaded,
> >>> and that is also ir-keyboard (userspace) segfaulting when run.
> >>
> >> Note: I tried to capture an strace of ir-keyboard segfaulting during boot
> >> (as above), but doing so kills the system (hangs on boot).
> >>
> >> The command from udev was: /usr/bin/ir-keytable -a /etc/rc_maps.cfg -s rc0
> > 
> > Does it die when you try to invoke the command by hand? Can you see where?
> 
> 
> No, it does not seem to segfault when I unload/reload ir-kbd-i2c
> and then invoke it by hand with the same parameters.
> Quite possibly the environment is different when udev invokes it,
> and my strace attempt with udev killed the system, so no info there.
> 
> It does NOT segfault on the stock 2.6.37 kernel, without the patch.

I must admit I am baffled. The patch in question only affects the
EVIOCGKEYCODE path whereas '-a' means "automatically load appropriate
keymap" and as far as I can see it does not call EVIOCGKEYCODE, only
EVIOCSKEYCODE...

Mauro, any ideas?

BTW, I wonder what package ir-keytable is coming from? Ubuntu seems to
have v4l-utils at 0.8.1-2 and you say yours is 0.8.2...

Thanks.

-- 
Dmitry
