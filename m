Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448Ab1BXHX0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 02:23:26 -0500
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:40970 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751904Ab1BXHXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 02:23:25 -0500
X-Sasl-enc: H+NsPuztdYfHws2R725B3jErSNwItDBoINW2Tsc+eevc 1298532203
Subject: Re: [PATCH 0/3] Fixes for vfs-scale and vfs-automount
From: Ian Kent <raven@themaw.net>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Nick Piggin <npiggin@kernel.dk>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        David Howells <dhowells@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>
In-Reply-To: <20110224054701.GU22723@ZenIV.linux.org.uk>
References: <20110118040449.23109.33071.stgit@localhost6.localdomain6>
	 <1295420817.3076.24.camel@perseus> <1297779902.13007.86.camel@perseus>
	 <20110224015817.GQ22723@ZenIV.linux.org.uk>
	 <1298516618.2916.20.camel@perseus>
	 <20110224031439.GR22723@ZenIV.linux.org.uk>
	 <1298518137.2916.35.camel@perseus>
	 <20110224035836.GS22723@ZenIV.linux.org.uk>
	 <20110224054701.GU22723@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 24 Feb 2011 15:23:17 +0800
Message-ID: <1298532197.31595.1.camel@perseus>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-24 at 05:47 +0000, Al Viro wrote:
> On Thu, Feb 24, 2011 at 03:58:37AM +0000, Al Viro wrote:
> > On Thu, Feb 24, 2011 at 11:28:57AM +0800, Ian Kent wrote:
> > 
> > > Ha, I haven't even turned on my Ultrsparc 2 in months, it's only got an
> > > old version of Solaris on it now anyway, ;)
> > 
> > U60, with lenny (and mainline kernel) on it.  Probably ought to upgrade
> > to squeeze one of those days...  It works, all right, but it's only 2-way,
> > so reproducing would probably be harder.  Plus the fun of building the tests
> > themselves on somewhat different userland...
> > 
> > Anyway, I wonder why you care about __d_lookup_rcu() and ->d_inode stability;
> > d_mountpoint() _is_ stable at that point (we hold vfsmount_lock) and you
> > don't seem to look at ->d_inode at all in RCU case.  Note that ->d_automount()
> > is never called in RCU case at all; nor is ->lookup() and friends, so you
> > really only have ->d_manage() to cope with, what with autofs4 having no
> > ->d_revalidate() anymore.
> 
> FWIW, can we _ever_ get to __do_follow_link() with link->mnt != nd->path.mnt?
> It's probably not what's happening here, or we would've stepped on another
> BUG_ON(), but still it might be worth checking...
> 
> AFAICS, if we ever get there that way, we are fscked, so the check before
> mntget() ought to replaced with BUG_ON(link->mnt != nd->path.mnt)...

Yeah, don't think autofs can go their with no ->follow_link() defined.
I've largely ignored that code to date.


