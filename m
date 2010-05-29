Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab0E2H7j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 03:59:39 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50182 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753818Ab0E2H7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 03:59:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=UIZgw4fiw7CDfTW7yvkOasquxiFEorg/IJD153hxqeHWjClZEXPLSg4sBvAD2Yp9wM
         0guKW7K0Pk4K7Rx2LvnKxpXl/QflK3AGZxcRfV6HIO9zV1jRab6roAzgeaMDeeIjsWpr
         0TW+tl0HE/F8IMv2WXpdeptfNNF19uHi3rjDg=
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
In-Reply-To: <20100528132318.0783675a.akpm@linux-foundation.org>
References: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
	 <1274795352-3551-2-git-send-email-dedekind1@gmail.com>
	 <20100528132318.0783675a.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 29 May 2010 10:59:28 +0300
Message-Id: <1275119968.2668.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-28 at 13:23 -0700, Andrew Morton wrote:
> > +static inline void mark_sb_dirty(struct super_block *sb)
> > +{
> > +	sb->s_dirt = 1;
> > +}
> > +static inline void mark_sb_clean(struct super_block *sb)
> > +{
> > +	sb->s_dirt = 0;
> > +}
> > +static inline int is_sb_dirty(struct super_block *sb)
> > +{
> > +	return sb->s_dirt;
> > +}
> 
> A more conventional and superior naming scheme is
> subsystemid_specific_function_identifier().  eg, bio_add_page() instead
> of add_page_to_bio().
> 
> So these want to be sb_mark_dirty(), etc.
> 
> Being very old code written by very yound people, the VFS kinda ignores
> that convention, but it doesn't hurt to use it for new code.
> 
> Feel free to ignore me if that's too much of a PITA ;)

Sure I'll re-name them, thanks!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

