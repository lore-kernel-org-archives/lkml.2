Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758544Ab2BNCgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 21:36:38 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48352 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757Ab2BNCgh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 21:36:37 -0500
MIME-Version: 1.0
In-Reply-To: <20120213204937.GF12117@google.com>
References: <20120208162925.GA19392@google.com>
	<CANejiEVuQRUY4Ovb2a1JNDZjRTeN_nft8LwY8AB144=9dkFq7A@mail.gmail.com>
	<20120209175948.GE19392@google.com>
	<CA+55aFzVmb_DfPPDyeON9X2KAii79g=NszPi+k9jrNLdQS7+4g@mail.gmail.com>
	<20120209192431.GF19392@google.com>
	<20120209234844.GG19392@google.com>
	<CANejiEXaaSfv8Rs3Rg6zLamYsUj=apKku6yrw7EUtpKkB1ZATA@mail.gmail.com>
	<CANejiEVBd6eu8LwmhbMvQqMW4LqUh6F-5psyW0dVYU06WEJqBQ@mail.gmail.com>
	<20120211021724.GO19392@google.com>
	<CANejiEVQav8mtQHD0FETxo1-Zc7exMyb6ecjrAzdZWw68OkTug@mail.gmail.com>
	<20120213204937.GF12117@google.com>
Date: Tue, 14 Feb 2012 10:36:36 +0800
X-Google-Sender-Auth: EblF7AfI5P5Zm0SJFdZV7zFKeRo
Message-ID: <CANejiEW46KSZHLqn5-ZLCpMV_MyQsJB2kghrvzcEpvigod+9zA@mail.gmail.com>
Subject: Re: [PATCH] block: strip out locking optimization in put_io_context()
From: Shaohua Li <shli@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Knut Petersen <Knut_Petersen@t-online.de>, mroos@linux.ee,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/14 Tejun Heo <tj@kernel.org>:
> Hello, Shaohua.
>
> Can you please test the following patch?  It's combination of three
> patches which invokes elevator icq exit from exit_io_context().  This
> unfortunately ends up adding another reverse locking loop and using
> RCU could be better; unfortunately, the change isn't trivial due to
> q->queue_lock modification during blk_cleanup_queue() and ioc cleanup
> being called after that from blk_release_queue() - IOW, while holding
> RCU, we might end up grabbing the wrong q lock (I don't think this is
> a new problem).
>
> Now that we have proper request draining on queue exit, we can
> probably move ioc clearing and other operations to blk_cleanup_queue()
> and then apply RCU, but that's for another merge window.
This fixed the regression. Thanks!
