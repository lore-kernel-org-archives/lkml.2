Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760642Ab0FQSj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 14:39:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757184Ab0FQSj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 14:39:28 -0400
Date: Thu, 17 Jun 2010 14:39:13 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Alex Riesen <raa.lkml@gmail.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
       Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
       Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 17/38] union-mount: Union mounts documentation
Message-ID: <20100617183912.GA14389@shell>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-18-git-send-email-vaurora@redhat.com> <AANLkTilNAGzn3ZC5eN2ZQMqNhcSWnT-mi_y2TkIkdeUU@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilNAGzn3ZC5eN2ZQMqNhcSWnT-mi_y2TkIkdeUU@mail.gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 10:01:30AM +0200, Alex Riesen wrote:
> On Tue, Jun 15, 2010 at 20:39, Valerie Aurora <vaurora@redhat.com> wrote:
> > +git://git.kernel.org/pub/scm/fs/ext2/val/e2fsprogs.git
> > +
> > +Currently, whiteout directory entries are not returned to userland.
> > +While the directory type for whiteouts, DT_WHT, has been defined for
> > +many years, very little userland code handles them. ??Userland will
> > +never see fallthru directory entries.
> 
> This may be a dumb question (I must admit I did only very little research),
> but how does one cleanup the topmost layer of whiteouts and fallthroughs,
> so that the entries of lower layer(s) can be made visible again?

I'm not sure how best to do this.  We don't want to add more system
calls.  One thought of mine has been to do this offline, when the file
system is unmounted.  For example, e2fsck could add a feature to
delete whiteouts and fallthrus.  Another option is to add a flag to an
existing system call.

Any ideas?

-VAL
