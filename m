Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932233Ab0JRPJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 11:09:29 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:53469 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756159Ab0JRPJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 11:09:28 -0400
Date: Mon, 18 Oct 2010 11:09:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Eric Paris <eparis@redhat.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Peter Zijlstra <peterz@infradead.org>,
        Eric Paris <eparis@parisplace.org>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org, hpa@zytor.com
Subject: Re: ima: use of radix tree cache indexing == massive waste of memory?
Message-ID: <20101018150920.GA24907@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It can be turned on any time inside the initrd without loss of integrity
> assuming the kernel and initrd were both measured and stored in a TPM
> PCR.  I'm willing to agree that the usefulness might be limited, but it
> isn't non-existant.  I'm going to make a note to look at other ways to
> cut down the memory usage.

It's not just memory overhead - it also adds another global reasource
and global lock for every inode allocation/freeing.  That's okay if
people actually want to use IMA - but if you do it everywhere it's
a real PITA.

If there's seriously no way to fix it up to not cause harm by default
just extending the inode is the much better way to go.  But given
that it's already in distros with a kABI I suspect some people will
be interested in fixing it for people instead of forcing this overhead
on their customers for years.  We might want to just piggyback on that.
