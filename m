Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab2CUTmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 15:42:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40052 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756053Ab2CUTmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 15:42:04 -0400
Date: Wed, 21 Mar 2012 19:42:03 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Adrian McMenamin <adrianmcmenamin@gmail.com>
Cc: Adrian McMenamin <lkmladrian@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Linux-sh <linux-sh@vger.kernel.org>
Subject: Re: [PATCH] VMUFAT filesystem [2/4]
Message-ID: <20120321194202.GP6589@ZenIV.linux.org.uk>
References: <CAN628AE8gytYTE3eGDYrKR9Vx4JnND+OGzHcfneCb4q-QUM6cA@mail.gmail.com>
 <20120321053735.GO6589@ZenIV.linux.org.uk>
 <CACwZE5TaUBLwsz0qMNqih9qnE1awP3i048ds-Say+xMAJXnMDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACwZE5TaUBLwsz0qMNqih9qnE1awP3i048ds-Say+xMAJXnMDA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 21, 2012 at 04:32:59PM +0800, Adrian McMenamin wrote:
> On 21 March 2012 13:37, Al Viro <viro@zeniv.linux.org.uk> wrote:
> 
> ...
> 
> OK, points essentially taken and will push through another patch in
> due course ... just a couple of points, though:
> 
> * Did the defensive stuff because bad guys might inject evil code
> rather than because I thought in normal run of execution there would
> be an issue - guess I just have to forget that?

Remove ones that are provably useless.  If your bad guys really manage to
get their code in kernel mode, you have already lost as thoroughly as one can.

> * On the semaphore - what should I use? Uninterruptible? Spinlock?
> Aren't there big downsides to them also?

Depends on the things you are going to do under it.  Spinlocks are OK only
for non-blocking areas; in this context I'd probably go for a plain mutex -
you don't need it to protect directory, since all directory operations have
->i_mutex on your only directory inode, but you need something to protect
your block allocator...
