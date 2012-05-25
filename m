Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755766Ab2EYBjh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 21:39:37 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53961 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755377Ab2EYBjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 21:39:31 -0400
Date: Fri, 25 May 2012 10:39:17 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [git pull] Input updates for 3.5-rc0
Message-ID: <20120525013917.GA22260@kroah.com>
References: <CA+55aFx0ww=BtYAj9WEbqMT2R30ZZpjd014cYCpC=b+HRtUf_A@mail.gmail.com>
 <20120524195851.GA15306@core.coreip.homeip.net>
 <CA+55aFxX+xidcuVXb1h4oFTemtHo+ANECaoOw=vxtKN231N+cA@mail.gmail.com>
 <20120524203647.GA16024@core.coreip.homeip.net>
 <CA+55aFz9Fp2J=oCkoDAwNTnEJoBeKC9tn+5dqMCKf4C22CAi6Q@mail.gmail.com>
 <20120524205952.GA16621@core.coreip.homeip.net>
 <CA+55aFybQDXjGaEK0k=60gS88bxwE8vC7XvOffaQAf3de9cCfg@mail.gmail.com>
 <CA+55aFzZm2aAhgZagWq=rsfKTt=2_2_mpVjXDN3LAqAJmWoZqw@mail.gmail.com>
 <20120524220105.GB18120@kroah.com>
 <CA+55aFxYQQRpw0CDJn8bRLQJ2EYNhxf4Ra6=Hd9hOw=1q11pXA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFxYQQRpw0CDJn8bRLQJ2EYNhxf4Ra6=Hd9hOw=1q11pXA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 03:05:09PM -0700, Linus Torvalds wrote:
> On Thu, May 24, 2012 at 3:01 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > I'm open to ideas on what to change it to.  A full sysfs path?
> 
> A full sysfs path really looks pretty ugly, partly because we'd have
> to really change all our naming (look at PCI devices now: they end up
> looking like
> 
>     pci0000:00/0000:00:1a.0
> 
> where that "0000:00" is duplicated because we wanted to make
> dev_name() look nice).
> 
> I think Dmitry's idea to stop when we hit the actual "physical" device
> might just work in practice. So we'd show the dev_name() of the actual
> piece of hardware, and then perhaps one or two "layering" details on
> top of it. And it wouldn't change anything for the current common case
> where people tend to pass in the physical device as-is.

Ok, the "trick" is going to be to figure out where the "physical" device
is in the parent chain (look at the scsi craziness for an example of
that.)

I'm on the road for the next week or so, with lots of international
plane rides with time to kill, so I'll try to figure something out on
them and post it.

thanks,

greg k-h
