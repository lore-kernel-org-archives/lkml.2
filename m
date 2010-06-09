Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab0FIPpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 11:45:30 -0400
Received: from THUNK.ORG ([69.25.196.29]:39827 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab0FIPp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 11:45:26 -0400
Date: Wed, 9 Jun 2010 11:44:49 -0400
From: tytso@mit.edu
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Artem Bityutskiy <dedekind1@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>,
       "Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
       Chris Mason <chris.mason@oracle.com>,
       Boaz Harrosh <bharrosh@panasas.com>, linux-ext4@vger.kernel.org,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       David Woodhouse <dwmw2@infradead.org>, reiserfs-devel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, Evgeniy Dushistov <dushistov@mail.ru>
Subject: Re: [PATCHv4 01/17] VFS: introduce helpers for the s_dirty flag
Message-ID: <20100609154448.GC6162@thunk.org>
Mail-Followup-To: tytso@mit.edu, Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org,
	Roman Zippel <zippel@linux-m68k.org>,
	"Tigran A. Aivazian" <tigran@aivazian.fsnet.co.uk>,
	Chris Mason <chris.mason@oracle.com>,
	Boaz Harrosh <bharrosh@panasas.com>, linux-ext4@vger.kernel.org,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	David Woodhouse <dwmw2@infradead.org>,
	reiserfs-devel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Evgeniy Dushistov <dushistov@mail.ru>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
 <1274795352-3551-2-git-send-email-dedekind1@gmail.com>
 <20100528132318.0783675a.akpm@linux-foundation.org>
 <20100528211432.GM31073@ZenIV.linux.org.uk>
 <20100528141755.42958d81.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100528141755.42958d81.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 02:17:55PM -0700, Andrew Morton wrote:
> > 
> > The real issue is that it's almost certainly an overdesign.  Let's
> > get rid of the bogus uses first and figure out what's happening in
> > what remains, OK?
> 
> That would be good.

Can we figure out what the new names will be for these accessor
functions, and then pursuade Linus to be willing to add patch #1 in
this series to add these accessor functions (without any users for
these functions, that would wait until the next merge window) to
2.6.35-rc3 or -rc4, please?

It will make life much easier for fs maintainers to merge the patches,
especially if they've done some cleanup to reduce the bogus places
where s_dirt was getting set in the first place.  That way I can apply
my patch to reduce the use of s_dirt[1], then apply a patch I carry in
my own tree to convert to the new accessor functions without worrying
about patch conflicts.

[1] http://article.gmane.org/gmane.comp.file-systems.ext4/19499

Thanks,

						- Ted
