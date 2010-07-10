Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab0GJWBe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 18:01:34 -0400
Received: from verein.lst.de ([213.95.11.210]:59420 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753212Ab0GJWBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 18:01:33 -0400
Date: Sun, 11 Jul 2010 00:01:10 +0200
From: Christoph Hellwig <hch@lst.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] Remove BKL from fs/locks.c
Message-ID: <20100710220110.GA13380@lst.de>
References: <1278798701-11171-1-git-send-email-arnd@arndb.de> <1278798701-11171-3-git-send-email-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278798701-11171-3-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 10, 2010 at 11:51:40PM +0200, Arnd Bergmann wrote:
> From: Matthew Wilcox <willy@linux.intel.com>
> 
> I've taken a patch originally written by Matthew Wilcox and
> ported it to the current version. Unfortunately, the change
> conflicts with the use of lockd, which still heavily uses
> the big kernel lock.
> 
> As a workaround, I've made the behaviour configurable,
> it either uses the BKL when it's enabled or a spinlock
> when the BKL (and consequently nfs and lockd) are
> disabled.

Defintively not something we want in mainline.  But keep poking
the nfs guys to sort the lockd mess out for real.

