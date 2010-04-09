Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab0DILCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 07:02:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58345 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927Ab0DILCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 07:02:43 -0400
Date: Fri, 9 Apr 2010 13:02:41 +0200
From: Jan Blunck <jblunck@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Jiri Kosina <jkosina@suse.cz>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Message-ID: <20100409110241.GT10776@bolzano.suse.de>
References: <201003242240.54907.arnd@arndb.de> <201003282205.50886.arnd@arndb.de> <20100408204545.GM10776@bolzano.suse.de> <201004082327.26731.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004082327.26731.arnd@arndb.de>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, Arnd Bergmann wrote:

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

Yes and maybe rename generic_file_llseek to generic_llseek.

Jan

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
> 
> 	Arnd
