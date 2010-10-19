Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab0JSTLh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 15:11:37 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:49922 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626Ab0JSTLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 15:11:36 -0400
Date: Tue, 19 Oct 2010 13:11:33 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 1/3] IMA: move read/write counters into struct inode
Message-ID: <20101019191133.GE2447@parisc-linux.org>
References: <20101019011650.25346.99614.stgit@paris.rdu.redhat.com> <AANLkTimGdjPyLXuknDNa7WNthDT9+2FdOuPdxwjRiMHD@mail.gmail.com> <1287506215.2530.187.camel@localhost.localdomain> <20101019165530.GT19804@ZenIV.linux.org.uk> <AANLkTimL=eChoCQHGoiouE5s6dGG=n9ZAQGhW-RW+gDj@mail.gmail.com> <20101019172805.GU19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101019172805.GU19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 06:28:05PM +0100, Al Viro wrote:
> I'd rather not say what I think about IMA sanity (and usefulness); as for what
> it tries to do...  They want to whine if you open a file that is already opened
> for write and they want to whine if you open a file for write when it's already
> opened for read.  Unless they decide to leave the file alone, that is.

Hm.  Sounds like the same question that the file leases code needs
answered.  The important difference is that the leases code can just
refuse to set a lease on inodes with multiple dentries.

While my mind's on it ... Al, is this code even close to correct?

                if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
                        goto out;
                if ((arg == F_WRLCK)
                    && ((atomic_read(&dentry->d_count) > 1)
                        || (atomic_read(&inode->i_count) > 1)))
                        goto out;

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
