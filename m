Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454Ab1D3Cz4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 22:55:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48915 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab1D3Czz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 22:55:55 -0400
Date: Sat, 30 Apr 2011 03:55:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joern Engel <joern@logfs.org>, Dave Chinner <dchinner@redhat.com>,
        werner <w.landgraf@ru.ru>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110430025545.GI9487@ZenIV.linux.org.uk>
References: <web-515866242@zbackend1.aha.ru>
 <BANLkTimfOCwZQP=Hv+NEhFcxMpC51-RhTw@mail.gmail.com>
 <BANLkTinv38NtVQHrayus6v89BocsK6+iQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinv38NtVQHrayus6v89BocsK6+iQQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 07:47:14PM -0700, Linus Torvalds wrote:
> On Fri, Apr 29, 2011 at 7:31 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > It looks like a NULL pointer dereference with offset 4, so at a guess,
> > super->s_freeing_list.next is NULL, and it's the "next->prev = entry"
> > instruction that faults when inserting into that list.
> >
> > How/why would s_freeing_list be NULL? I have no idea. But it looks
> > like a failed mount, so presumably it was never initialized.
> 
> Hmm. super->s_freeing_list is initialized pretty late in
> logfs_read_sb(), and any error path _before_ that point will result in
> a "goto err1" in logfs_get_sb_device() which will do various iputs
> etc. All without that list initialized. That would seem to be the
> cause of this, possibly triggered by Al's changes to ->mount from
> read_super.

Then it ought to be reproducible with much ealier kernels.  Say, 2.6.37 or
so...  That part of ->mount() series went in during last Autumn...
