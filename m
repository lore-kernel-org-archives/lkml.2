Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410Ab2CTCCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 22:02:22 -0400
Received: from netrider.rowland.org ([192.131.102.5]:54595 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758827Ab2CTCCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 22:02:20 -0400
Date: Mon, 19 Mar 2012 22:02:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Paul Taysom <taysom@google.com>
cc: Mandeep Singh Baines <msb@chromium.org>, "Ted Ts'o" <tytso@mit.edu>,
        Theodore Tso <tytso@google.com>, Greg KH <greg@kroah.com>,
        Paul Taysom <taysom@chromium.org>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@google.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, <stable@kernel.org>
Subject: Re: [PATCH] fs: Fix mod_timer crash when removing USB sticks
In-Reply-To: <CAKwO_5EgwVn+d1LGoms+6+u_76cBG0NLqF8tmeo1u=32AKGqVA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1203192156410.24735-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012, Paul Taysom wrote:

> I have rerun my tests without my change on the 3.2.7 kernel and I was
> not able to get it to crash. I even put some code in to do the early
> detection so I didn't have to wait for another thread to stumble
> across the corruption. The way I test is with several flash drivers
> with ext2, ext3, ext4, FAT, and HPFS file systems and just repeatedly
> plug and unplug them. When a flash drive is plugged in with a file
> system, it is automatically mounted.

That's not the right way to test a race like this.  The right way is to 
insert ssleep() calls at some appropriate spots, so that you can force 
the race to come out the way you want every time.

What about the question of resetting the bdi pointer at the same time 
as some other thread is using it?  Have you tested whether Mandeep's 
locking suggestion will prevent problems?

Alan Stern

