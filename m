Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778Ab2F1QyA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:54:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51283 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754056Ab2F1Qx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:53:59 -0400
Date: Thu, 28 Jun 2012 18:53:57 +0200
From: Jan Kara <jack@suse.cz>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>, "Alasdair G. Kergon" <agk@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: Crash when IO is being submitted and block size is changed
Message-ID: <20120628165357.GA6232@quack.suse.cz>
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com>
 <20120628111541.GB17515@quack.suse.cz>
 <Pine.LNX.4.64.1206281138150.23635@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1206281138150.23635@file.rdu.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 28-06-12 11:44:03, Mikulas Patocka wrote:
> On Thu, 28 Jun 2012, Jan Kara wrote:
> 
> > > Do you have any other ideas what to do with it?
> >   Yeah, it's nasty and neither solution looks particularly appealing. One
> > idea that came to my mind is: I'm trying to solve some races between direct
> > IO, buffered IO, hole punching etc. by a new mapping interval lock. I'm not
> > sure if it will go anywhere yet but if it does, we can fix the above race
> > by taking the mapping lock for the whole block device around setting block
> > size thus effectivelly disallowing any IO to it.
> > 
> > 								Honza
> > -- 
> > Jan Kara <jack@suse.cz>
> > SUSE Labs, CR
> 
> What races are you trying to solve? There used to be i_alloc_mem that 
> prevented direct i/o while the file is being truncated, but it disappeared 
> in recent kernels...
  i_alloc_sem has been replaced by inode_dio_wait() and friends. The
problem is mainly with hole punching - see the thread starting here:
http://www.spinics.net/lists/linux-ext4/msg32059.html

								Honza
