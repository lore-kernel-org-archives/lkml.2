Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934711Ab0EENGv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 09:06:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22463 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755113Ab0EENGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 09:06:49 -0400
Date: Wed, 5 May 2010 09:06:40 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Valdis.Kletnieks@vt.edu
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Jan Blunck <jblunck@suse.de>
Subject: Re: [PATCH 17/39] union-mount: Union mounts documentation
Message-ID: <20100505130640.GA7534@shell>
References: <1272928358-20854-1-git-send-email-vaurora@redhat.com> <1272928358-20854-18-git-send-email-vaurora@redhat.com> <31248.1272938052@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31248.1272938052@localhost>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 09:54:12PM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Mon, 03 May 2010 16:12:16 PDT, Valerie Aurora said:
> 
> > +File copyup
> > +-----------
> > +
> > +Any system call that alters the data or metadata of a file on the
> > +bottom layer, or creates or changes a hard link to it will trigger a
> > +copyup of the target file from the lower layer to the topmost layer
> > +
> > + - open(O_WRITE | O_RDWR | O_APPEND | O_DIRECT)
> > + - truncate()/open(O_TRUNC)
> > + - link()
> > + - rename()
> > + - chmod()
> > + - chown()/lchown()
> > + - utimes()
> > + - setxattr()/lsetxattr()
> 
> I spent some time looking at patch 27 trying to figure it out for myself,
> but my lack of splice()-fu doomed me. :)
> 
> A few quick questions:
> 
> 1) For calls like chmod() that only touch the metadata, does it still
> trigger a copyup of the data, or just the affected metadata?

Yes, it copies up the whole file.  Right now there's no concept of
part of the file on one layer and part on another.

> 2) Is the copyup of data synchronous or async done in the background?
> The comments in union_copyup_len() about "We raced with someone else"
> imply this is synchronous - if so. probably a note should be made that
> an open() may take a little while under some conditions.  There's a *lot* of
> code out there that assumes that open() calls are *really* cheap.

It's synchronous.  Code that assumes open() calls are cheap will have
to be rewritten. :)

> I wonder how many programs don't correctly deal with an ENOSPC on open() of
> an already existing file.

I'm not too worried about that - how many programs deal correctly with
ENOSPC when it is normally returned?

-VAL
