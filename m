Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932299Ab0JORw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 13:52:58 -0400
Received: from canuck.infradead.org ([134.117.69.58]:48891 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755648Ab0JORw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 13:52:57 -0400
Date: Fri, 15 Oct 2010 13:52:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101015175247.GA6737@infradead.org>
References: <20101014144159.GA11972@infradead.org>
 <20101015001443.GA3146@amd>
 <20101015031343.GG4681@dastard>
 <20101015033017.GA6750@amd>
 <20101015034451.GA6827@amd>
 <20101015064150.GB7511@amd>
 <20101015105943.GE32255@dastard>
 <20101015130259.GA3207@amd>
 <20101015132938.GA3936@amd>
 <20101015173345.GA10731@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101015173345.GA10731@amd>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for trying to get back to a technical discussion.  Maybe we
can just move the technical comments to direct replies to the patches
and leave this not very helpful subthread behind?

> rcu_read_lock();
> list_for_each_entry(inode, list) {
>     if (inode->blah ...) {
>       spin_lock(&list_lock);
>       if (unlikely(list_empty(&inode->i_list)))
>         continue;
>       do_something(inode);
>    }
> }

But that't not what we do for icache.  For the validity checking during
lookup we check the I_FREEING bit, which is modified under i_lock
and can be read without any locking.  So everything is just fine
when moving on to RCU locking.

