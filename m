Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755264Ab0E2IMC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 04:12:02 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:65261 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141Ab0E2IL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 04:11:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bjcLC5H5V7bkBkXD5+HwmYGG1TZC3OoZ/OGT/7tIll9+njZnzxkyuMH4skqBKA1UNr
         t6xkN7q4SL8ail8n6gSvG8WTPst1g07PcGO693CesJzgGB0RoXdrzAwugnBbnaIDmljN
         aNbcL3GrD6BGSu3mWDGGSYNMVeGXN7qGMVk4s=
Subject: Re: [PATCHv4 01/17] VFS: introduce helpers for the s_dirty flag
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>,
       "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
       Chris Mason <chris.mason@oracle.com>,
       Boaz Harrosh <bharrosh@panasas.com>, linux-ext4@vger.kernel.org,
       "Theodore Ts'o" <tytso@mit.edu>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       David Woodhouse <dwmw2@infradead.org>, reiserfs-devel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, Evgeniy Dushistov <dushistov@mail.ru>
In-Reply-To: <20100528141755.42958d81.akpm@linux-foundation.org>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
	 <1274795352-3551-2-git-send-email-dedekind1@gmail.com>
	 <20100528132318.0783675a.akpm@linux-foundation.org>
	 <20100528211432.GM31073@ZenIV.linux.org.uk>
	 <20100528141755.42958d81.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 29 May 2010 11:11:50 +0300
Message-Id: <1275120710.2668.20.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-28 at 14:17 -0700, Andrew Morton wrote:
> On Fri, 28 May 2010 22:14:32 +0100
> Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> > On Fri, May 28, 2010 at 01:23:18PM -0700, Andrew Morton wrote:
> > 
> > > A more conventional and superior naming scheme is
> > > subsystemid_specific_function_identifier().  eg, bio_add_page() instead
> > > of add_page_to_bio().
> > > 
> > > So these want to be sb_mark_dirty(), etc.
> > > 
> > > Being very old code written by very yound people, the VFS kinda ignores
> > > that convention, but it doesn't hurt to use it for new code.
> > > 
> > > Feel free to ignore me if that's too much of a PITA ;)
> > 
> > The real issue is that it's almost certainly an overdesign.  Let's
> > get rid of the bogus uses first and figure out what's happening in
> > what remains, OK?
> 
> That would be good.

Yes, I just mechanically introduced the wrappers to all FS-es. But as
per Al's request, I am going to try looking at how FSwe use it and
validate the usage. It'll take some time as this stuff is my background
task. Will see.

> > I have no problems with doing such wrappers, but if we touch every
> > place using ->s_dirt anyway, let's at least take a good look at them.
> 
> When adding wrappers we should also rename ->s_dirt (say, to __s_dirt)
> to catch out any unconverted code.

Right, I did this in the following patch:
	[PATCHv4 16/17] VFS: rename s_dirt to s_dirty

I thought that adding a leading '_' is not very neat, so added 'y' at
the end.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

