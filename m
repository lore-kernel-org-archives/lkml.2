Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760685Ab1LPXaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 18:30:52 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:35943 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab1LPXap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 18:30:45 -0500
Date: Fri, 16 Dec 2011 23:30:42 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Move attribute flags into non __KERNEL__ space
Message-ID: <20111216233041.GU2203@ZenIV.linux.org.uk>
References: <1324021626-10059-1-git-send-email-levinsasha928@gmail.com>
 <20111216192320.GA23748@infradead.org>
 <1324071040.29432.3.camel@sasha>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324071040.29432.3.camel@sasha>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 11:30:40PM +0200, Sasha Levin wrote:
> On Fri, 2011-12-16 at 14:23 -0500, Christoph Hellwig wrote:
> > On Fri, Dec 16, 2011 at 09:47:06AM +0200, Sasha Levin wrote:
> > > Attribute flags can be useful in userspace when working with filesystems
> > > such as 9p.
> > 
> > No, they aren't.  They are kernel internal values and userspace has no
> > fucking business messing with them.
> > 
> 
> They became userspace business once they got exposed through 9p.
> 
> Take a look at <linux/net/9p/9p.h>:
> 
> 	/**
> 	 * struct p9_iattr_dotl - P9 inode attribute for setattr
> 	 * @valid: bitfield specifying which fields are valid
> 	 *         same as in struct iattr
> 	[...]
> 
> That structure is userspace facing, and it's using iattr values.
> 
> So either we expose them through fs.h, through 9p.h, or modify 9p code
> to not use them directly. But claiming that they're kernel internal
> values isn't entirely correct.

They *are* kernel internal values and 9P is asking for trouble exposing
them.  Translation: tomorrow we might reassign those as we bloody wish
and any userland code that happens to rely on their values will break.
At which point we'll handle complaints by pointing and laughing.

It's a 9P bug; fix it there.  Turning random internal constants into a part
of ABI is not going to work.
