Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab1DUDJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 23:09:29 -0400
Received: from verein.lst.de ([213.95.11.211]:59702 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab1DUDJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 23:09:28 -0400
Date: Thu, 21 Apr 2011 05:09:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@lst.de>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] vfs: Pass setxattr(2) flags properly
Message-ID: <20110421030927.GA32145@lst.de>
References: <1303324240-26672-1-git-send-email-jack@suse.cz> <BANLkTi=muyG3iVnTp6YCY1-dFuBa6SQGZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=muyG3iVnTp6YCY1-dFuBa6SQGZQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 04:59:06PM -0700, Linus Torvalds wrote:
> Hmm. This patch looks very sane, but it's been that way - ignoring the
> 'flags' value - since 2009. Does anybody actually _use_ the flags
> field?
> 
> Judging by commit 431547b3c453 (that introduced the thing), it looks
> like a plain mistake, and the previous "flags" was replaced by a "0"
> in the call when it added the "hander->flags" argument at the end. But
> the fact that it's been two years, and nobody noticed, makes me go
> "hmm.."

It's not really used very much.  The only use of XATTR_CREATE is to
prevent creating the attrs used for ACLs from the normal xattrs
interface instead of going through the ACL code, and XATTR_REPLACE
is only used to return -ENOATTR when it's set but the attribute
actually is empty.

The first one could probably be used (by root) to create invalid
attrs that confuse the ACL code, and the second may confuse application
using it, although I doubt there are many.

