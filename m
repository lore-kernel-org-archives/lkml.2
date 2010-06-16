Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501Ab0FPXOt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 19:14:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758615Ab0FPXOs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 19:14:48 -0400
Date: Wed, 16 Jun 2010 19:14:22 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, autofs@linux.kernel.org,
       Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [autofs] [PATCH 04/38] autofs4: Save autofs trigger's vfsmount in super block info
Message-ID: <20100616231421.GD13908@shell>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-5-git-send-email-vaurora@redhat.com> <1276661043.2339.35.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276661043.2339.35.camel@localhost>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 12:04:03PM +0800, Ian Kent wrote:
> On Tue, 2010-06-15 at 11:39 -0700, Valerie Aurora wrote:
> > From: Jan Blunck <jblunck@suse.de>
> > 
> > XXX - This is broken and included just to make union mounts work.  See
> > discussion at:
> > 
> > http://kerneltrap.org/mailarchive/linux-fsdevel/2010/1/15/6708053/thread
> 
> Instead of saving the vfsmount we could save a pointer to the dentry of
> the mount point in the autofs super block info struct. I think that's
> the bit I don't have so it would be sufficient for a lookup_mnt() for
> the needed vfsmount in ->follow_mount().
> 
> Objections?
> Suggestions?

I'm not sure... it seems like it would have the same problem that Al
described with pinning the vfsmount forever.  But I don't know autofs
at all.

Could you run through a quick example of the case that triggers this
problem in the first place?  The problem is when you have a symlink
that triggers an automount, and you are trying to get from the target
of the symlink to the vfsmount of the file system containing the
symlink in the first place?  Or do I have that wrong?

Thanks,

-VAL
