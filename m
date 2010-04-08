Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547Ab0DHVax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 17:30:53 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:45444 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759094Ab0DHVav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 17:30:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ollxeY6WAgSlYzA6Q/lDiwo5/uZdIFCLmZq0xhpxKRiWVpG57p0kYHu0qaaquLu8WZ
         dIyQwQLoZAx3Fl8CkH7f/axM2bNQb7pxOzNCfmSON+y68C4xvzf/SUFmlIB1jK/3ZcRf
         ianMPN71EzNbd/uGAqfO2K5iM3bMiKK75bbCI=
Date: Thu, 8 Apr 2010 23:30:46 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jan Blunck <jblunck@suse.de>, Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Message-ID: <20100408213043.GB7990@nowhere>
References: <201003242240.54907.arnd@arndb.de> <201003282205.50886.arnd@arndb.de> <20100408204545.GM10776@bolzano.suse.de> <201004082327.26731.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004082327.26731.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 11:27:26PM +0200, Arnd Bergmann wrote:
> On Thursday 08 April 2010 22:45:45 Jan Blunck wrote:
> > On Sun, Mar 28, Arnd Bergmann wrote:
> > > > General thoughts:
> > > > 
> > > > ".llseek = NULL," so far meant "do the Right Thing on lseek() and
> > > > friends, as far as the fs core can tell".  Shouldn't we keep it that
> > > > way?  It's as close to other ".method = NULL," as it can get, which
> > > > either mean "silently skip this method if it doesn't matter" (e.g.
> > > > .flush) or "fail attempts to use this method with a fitting errno" (e.g.
> > > > .write).
> > > 
> > > My series changes the default from 'default_llseek' to 'generic_file_llseek',
> > 
> > That is not that easy. generic_file_llseek() is testing against 'offset <
> > inode->i_sb->s_maxbytes'. This is not necessarily true when you think about
> > directories with random offset cookies. I know that seeking on directories is
> > stupid but don't blame me.
> 
> Oh, I see. Would it work if we extend generic_file_llseek to only check s_maxbytes
> if S_ISREG(inode->i_mode)))?
> 
> > > Yes, that also sounds like a good idea. I believe that Jan actually posted
> > > a patch to do that at some point.
> > 
> > Yes, it is in
> > 
> > http://git.infradead.org/users/jblunck/linux-2.6.git bkl/default-lseek
> > 
> > There are some other patches in that branch that are not upstream yet. Mind to
> > take them for your bkl-removal branch?
> 
> Frederic is now collecting the new patches. Your default-lseek series looks
> good to me, except for the obvious one that says 'FIXME' in the subject.
> 
> Maybe Frederic can add your series except for that one as another branch to
> get pulled into his kill-the-bkl master branch.


Ok, will have a look at this soon (I will also put a branch for the procfs
series).

Thanks.

