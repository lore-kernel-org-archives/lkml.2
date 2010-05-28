Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab0E1VU0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 17:20:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35449 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753434Ab0E1VUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 17:20:23 -0400
Date: Fri, 28 May 2010 14:17:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
       "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
       Chris Mason <chris.mason@oracle.com>,
       Boaz Harrosh <bharrosh@panasas.com>, linux-ext4@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       David Woodhouse <dwmw2@infradead.org>, reiserfs-devel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, Evgeniy Dushistov <dushistov@mail.ru>
Subject: Re: [PATCHv4 01/17] VFS: introduce helpers for the s_dirty flag
Message-Id: <20100528141755.42958d81.akpm@linux-foundation.org>
In-Reply-To: <20100528211432.GM31073@ZenIV.linux.org.uk>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
	<1274795352-3551-2-git-send-email-dedekind1@gmail.com>
	<20100528132318.0783675a.akpm@linux-foundation.org>
	<20100528211432.GM31073@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 May 2010 22:14:32 +0100
Al Viro <viro@ZenIV.linux.org.uk> wrote:

> On Fri, May 28, 2010 at 01:23:18PM -0700, Andrew Morton wrote:
> 
> > A more conventional and superior naming scheme is
> > subsystemid_specific_function_identifier().  eg, bio_add_page() instead
> > of add_page_to_bio().
> > 
> > So these want to be sb_mark_dirty(), etc.
> > 
> > Being very old code written by very yound people, the VFS kinda ignores
> > that convention, but it doesn't hurt to use it for new code.
> > 
> > Feel free to ignore me if that's too much of a PITA ;)
> 
> The real issue is that it's almost certainly an overdesign.  Let's
> get rid of the bogus uses first and figure out what's happening in
> what remains, OK?

That would be good.

> I have no problems with doing such wrappers, but if we touch every
> place using ->s_dirt anyway, let's at least take a good look at them.

When adding wrappers we should also rename ->s_dirt (say, to __s_dirt)
to catch out any unconverted code.

