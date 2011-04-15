Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab1DOU5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 16:57:40 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:59725 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756093Ab1DOU5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 16:57:39 -0400
Date: Fri, 15 Apr 2011 16:57:12 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        William Irwin <wli@holomorphy.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: hugetlb locking bug.
Message-ID: <20110415205712.GA13049@infradead.org>
References: <20110415201652.GA5131@redhat.com>
 <BANLkTi=ctr7tQLArfbdHRU3uUvEPh6KbwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=ctr7tQLArfbdHRU3uUvEPh6KbwQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 01:49:04PM -0700, Linus Torvalds wrote:
> And I really thought we annotated it as such with different
> "lockdep_set_class()" cases (ie the whole
> 
>   lockdep_set_class(&inode->i_mutex,&type->i_mutex_dir_key);
> 
> for the S_ISDIR case in unlock_new_inode().
> 
> Can somebody more alert than me see why this lockdep issue still
> triggers with hugetlbfs?

Because it doesn't use iget or unlock_new_inode, but rather calls
directly into new_inode().  It and other filesystems not using
unlock_new_inode will need a local copy of that logic.
