Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651Ab0EJXYV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:24:21 -0400
Received: from smtp2.Stanford.EDU ([171.67.219.82]:51815 "EHLO
	smtp.stanford.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932582Ab0EJXYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 19:24:16 -0400
Subject: Re: 2.6.33.3-rt19 kernel BUG's
From: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>
To: john stultz <johnstul@us.ibm.com>
Cc: nando@ccrma.Stanford.EDU, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <1273521761.3843.33.camel@localhost.localdomain>
References: <1273197218.6768.10.camel@localhost.localdomain>
	 <alpine.LFD.2.00.1005071240350.3401@localhost.localdomain>
	 <1273275821.2776.3.camel@localhost.localdomain>
	 <1273276725.17045.4.camel@localhost.localdomain>
	 <1273279153.2776.7.camel@localhost.localdomain>
	 <1273511465.21774.11.camel@localhost.localdomain>
	 <1273521761.3843.33.camel@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 10 May 2010 16:23:33 -0700
Message-Id: <1273533813.374.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 13:02 -0700, john stultz wrote:
> On Mon, 2010-05-10 at 10:11 -0700, Fernando Lopez-Lezcano wrote:
> > On Fri, 2010-05-07 at 17:39 -0700, john stultz wrote:
> > > On Fri, 2010-05-07 at 23:58 +0000, Fernando Lopez-Lezcano wrote:
> > > > On Fri, 2010-05-07 at 16:43 -0700, john stultz wrote:
> > > > > On Fri, 2010-05-07 at 12:41 +0200, Thomas Gleixner wrote:
> > > > > > On Thu, 6 May 2010, Fernando Lopez-Lezcano wrote:
> > > > > > 
> > > > > > CC'ed John and Nick
> > > > > > 
> > > > > > > See below... just trying to boot (quad core desktop machine).
> > > > > 
> > > > > Ok. Got this to reproduce. Will hopefully have a fix for your soon.
> > > > > 
> > > > > Thanks for the bug report!
> > > > 
> > > > Thanks for looking at it! It had been a while since I had problems with
> > > > rt so I could not understand why I could not login :-) 
> > > 
> > > Bah! I should have caught this faster. I kept thinking it had to be some
> > > missed unlock of the sbi->fs_lock, but it ends up its just the
> > > autofs4_lock.
> > > 
> > > Apparently the conversion from using the dcache_lock -> autofs4_lock
> > > forgot that this function already grabs the autofs_lock for a small
> > > moment, so we end up grabbing the lock, then a moment later grab it
> > > again. Splat.
> > > 
> > > This patch should resolve it.
> > 
> > I'm still having problems when trying to use autofs, even with your
> > previous patch:
> 
> Oof.. More of the same autofs4_lock misuse.  I skimmed over the rest of
> its use, and it seems ok,  so hopefully we won't hit any more problems
> caused by it.

Thanks for the patch. It looks like it is working fine now, at least I
was able to login with an nfs/autofs mounted home dir...

-- Fernando


