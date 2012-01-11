Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab2AKNNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 08:13:00 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56247 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756011Ab2AKNM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 08:12:58 -0500
Message-ID: <1326287556.13736.12.camel@tucsk.pomaz.szeredi.hu>
Subject: Re: [git pull] vfs pile 1
From: Miklos Szeredi <mszeredi@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Date: Wed, 11 Jan 2012 14:12:36 +0100
In-Reply-To: <20120111124001.GA834@infradead.org>
References: <20120105022318.GG23916@ZenIV.linux.org.uk>
	 <CA+55aFw+7xvfP3NCr5p2Ma--UTb7zT+QQxtjCn3V2SU_g3LUdA@mail.gmail.com>
	 <20120111115846.GA2646@infradead.org>
	 <1326285382.13736.4.camel@tucsk.pomaz.szeredi.hu>
	 <20120111124001.GA834@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-11 at 07:40 -0500, Christoph Hellwig wrote:
> On Wed, Jan 11, 2012 at 01:36:22PM +0100, Miklos Szeredi wrote:
> > There are a couple of options:
> > 
> > a) leave it as it is
> > 
> > b) change that set_nlink() in xfs into a 
> > 
> >   if (nlink)
> > 	set_nlink(nlink);
> >   else
> > 	clear_nlink();
> > 
> > c) remove the printk from set_nlink().  This effectively makes
> > set_nlink(0) an alias of clear_nlink().
> > 
> > IIRC your preference is c.  What do others think?
> 
> Yes.  a) really isn't an option - we don't want to spew thousands of
> useless messages during a log recovery for an operation that's totally
> normal.  b) is okay, too - but it's not just xfs that needs to be
> covered, but any fs that support the concept of recovering from open
> but unlinked inodes after a crash.  It's just that no one else seems
> to have regular QA for that code path.

Since it's a ratelimited printk there won't be thousands of messages.  I
think this is just a cosmetic issue and lack of QA isn't a problem.  If
the messages are bothersome it can be fixed.

Thanks,
Miklos

