Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759018Ab2CJCNy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 21:13:54 -0500
Received: from kanga.kvack.org ([205.233.56.17]:55521 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758896Ab2CJCNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 21:13:17 -0500
Date: Fri, 9 Mar 2012 21:13:16 -0500
From: Benjamin LaHaise <bcrl@kvack.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aio: fix the "too late munmap()" race
Message-ID: <20120310021316.GA22880@kvack.org>
References: <20120307051634.GR23916@ZenIV.linux.org.uk> <20120308175119.GY23916@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308175119.GY23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 05:51:19PM +0000, Al Viro wrote:
> Since actual freeing of these suckers is RCU-delayed, we don't need to
> bump ioctx refcount when request goes into list for async removal.
> All we need is rcu_read_lock held just over the ->ctx_lock-protected
> area in aio_fput_routine().
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Signed-off-by: Benjamin LaHaise <bcrl@kvack.org>

Looks good.  As with the previous patch, I instrumented and tested the code 
to trigger fput_work() with no issues encountered.

		-ben
