Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759764Ab0JFSoE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:44:04 -0400
Received: from verein.lst.de ([213.95.11.210]:60436 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759667Ab0JFSoC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:44:02 -0400
Date: Wed, 6 Oct 2010 20:43:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>, Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] one writeback regression fix for .36
Message-ID: <20101006184353.GA30673@lst.de>
References: <4CACA9AD.9070900@fusionio.com> <AANLkTi=NkzSWR0voR9xLs2f7Rxfc4A_n7qi+t9fbB2iz@mail.gmail.com> <20101006183124.GR19804@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101006183124.GR19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 07:31:24PM +0100, Al Viro wrote:
> Eh...  I'm no fonder of that than you are (and strcmp is fucking stupid),
> but... that thing is really sb_is_blkdev_sb() trying to make a comeback
> in fs/fs-writeback.c.  IOW, it's sick, but not for the reasons you are
> mentioning; strcmp() use is trivially removable.

The alternative basically is exporting bd_type so that it can be used
here and comparing ->s_type.  The real problem is that right now the
internal block device filesystem is the only one having more than one
backing device per filesystem.  I have patches to generalize that, which
is something we'll need for writeback performance on large filesystem
sooner or later.  I was planning to get this ready for 2.6.37, but if
you prefer no big chance in this area I can calm down and move other
things up on my TODO list.

