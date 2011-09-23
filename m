Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629Ab1IWWGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 18:06:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51462 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab1IWWGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 18:06:34 -0400
Date: Fri, 23 Sep 2011 15:04:40 -0700
From: Greg KH <gregkh@suse.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Greg KH <greg@kroah.com>,
        Nobuhiro Iwamatsu <nobuhiro.iwamatsu.yj@renesas.com>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 1/4] TTY: serial, fix locking imbalance
Message-ID: <20110923220440.GC30017@suse.de>
References: <1314818699-10873-1-git-send-email-jslaby@suse.cz>
 <20110922224653.GB21296@kroah.com>
 <4E7CD560.8010706@suse.cz>
 <20110923190840.GA31009@suse.de>
 <4E7CDC30.8070607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E7CDC30.8070607@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 09:21:20PM +0200, Jiri Slaby wrote:
> On 09/23/2011 09:08 PM, Greg KH wrote:
> > On Fri, Sep 23, 2011 at 08:52:16PM +0200, Jiri Slaby wrote:
> >> On 09/23/2011 12:46 AM, Greg KH wrote:
> >>> On Wed, Aug 31, 2011 at 09:24:56PM +0200, Jiri Slaby wrote:
> >>>> Commit "TTY: serial, move locking in uart_close" moved the lock, but
> >>>> omitted to update branches which unlock the lock. Now they try to
> >>>> unlock the lock without holding it.
> >>>>
> >>>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> >>>> ---
> >>>> If possible, please, merge this into the patch mentioned above (it's
> >>>> not upstream yet).
> >>>
> >>> I can't do that,
> >>
> >> Hmm, but what is the reason for that? I mean, why do you prefer a kernel
> >> with broken history with respect to bisection? Per definition -next
> >> doesn't mind rebases in subtrees. Or is this already in tty-linus branch
> >> (I cannot check now, obviously)?
> > 
> > Because it is in my tree and I can't rebase it as others depend on it
> > (linux-next and others.)
> 
> linux-next doesn't mind if you rebase. That's exactly what it is for. To
> test commits collected from #for-next branches and alter them if needed.
> It merges whatever is in the current branch no matter what was there
> some days ago.

Users who base their work on mine care if I rebase.

And so do I, it's just one of those rules, "Greg will not rebase his
trees" that makes for better development.

And yes, sometimes it does cause minor problems like this, but overall,
it's much easier for everyone involved.

> But if there are more trees depending on the tree, then OK, I will live
> with that ;).

For the tty tree, I really doubt it, but I am not sure (rumor has it
that some people are basing on it, but that might just be rumor.)  For
my staging and USB trees, I can't rebase as I know I have users for
those trees.

greg k-h
