Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756765Ab0HNVq0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 17:46:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43208 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472Ab0HNVqZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 17:46:25 -0400
Date: Sat, 14 Aug 2010 14:46:18 -0700
From: Greg KH <gregkh@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Grant Coady <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [0/3] 2.6.27.52 stable review
Message-ID: <20100814214618.GA8505@suse.de>
References: <20100813214704.GA18960@kroah.com>
 <p5ib66db7ilijjesu4dd3b351dtmsk175f@4ax.com>
 <20100813230712.GA1703@suse.de>
 <t5mb661vmb2a33gev3tqki89410a0795kc@4ax.com>
 <20100814001158.GA2849@suse.de>
 <AANLkTin0Gb0q_jgJDROqBGsM4fa=LiAax-J0Q4FRyRGG@mail.gmail.com>
 <20100814025323.GA4779@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100814025323.GA4779@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 07:53:23PM -0700, Greg KH wrote:
> On Fri, Aug 13, 2010 at 05:51:56PM -0700, Linus Torvalds wrote:
> > On Fri, Aug 13, 2010 at 5:11 PM, Greg KH <gregkh@suse.de> wrote:
> > >
> > > That's a warning that current->mm is null.  I don't know enough about
> > > the mm subsystem to say if this is normal or not, and I don't at first
> > > glance, see how this patch could have caused this to happen.
> > 
> > We call that whole "expand_stack()" through handle_mm_fault(), and
> > that's _not_ called just for the process itself. So "current->mm" is
> > sometimes simply the wrong thing to use - like when you access the VM
> > of another process (during fork for the argument setup of the new VM,
> > or during ptrace etc).
> > 
> > Which is why I think commit 05fa199d45c should fix it. It makes the
> > stack expansion thing use the right mm. Which it just _happened_ to do
> > before, because it was always called just from the faulting code where
> > current->mm happened to be the right mm.
> > 
> > But I really don't know if there might be other issues lurking too.
> 
> Ok, I'll go add that commit, and I unpacked my older machine that runs
> the .27 kernel and will beat on it with that box tomorrow to see if
> anything else pops up.

It's booting here, but I'm out of time and have to go on vacation until
Monday night and I'll pick this up on Tuesday again when I get back.

thanks,

greg k-h
