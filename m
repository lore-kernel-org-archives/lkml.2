Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759110Ab0DHV1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 17:27:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:55939 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759046Ab0DHV1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 17:27:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jan Blunck <jblunck@suse.de>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Date: Thu, 8 Apr 2010 23:27:26 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.31-19-generic; KDE/4.4.2; x86_64; ; )
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Jiri Kosina <jkosina@suse.cz>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       John Kacur <jkacur@redhat.com>
References: <201003242240.54907.arnd@arndb.de> <201003282205.50886.arnd@arndb.de> <20100408204545.GM10776@bolzano.suse.de>
In-Reply-To: <20100408204545.GM10776@bolzano.suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004082327.26731.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19tprhuqkEazDLkdIIRVg2i5QZkkgL7GG8GdPe
 crw+g5V5VYOVM4TzNN8WsA3WP+ixXMnAX9rzHcpkehIVqUzxSL
 3aCb5YZO7qV/uSWN/gBfA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 April 2010 22:45:45 Jan Blunck wrote:
> On Sun, Mar 28, Arnd Bergmann wrote:
> > > General thoughts:
> > > 
> > > ".llseek = NULL," so far meant "do the Right Thing on lseek() and
> > > friends, as far as the fs core can tell".  Shouldn't we keep it that
> > > way?  It's as close to other ".method = NULL," as it can get, which
> > > either mean "silently skip this method if it doesn't matter" (e.g.
> > > .flush) or "fail attempts to use this method with a fitting errno" (e.g.
> > > .write).
> > 
> > My series changes the default from 'default_llseek' to 'generic_file_llseek',
> 
> That is not that easy. generic_file_llseek() is testing against 'offset <
> inode->i_sb->s_maxbytes'. This is not necessarily true when you think about
> directories with random offset cookies. I know that seeking on directories is
> stupid but don't blame me.

Oh, I see. Would it work if we extend generic_file_llseek to only check s_maxbytes
if S_ISREG(inode->i_mode)))?

> > Yes, that also sounds like a good idea. I believe that Jan actually posted
> > a patch to do that at some point.
> 
> Yes, it is in
> 
> http://git.infradead.org/users/jblunck/linux-2.6.git bkl/default-lseek
> 
> There are some other patches in that branch that are not upstream yet. Mind to
> take them for your bkl-removal branch?

Frederic is now collecting the new patches. Your default-lseek series looks
good to me, except for the obvious one that says 'FIXME' in the subject.

Maybe Frederic can add your series except for that one as another branch to
get pulled into his kill-the-bkl master branch.

	Arnd
