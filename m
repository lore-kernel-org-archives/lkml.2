Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221Ab1D3DCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 23:02:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47899 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab1D3DCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 23:02:49 -0400
Date: Sat, 30 Apr 2011 04:02:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Joern Engel <joern@logfs.org>, Dave Chinner <dchinner@redhat.com>,
        werner <w.landgraf@ru.ru>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110430030243.GJ9487@ZenIV.linux.org.uk>
References: <web-515866242@zbackend1.aha.ru>
 <BANLkTimfOCwZQP=Hv+NEhFcxMpC51-RhTw@mail.gmail.com>
 <BANLkTinv38NtVQHrayus6v89BocsK6+iQQ@mail.gmail.com>
 <20110430025545.GI9487@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110430025545.GI9487@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 30, 2011 at 03:55:45AM +0100, Al Viro wrote:

> > Hmm. super->s_freeing_list is initialized pretty late in
> > logfs_read_sb(), and any error path _before_ that point will result in
> > a "goto err1" in logfs_get_sb_device() which will do various iputs
> > etc. All without that list initialized. That would seem to be the
> > cause of this, possibly triggered by Al's changes to ->mount from
> > read_super.

Wait a bit; _can_ we get there with non-NULL ->s_master_inode et.al.?
iput(NULL) is a noop...  I don't think so, since logfs_init_journal()
is not called until after we initialize that list.

Not that I'd object against taking that initialization earlier, of course,
but there seems to be something else going on...  Which iput() it is?
