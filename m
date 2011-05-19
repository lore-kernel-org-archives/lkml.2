Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935167Ab1ESWMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 18:12:48 -0400
Received: from cantor.suse.de ([195.135.220.2]:53436 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934954Ab1ESWMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 18:12:47 -0400
Date: Fri, 20 May 2011 08:12:26 +1000
From: NeilBrown <neilb@suse.de>
To: Andy Whitcroft <apw@canonical.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, nbd@openwrt.org, hramrach@centrum.cz,
        jordipujolp@gmail.com
Subject: Re: [PATCH 0/7] overlay filesystem v9
Message-ID: <20110520081226.0787e2dd@notabene.brown>
In-Reply-To: <20110519180558.GJ3702@shadowen.org>
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu>
	<20110519163709.GH3702@shadowen.org>
	<87sjsak2jt.fsf@tucsk.pomaz.szeredi.hu>
	<20110519180558.GJ3702@shadowen.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 May 2011 19:05:58 +0100 Andy Whitcroft <apw@canonical.com> wrote:

> On Thu, May 19, 2011 at 07:44:54PM +0200, Miklos Szeredi wrote:
> 
> > Forgot to attach the patch?
> 
> Yep, should be in your inbox now.
> 
> > >
> > > With this in place I have been able to boot a Natty release live CD
> > > image, and upgrade it in place to the latest and greatest of everything.
> > > Very nice.  Thanks for your work continuing work on overlayfs.  It is
> > > starting to look good enough to merge.
> > >
> > > Comments?
> > 
> > I'd be happier if the LSM module were fixed not to peek inside the inode
> > structure.  Some filesystems (notably network ones) do not guarantee i_*
> > to be up-to-date, relying on these is not a good idea.
> 
> I wonder what what the official way to get ownership information for an
> inode is if we cannot rely on those.  I am happy to get the Yama LSM
> fixed up if they are doing something wrong.
> 
> -apw

inode->getattr(...., &kstat);
look at kstat.uid, kstat.gid.

??

NeilBrown
