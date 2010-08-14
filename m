Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab0HNFn6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 01:43:58 -0400
Received: from 1wt.eu ([62.212.114.60]:40931 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126Ab0HNFnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 01:43:55 -0400
Date: Sat, 14 Aug 2010 07:43:35 +0200
From: Willy Tarreau <w@1wt.eu>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Grant Coady <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org,
        stable@kernel.org, akpm@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [0/3] 2.6.27.52 stable review
Message-ID: <20100814054335.GB21003@1wt.eu>
References: <20100813214704.GA18960@kroah.com> <p5ib66db7ilijjesu4dd3b351dtmsk175f@4ax.com> <20100813230712.GA1703@suse.de> <t5mb661vmb2a33gev3tqki89410a0795kc@4ax.com> <20100814001158.GA2849@suse.de> <AANLkTin0Gb0q_jgJDROqBGsM4fa=LiAax-J0Q4FRyRGG@mail.gmail.com> <20100814025323.GA4779@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100814025323.GA4779@suse.de>
User-Agent: Mutt/1.4.2.3i
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

Greg, I confirm that 05fa199d45c fixes the warnings. I did not have them
in .51, got them with .52-rc1 and got rid of it with the patch above.

Regards,
Willy

