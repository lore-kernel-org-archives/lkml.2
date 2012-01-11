Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516Ab2AKMgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 07:36:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53902 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579Ab2AKMgr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 07:36:47 -0500
Message-ID: <1326285382.13736.4.camel@tucsk.pomaz.szeredi.hu>
Subject: Re: [git pull] vfs pile 1
From: Miklos Szeredi <mszeredi@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Toshiyuki Okajima <toshi.okajima@jp.fujitsu.com>
Date: Wed, 11 Jan 2012 13:36:22 +0100
In-Reply-To: <20120111115846.GA2646@infradead.org>
References: <20120105022318.GG23916@ZenIV.linux.org.uk>
	 <CA+55aFw+7xvfP3NCr5p2Ma--UTb7zT+QQxtjCn3V2SU_g3LUdA@mail.gmail.com>
	 <20120111115846.GA2646@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-11 at 06:58 -0500, Christoph Hellwig wrote:
> On Sun, Jan 08, 2012 at 03:04:30PM -0800, Linus Torvalds wrote:
> > Hmm.
> > 
> > Al, Miklos, I just triggered the new inc_link() warning three times in
> > very close succession by just doing a simple
> 
> Also just as expected the set_nlink warnings triggers during XFS log
> recovery (not that I haven't pointed this out multiple times before):
> 
> [ 1702.280003] XFS (vdb2): Starting recovery (logdev: internal)
> [ 1702.294935] set_nlink() clearing i_nlink on xfs inode 320
> [ 1702.297909] set_nlink() clearing i_nlink on xfs inode 256
> [ 1702.301082] set_nlink() clearing i_nlink on xfs inode 192
> [ 1702.304305] set_nlink() clearing i_nlink on xfs inode 321
> [ 1702.306980] set_nlink() clearing i_nlink on xfs inode 257
> [ 1702.308204] set_nlink() clearing i_nlink on xfs inode 193
> [ 1702.309490] set_nlink() clearing i_nlink on xfs inode 322
> [ 1702.311195] set_nlink() clearing i_nlink on xfs inode 258
> [ 1702.313156] set_nlink() clearing i_nlink on xfs inode 194
> [ 1702.315203] set_nlink() clearing i_nlink on xfs inode 323

There are a couple of options:

a) leave it as it is

b) change that set_nlink() in xfs into a 

  if (nlink)
	set_nlink(nlink);
  else
	clear_nlink();

c) remove the printk from set_nlink().  This effectively makes
set_nlink(0) an alias of clear_nlink().

IIRC your preference is c.  What do others think?

Thanks,
Miklos


