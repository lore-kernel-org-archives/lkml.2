Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab2IDSiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 14:38:25 -0400
Received: from fieldses.org ([174.143.236.118]:59991 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab2IDSiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 14:38:24 -0400
Date: Tue, 4 Sep 2012 14:38:15 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Namjae Jeon <linkinjeon@gmail.com>, akpm@linux-foundation.org,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 4/5] fat: eliminate orphaned inode number allocation
Message-ID: <20120904183815.GA29369@fieldses.org>
References: <1346774312-8142-1-git-send-email-linkinjeon@gmail.com>
 <87mx15910k.fsf@devron.myhome.or.jp>
 <87fw6x90o3.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fw6x90o3.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 02:07:40AM +0900, OGAWA Hirofumi wrote:
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
> 
> > Namjae Jeon <linkinjeon@gmail.com> writes:
> >
> >> From: Namjae Jeon <namjae.jeon@samsung.com>
> >>
> >> Maintain a list of inode(i_pos) numbers of orphaned inodes (i.e the
> >> inodes that have been unlinked but still having open file
> >> descriptors).At file/directory creation time, skip using such i_pos
> >> values.Removal of the i_pos from the list is done during inode eviction.
> >
> > What happens if the directory (has busy entries) was completely removed?
> >
> >
> > And Al's point is important for NFS too. If you want stable ino for NFS,
> > you never can't change it.
> 
> s/never can't/never can/

If vfat exports aren't fixable, maybe we should just remove that
feature?

I'm afraid that having unfixable half-working vfat exports is just an
attractive nuisance that causes users and developers to waste their
time....

--b.
