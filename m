Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965566Ab2EXWBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 18:01:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59098 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965485Ab2EXWBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 18:01:13 -0400
Date: Fri, 25 May 2012 07:01:05 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [git pull] Input updates for 3.5-rc0
Message-ID: <20120524220105.GB18120@kroah.com>
References: <CA+55aFxw0HRpizzJZxhhA2oqPpzg4DPUvH2r7YoYfctXS6K=WQ@mail.gmail.com>
 <20120524180154.GA15036@core.coreip.homeip.net>
 <CA+55aFx0ww=BtYAj9WEbqMT2R30ZZpjd014cYCpC=b+HRtUf_A@mail.gmail.com>
 <20120524195851.GA15306@core.coreip.homeip.net>
 <CA+55aFxX+xidcuVXb1h4oFTemtHo+ANECaoOw=vxtKN231N+cA@mail.gmail.com>
 <20120524203647.GA16024@core.coreip.homeip.net>
 <CA+55aFz9Fp2J=oCkoDAwNTnEJoBeKC9tn+5dqMCKf4C22CAi6Q@mail.gmail.com>
 <20120524205952.GA16621@core.coreip.homeip.net>
 <CA+55aFybQDXjGaEK0k=60gS88bxwE8vC7XvOffaQAf3de9cCfg@mail.gmail.com>
 <CA+55aFzZm2aAhgZagWq=rsfKTt=2_2_mpVjXDN3LAqAJmWoZqw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzZm2aAhgZagWq=rsfKTt=2_2_mpVjXDN3LAqAJmWoZqw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 02:44:31PM -0700, Linus Torvalds wrote:
> On Thu, May 24, 2012 at 2:07 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Thu, May 24, 2012 at 1:59 PM, Dmitry Torokhov
> > <dmitry.torokhov@gmail.com> wrote:
> >>
> >> I was concerned about the _next_ device (the one that will be created
> >> the moment I plug in the tablet back into the same port) having exact
> >> same name as the one that is half dead and clashing in sysfs and
> >> elsewhere. We used to have issues with this.
> >
> > Ok, that's certainly a valid concern.
> >
> > It's still - I think - really sad/wrong that the device name is then
> > so useless than the drivers end up basically not using it.
> 
> Ok, so I wonder if we could solve the issue at least partly by
> separating the "print name for kernel messages" from the "name used
> for /sysfs etc".
> 
> Because you're right: the sysfs uniqueness rules does make it very
> hard to do a good job on descriptive names.
> 
> Also, in sysfs, you by definition see the parent (hey, it's part of
> the path), so in sysfs, duplicating parent data would be useless and
> just ugly.
> 
> But for dev_dbg(), those sysfs rules actually act against us: the name
> of a device is often tied to the parent bus location.
> 
> So I wonder if we could teach  dev_printk() to use something more
> interesting than "dev_name()" when appropriate? Greg?

I'm open to ideas on what to change it to.  A full sysfs path?
Something more "unique"?  I don't know what works for everything here.

thanks,

greg k-h
