Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757815Ab0FUXRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 19:17:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab0FUXRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 19:17:39 -0400
Date: Mon, 21 Jun 2010 19:17:20 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: raa.lkml@gmail.com, viro@zeniv.linux.org.uk, jblunck@suse.de,
       hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 17/38] union-mount: Union mounts documentation
Message-ID: <20100621231720.GC28850@shell>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-18-git-send-email-vaurora@redhat.com> <AANLkTilNAGzn3ZC5eN2ZQMqNhcSWnT-mi_y2TkIkdeUU@mail.gmail.com> <20100617183912.GA14389@shell> <E1OQgpf-0001DJ-3w@pomaz-ex.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1OQgpf-0001DJ-3w@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 03:14:35PM +0200, Miklos Szeredi wrote:
> On Thu, 17 Jun 2010, Valerie Aurora wrote:
> > On Thu, Jun 17, 2010 at 10:01:30AM +0200, Alex Riesen wrote:
> > > On Tue, Jun 15, 2010 at 20:39, Valerie Aurora <vaurora@redhat.com> wrote:
> > > > +git://git.kernel.org/pub/scm/fs/ext2/val/e2fsprogs.git
> > > > +
> > > > +Currently, whiteout directory entries are not returned to userland.
> > > > +While the directory type for whiteouts, DT_WHT, has been defined for
> > > > +many years, very little userland code handles them. ??Userland will
> > > > +never see fallthru directory entries.
> > > 
> > > This may be a dumb question (I must admit I did only very little research),
> > > but how does one cleanup the topmost layer of whiteouts and fallthroughs,
> > > so that the entries of lower layer(s) can be made visible again?
> > 
> > I'm not sure how best to do this.  We don't want to add more system
> > calls.  One thought of mine has been to do this offline, when the file
> > system is unmounted.  For example, e2fsck could add a feature to
> > delete whiteouts and fallthrus.  Another option is to add a flag to an
> > existing system call.
> 
> One more advantage of doing whiteouts, etc. with hard links and
> extended attributes instead of as special filesystem objects.  That
> way they are visible (unless part of a union) and can be treated as
> normal filesystem objects.

This should be reasonably easy to prototype - the whiteout and
fallthru patches are pretty well separated from the rest of union
mounts.

-VAL
