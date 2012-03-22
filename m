Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030868Ab2CVQPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 12:15:35 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:61810 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704Ab2CVQPd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 12:15:33 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1203192156410.24735-100000@netrider.rowland.org>
References: <CAKwO_5EgwVn+d1LGoms+6+u_76cBG0NLqF8tmeo1u=32AKGqVA@mail.gmail.com>
	<Pine.LNX.4.44L0.1203192156410.24735-100000@netrider.rowland.org>
Date: Thu, 22 Mar 2012 09:15:32 -0700
Message-ID: <CAKwO_5EvCG80q7AFD-jvQgb7KSU=wdmSongz0fWh5A817SWCBg@mail.gmail.com>
Subject: Re: [PATCH] fs: Fix mod_timer crash when removing USB sticks
From: Paul Taysom <taysom@google.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mandeep Singh Baines <msb@chromium.org>, "Ted Ts'o" <tytso@mit.edu>,
        Theodore Tso <tytso@google.com>, Greg KH <greg@kroah.com>,
        Paul Taysom <taysom@chromium.org>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@google.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 7:02 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Mon, 19 Mar 2012, Paul Taysom wrote:
>
>> I have rerun my tests without my change on the 3.2.7 kernel and I was
>> not able to get it to crash. I even put some code in to do the early
>> detection so I didn't have to wait for another thread to stumble
>> across the corruption. The way I test is with several flash drivers
>> with ext2, ext3, ext4, FAT, and HPFS file systems and just repeatedly
>> plug and unplug them. When a flash drive is plugged in with a file
>> system, it is automatically mounted.
>
> That's not the right way to test a race like this.  The right way is to
> insert ssleep() calls at some appropriate spots, so that you can force
> the race to come out the way you want every time.
>
> What about the question of resetting the bdi pointer at the same time
> as some other thread is using it?  Have you tested whether Mandeep's
> locking suggestion will prevent problems?
>
> Alan Stern
>

The checks I added to timer.c seems to the defect every time. With
3.2.7, it never sees the defect.
Paul Taysom
