Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab1GZTP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 15:15:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751373Ab1GZTP0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 15:15:26 -0400
MIME-Version: 1.0
In-Reply-To: <20110726185920.GA2970@infradead.org>
References: <20110726181418.GA27993@quack.suse.cz> <CA+55aFwYsdyE4KxFW70c_FfTb41m+EwchYvNJU-eUEw4usRkUw@mail.gmail.com>
 <20110726185220.GJ22133@ZenIV.linux.org.uk> <20110726185920.GA2970@infradead.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 26 Jul 2011 12:14:28 -0700
Message-ID: <CA+55aFyCs3T_BhwjhW=zC9+5G7tnUNmQAa+77YndJ9BuV4Kbig@mail.gmail.com>
Subject: Re: [PULL REQUEST] ext3, jbd, ext2, and quota fixes for 3.1-rc1
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Josef Bacik <josef@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 11:59 AM, Christoph Hellwig <hch@infradead.org> wrote:
>
> In addition to beeing bogus the code also is useless.  fsync on a file
> explicitly does not guarantee anything at all about the parent, and
> never really has on Linux either.

Well, it may never have done that, but it might still be a case of
quality-of-implementation.

The data blocks and inode indirect blocks being stable on disk doesn't
help hugely if you cannnot actually reach the inode itself.

But yeah, I suspect it's not worth the bother. For many common
situations, it's the rename that moves it to the final place that is
the critical one as far as parent directory is concerned, not the
fsync of the file itself.

                     Linus
