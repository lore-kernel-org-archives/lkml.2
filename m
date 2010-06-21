Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903Ab0FUNOu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 09:14:50 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:53197 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab0FUNOt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 09:14:49 -0400
To: Valerie Aurora <vaurora@redhat.com>
CC: raa.lkml@gmail.com, viro@zeniv.linux.org.uk, miklos@szeredi.hu,
       jblunck@suse.de, hch@infradead.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-reply-to: <20100617183912.GA14389@shell> (message from Valerie Aurora on
	Thu, 17 Jun 2010 14:39:13 -0400)
Subject: Re: [PATCH 17/38] union-mount: Union mounts documentation
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-18-git-send-email-vaurora@redhat.com> <AANLkTilNAGzn3ZC5eN2ZQMqNhcSWnT-mi_y2TkIkdeUU@mail.gmail.com> <20100617183912.GA14389@shell>
Message-Id: <E1OQgpf-0001DJ-3w@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 21 Jun 2010 15:14:35 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010, Valerie Aurora wrote:
> On Thu, Jun 17, 2010 at 10:01:30AM +0200, Alex Riesen wrote:
> > On Tue, Jun 15, 2010 at 20:39, Valerie Aurora <vaurora@redhat.com> wrote:
> > > +git://git.kernel.org/pub/scm/fs/ext2/val/e2fsprogs.git
> > > +
> > > +Currently, whiteout directory entries are not returned to userland.
> > > +While the directory type for whiteouts, DT_WHT, has been defined for
> > > +many years, very little userland code handles them. ??Userland will
> > > +never see fallthru directory entries.
> > 
> > This may be a dumb question (I must admit I did only very little research),
> > but how does one cleanup the topmost layer of whiteouts and fallthroughs,
> > so that the entries of lower layer(s) can be made visible again?
> 
> I'm not sure how best to do this.  We don't want to add more system
> calls.  One thought of mine has been to do this offline, when the file
> system is unmounted.  For example, e2fsck could add a feature to
> delete whiteouts and fallthrus.  Another option is to add a flag to an
> existing system call.

One more advantage of doing whiteouts, etc. with hard links and
extended attributes instead of as special filesystem objects.  That
way they are visible (unless part of a union) and can be treated as
normal filesystem objects.

Miklos
