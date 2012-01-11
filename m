Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757455Ab2AKMkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 07:40:06 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38886
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753861Ab2AKMkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 07:40:04 -0500
Date: Wed, 11 Jan 2012 07:40:01 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Miklos Szeredi <mszeredi@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Subject: Re: [git pull] vfs pile 1
Message-ID: <20120111124001.GA834@infradead.org>
References: <20120105022318.GG23916@ZenIV.linux.org.uk>
 <CA+55aFw+7xvfP3NCr5p2Ma--UTb7zT+QQxtjCn3V2SU_g3LUdA@mail.gmail.com>
 <20120111115846.GA2646@infradead.org>
 <1326285382.13736.4.camel@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326285382.13736.4.camel@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 01:36:22PM +0100, Miklos Szeredi wrote:
> There are a couple of options:
> 
> a) leave it as it is
> 
> b) change that set_nlink() in xfs into a 
> 
>   if (nlink)
> 	set_nlink(nlink);
>   else
> 	clear_nlink();
> 
> c) remove the printk from set_nlink().  This effectively makes
> set_nlink(0) an alias of clear_nlink().
> 
> IIRC your preference is c.  What do others think?

Yes.  a) really isn't an option - we don't want to spew thousands of
useless messages during a log recovery for an operation that's totally
normal.  b) is okay, too - but it's not just xfs that needs to be
covered, but any fs that support the concept of recovering from open
but unlinked inodes after a crash.  It's just that no one else seems
to have regular QA for that code path.

