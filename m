Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab1LQNo4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 08:44:56 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:43479 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752194Ab1LQNox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 08:44:53 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>, Sasha Levin <levinsasha928@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs: Move attribute flags into non __KERNEL__ space
In-Reply-To: <20111216233041.GU2203@ZenIV.linux.org.uk>
References: <1324021626-10059-1-git-send-email-levinsasha928@gmail.com> <20111216192320.GA23748@infradead.org> <1324071040.29432.3.camel@sasha> <20111216233041.GU2203@ZenIV.linux.org.uk>
User-Agent: Notmuch/0.10.2+102~g61445d1 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Sat, 17 Dec 2011 19:14:26 +0530
Message-ID: <87vcpfjosl.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 11121713-3270-0000-0000-000002A11792
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Dec 2011 23:30:42 +0000, Al Viro <viro@ZenIV.linux.org.uk> wrote:
> On Fri, Dec 16, 2011 at 11:30:40PM +0200, Sasha Levin wrote:
> > On Fri, 2011-12-16 at 14:23 -0500, Christoph Hellwig wrote:
> > > On Fri, Dec 16, 2011 at 09:47:06AM +0200, Sasha Levin wrote:
> > > > Attribute flags can be useful in userspace when working with filesystems
> > > > such as 9p.
> > > 
> > > No, they aren't.  They are kernel internal values and userspace has no
> > > fucking business messing with them.
> > > 
> > 
> > They became userspace business once they got exposed through 9p.
> > 
> > Take a look at <linux/net/9p/9p.h>:
> > 
> > 	/**
> > 	 * struct p9_iattr_dotl - P9 inode attribute for setattr
> > 	 * @valid: bitfield specifying which fields are valid
> > 	 *         same as in struct iattr
> > 	[...]
> > 
> > That structure is userspace facing, and it's using iattr values.
> > 
> > So either we expose them through fs.h, through 9p.h, or modify 9p code
> > to not use them directly. But claiming that they're kernel internal
> > values isn't entirely correct.
> 
> They *are* kernel internal values and 9P is asking for trouble exposing
> them.  Translation: tomorrow we might reassign those as we bloody wish
> and any userland code that happens to rely on their values will break.
> At which point we'll handle complaints by pointing and laughing.
> 
> It's a 9P bug; fix it there.  Turning random internal constants into a part
> of ABI is not going to work.

I guess we would need to define them at the protocol level then. 
Something like f88657ce3f9713a0c62101dffb0e972a979e77b9. 

-aneesh

