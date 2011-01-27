Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab1A0CMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 21:12:36 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35442 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257Ab1A0CMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 21:12:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=X+Lvm525qS4Q2F7GAdX5VoRMHxnayIE+ftERhxuPN9yqFtpYuHL8eKOeQYGb1WCMCp
         4LOGOkFKYKVgjgye2rYS7xO8YKcEizY0sWtVqklShx0t24XsQcbDIOTEbUJZPpVBgA4+
         XXWrolbiy5iT3m7Slva0rm8JaNfrSUJ+WrT04=
Date: Wed, 26 Jan 2011 18:12:27 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110127021227.GA29709@core.coreip.homeip.net>
References: <20110125164803.GA19701@core.coreip.homeip.net>
 <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com>
 <20110125205453.GA19896@core.coreip.homeip.net>
 <4D3F4804.6070508@redhat.com>
 <4D3F4D11.9040302@teksavvy.com>
 <20110125232914.GA20130@core.coreip.homeip.net>
 <20110126020003.GA23085@core.coreip.homeip.net>
 <4D403855.4050706@teksavvy.com>
 <4D40C3D7.90608@teksavvy.com>
 <4D40C551.4020907@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D40C551.4020907@teksavvy.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 08:07:29PM -0500, Mark Lord wrote:
> On 11-01-26 08:01 PM, Mark Lord wrote:
> > On 11-01-26 10:05 AM, Mark Lord wrote:
> >> On 11-01-25 09:00 PM, Dmitry Torokhov wrote:
> > ..
> >>> I wonder if the patch below is all that is needed...
> >>
> >> Nope. Does not work here:
> >>
> >> $ lsinput
> >> protocol version mismatch (expected 65536, got 65537)
> >>
> > 
> > Heh.. I just noticed something *new* in the bootlogs on my system:
> > 
> > kernel: Registered IR keymap rc-rc5-tv
> > udevd-event[6438]: run_program: '/usr/bin/ir-keytable' abnormal exit
> > kernel: input: i2c IR (Hauppauge) as /devices/virtual/rc/rc0/input7
> > kernel: ir-keytable[6439]: segfault at 8 ip 00000000004012d2 sp 00007fff6d43ca60
> > error 4 in ir-keytable[400000+7000]
> > kernel: rc0: i2c IR (Hauppauge) as /devices/virtual/rc/rc0
> > kernel: ir-kbd-i2c: i2c IR (Hauppauge) detected at i2c-0/0-0018/ir0 [ivtv i2c
> > driver #0]
> > 
> > That's udev invoking ir-keyboard when the ir-kbd-i2c kernel module is loaded,
> > and that is also ir-keyboard (userspace) segfaulting when run.
> 
> Note: I tried to capture an strace of ir-keyboard segfaulting during boot
> (as above), but doing so kills the system (hangs on boot).
> 
> The command from udev was: /usr/bin/ir-keytable -a /etc/rc_maps.cfg -s rc0

Does it die when you try to invoke the command by hand? Can you see
where?

-- 
Dmitry
