Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab2APQBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 11:01:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60952 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751338Ab2APQBi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 11:01:38 -0500
Date: Mon, 16 Jan 2012 17:01:36 +0100
From: Jan Kara <jack@suse.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Edward Shishkin <edward@redhat.com>
Subject: Re: [RFC PATCH 0/3] Stop clearing uptodate flag on write IO error
Message-ID: <20120116160136.GC16431@quack.suse.cz>
References: <1325774407-28531-1-git-send-email-jack@suse.cz>
 <CA+55aFy0sidnCzPkP6yjnarLZx3a=7QSpgfaf2mUNVy14y3vCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFy0sidnCzPkP6yjnarLZx3a=7QSpgfaf2mUNVy14y3vCw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 14-01-12 18:19:02, Linus Torvalds wrote:
> On Thu, Jan 5, 2012 at 6:40 AM, Jan Kara <jack@suse.cz> wrote:
> >
> >  for mostly historical reasons we still clear buffer_uptodate flag on write
> > IO errors. This is not only semantically wrong (buffer still has correct data
> > in it)
> 
> That statement is so nonsensical that I can't get past it.
> 
> When you understand why it is nonsensical, you understand why the bit
> is cleared.
  Hum, let me understand this. I understand the meaning of buffer_uptodate
bit as "the buffer has at least as new content as what is on disk". Now
when storage cannot write the block under the buffer, the contents of the
buffer is still "at least as new as what is (was) on disk". Therefore I
made above statement about clearing buffer_uptodate bit being wrong. But
apparently you have a different definition of buffer_uptodate or I was not
clear enough in explaining what I mean... Which is the case?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
