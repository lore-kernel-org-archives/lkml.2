Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757243Ab2JWSQX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 14:16:23 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34880 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756708Ab2JWSQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 14:16:22 -0400
Date: Tue, 23 Oct 2012 14:16:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ming Lei <ming.lei@canonical.com>
cc: linux-kernel@vger.kernel.org, Oliver Neukum <oneukum@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: Re: [RFC PATCH v2 2/6] PM / Runtime: introduce pm_runtime_set_memalloc_noio()
In-Reply-To: <CACVXFVN+=XH_f5BmRkXeagTNowz0o0-Pd7GcxCneO0FSq8xqEw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1210231402040.1635-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012, Ming Lei wrote:

> With the problem of non-SMP-safe bitfields access, the power.lock should
> be held, but that is not enough to prevent children from being probed or
> disconnected. Looks another lock is still needed. I think a global lock
> is OK in the infrequent path.

Agreed.

> Got it, thanks for your detailed explanation.
> 
> Looks the problem is worse than above, not only bitfields are affected, the
> adjacent fields might be involved too, see:
> 
>            http://lwn.net/Articles/478657/

Linus made it clear (in various emails at the time) that the kernel
requires the compiler not to do the sort of things discussed in that
article.  But even the restrictions he wanted would not prevent
adjacent bitfields from interfering with each other.

Alan Stern

