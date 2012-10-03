Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab2JCVFg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 17:05:36 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49437 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755042Ab2JCVFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 17:05:34 -0400
X-Sasl-enc: K37o0gSu2KijCPkgyZBysrcWoVRCTNhQ2M4Y0PVnanKo 1349298333
Date: Wed, 3 Oct 2012 14:05:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ming Lei <ming.lei@canonical.com>, Kay Sievers <kay@vrfy.org>,
        Lennart Poettering <lennart@poettering.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Ivan Kalvachev <ikalvachev@gmail.com>
Subject: Re: udev breakages - was: Re: Need of an ".async_probe()" type of
 callback at driver's core - Was: Re: [PATCH] [media] drxk: change it to use
 request_firmware_nowait()
Message-ID: <20121003210532.GA10941@kroah.com>
References: <CA+55aFyzXFNq7O+M9EmiRLJ=cDJziipf=BLM8GGAG70j_QTciQ@mail.gmail.com>
 <20121002221239.GA30990@kroah.com>
 <20121002222333.GA32207@kroah.com>
 <CA+55aFwNEm9fCE+U_c7XWT33gP8rxothHBkSsnDbBm8aXoB+nA@mail.gmail.com>
 <506C562E.5090909@redhat.com>
 <CA+55aFweE2BgGjGkxLPkmHeV=Omc4RsuU6Kc6SLZHgJPsqDpeA@mail.gmail.com>
 <20121003170907.GA23473@ZenIV.linux.org.uk>
 <CA+55aFw0pB99ztq5YUS56db-ijdxzevA=mvY3ce5O_yujVFOcA@mail.gmail.com>
 <20121003195059.GA13541@kroah.com>
 <CA+55aFwjyABgr-nmsDb-184nQF7KfA8+5kbuBNwyQBHs671qQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwjyABgr-nmsDb-184nQF7KfA8+5kbuBNwyQBHs671qQg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 01:39:23PM -0700, Linus Torvalds wrote:
> On Wed, Oct 3, 2012 at 12:50 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >>
> >> Ok, like this?
> >
> > This looks good to me.  Having udev do firmware loading and tieing it to
> > the driver model may have not been such a good idea so many years ago.
> > Doing it this way makes more sense.
> 
> Ok, I wish this had been getting more testing in Linux-next or
> something, but I suspect that what I'll do is to commit this patch
> asap, and then commit another patch that turns off udev firmware
> loading entirely for the synchronous firmware loading case.
> 
> Why? Just to get more testing, and seeing if there are reports of
> breakage. Maybe some udev out there has a different search path (or
> because udev runs in a different filesystem namespace or whatever), in
> which case running udev as a fallback would otherwise hide the fact
> that he direct kernel firmware loading isn't working.
> 
> We can (and will) revert things if that turns out to break things, but
> I'd like to make any failures of the firmware direct-load path be fast
> and hard, so that we can see when/what it breaks.
> 
> Ok? Comments?

I have no objection to this.  As for the firmware path, maybe we should
change that to be modified by userspace (much like /sbin/hotplug was) in
a proc file so that distros can override the location if they need to.
But for now, that's probably overkill.  This solves the problem that
Mauro and others have reported and can be easily backported by any
affected distros if needed.

thanks,

greg k-h
