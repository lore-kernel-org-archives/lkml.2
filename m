Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab1HWVEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 17:04:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35008 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730Ab1HWVDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 17:03:47 -0400
Date: Tue, 23 Aug 2011 14:03:18 -0700
From: Greg KH <gregkh@suse.de>
To: Mark Einon <mark.einon@gmail.com>
Cc: Greg KH <greg@kroah.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, o.hartmann@telovital.com
Subject: Re: [PATCH 5/5] staging: et131x: Fix free IRQ from IRQ context
 warning after tx_timeout
Message-ID: <20110823210318.GA3444@suse.de>
References: <1312321621-2695-1-git-send-email-mark.einon@gmail.com>
 <20110823185020.GA11302@kroah.com>
 <CANK3SE2un_SP3DCkXJiBA5GukgDAoR0DN0JmM6AN6R0pR=1eow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANK3SE2un_SP3DCkXJiBA5GukgDAoR0DN0JmM6AN6R0pR=1eow@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 09:43:31PM +0100, Mark Einon wrote:
> On 23 August 2011 19:50, Greg KH <greg@kroah.com> wrote:
> > On Tue, Aug 02, 2011 at 10:47:01PM +0100, Mark Einon wrote:
> >> When a tx timeout occured, et131x_tx_timeout closed and re-opened the device to fix.
> >> As et131x_close called free_irq(), bad things ensued (see warning trace below), namely a
> >> storm of errors and warnings.
> >> Fixed by replacing the close() and open() calls with just the relevant functions previously
> >> called from these.
> >> Verified on an ET-1310 device.
> >>
> >> Signed-off-by: Mark Einon <mark.einon@gmail.com>
> >
> > This patch breaks the build :(
> >
> > Care to resend this one, and any other patch you have sent me but I
> > didn't apply yet, again, as I have now applied all et131x patches in my
> > queue.
> 
> Hi Greg,
> 
> I seem to have some difficulty updating my staging-next branch at the
> moment, this method worked a few days ago. Am I doing something
> idiotic, or is the issue with the remote?
> The file refs/heads/staging-next contains
> 4024bc73b1d1d8f82518b67b0996cb7b870dd1d4, which git doesn't seem to
> like.
> 
> [mark@msilap staging-2.6]$ git checkout staging-next
> Already on 'staging-next'
> [mark@msilap staging-2.6]$ git pull
> remote: error: refs/heads/staging-next does not point to a valid object!
> remote: Counting objects: 21, done.
> remote: Compressing objects: 100% (12/12), done.
> remote: Total 14 (delta 12), reused 2 (delta 2)
> Unpacking objects: 100% (14/14), done.
> >From git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging-2.6
>    fcb8ce5..20cc799  staging-linus -> origin/staging-linus
> Your configuration specifies to merge with the ref 'staging-next'
> from the remote, but no such ref was fetched.

That's odd.

First, back up your patches somewhere.

Then try deleting the local branch:
	git checkout master
	git branch -D staging-next
and then re-creating it:
	git pull
	git checkout -t -b staging-next origin/staging-next

And then work on adding your patches back.

See if that works.

thanks,

greg k-h
