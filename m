Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965682Ab2EXViV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:38:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41749 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965637Ab2EXViT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:38:19 -0400
Date: Thu, 24 May 2012 14:38:13 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [git pull] Input updates for 3.5-rc0
Message-ID: <20120524213813.GA17452@core.coreip.homeip.net>
References: <20120524083216.GD10562@core.coreip.homeip.net>
 <CA+55aFxw0HRpizzJZxhhA2oqPpzg4DPUvH2r7YoYfctXS6K=WQ@mail.gmail.com>
 <20120524180154.GA15036@core.coreip.homeip.net>
 <CA+55aFx0ww=BtYAj9WEbqMT2R30ZZpjd014cYCpC=b+HRtUf_A@mail.gmail.com>
 <20120524195851.GA15306@core.coreip.homeip.net>
 <CA+55aFxX+xidcuVXb1h4oFTemtHo+ANECaoOw=vxtKN231N+cA@mail.gmail.com>
 <20120524203647.GA16024@core.coreip.homeip.net>
 <CA+55aFz9Fp2J=oCkoDAwNTnEJoBeKC9tn+5dqMCKf4C22CAi6Q@mail.gmail.com>
 <20120524205952.GA16621@core.coreip.homeip.net>
 <CA+55aFybQDXjGaEK0k=60gS88bxwE8vC7XvOffaQAf3de9cCfg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFybQDXjGaEK0k=60gS88bxwE8vC7XvOffaQAf3de9cCfg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 02:07:29PM -0700, Linus Torvalds wrote:
> On Thu, May 24, 2012 at 1:59 PM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> >
> > I was concerned about the _next_ device (the one that will be created
> > the moment I plug in the tablet back into the same port) having exact
> > same name as the one that is half dead and clashing in sysfs and
> > elsewhere. We used to have issues with this.
> 
> Ok, that's certainly a valid concern.
> 
> It's still - I think - really sad/wrong that the device name is then
> so useless than the drivers end up basically not using it.

I can see the desire for logging, it is just hard to come with good
automatic way of doing this without burdening drivers, given that errors
happen rarely in input core layer and in driver code we already have
perfect device object to report against.

Maybe dev_XXX() should report full sysfs path do the dveice? Still does
not help with the fact that "driver" shown for class devices is not so
interesting as it will always be the class name.

-- 
Dmitry
