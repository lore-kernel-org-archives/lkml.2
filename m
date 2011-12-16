Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760838Ab1LPVia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 16:38:30 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42230 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760653Ab1LPViW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 16:38:22 -0500
Message-ID: <1324071040.29432.3.camel@sasha>
Subject: Re: [PATCH] fs: Move attribute flags into non __KERNEL__ space
From: Sasha Levin <levinsasha928@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org
Date: Fri, 16 Dec 2011 23:30:40 +0200
In-Reply-To: <20111216192320.GA23748@infradead.org>
References: <1324021626-10059-1-git-send-email-levinsasha928@gmail.com>
	 <20111216192320.GA23748@infradead.org>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-12-16 at 14:23 -0500, Christoph Hellwig wrote:
> On Fri, Dec 16, 2011 at 09:47:06AM +0200, Sasha Levin wrote:
> > Attribute flags can be useful in userspace when working with filesystems
> > such as 9p.
> 
> No, they aren't.  They are kernel internal values and userspace has no
> fucking business messing with them.
> 

They became userspace business once they got exposed through 9p.

Take a look at <linux/net/9p/9p.h>:

	/**
	 * struct p9_iattr_dotl - P9 inode attribute for setattr
	 * @valid: bitfield specifying which fields are valid
	 *         same as in struct iattr
	[...]

That structure is userspace facing, and it's using iattr values.

So either we expose them through fs.h, through 9p.h, or modify 9p code
to not use them directly. But claiming that they're kernel internal
values isn't entirely correct.

-- 

Sasha.

