Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934757Ab2DLVYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 17:24:19 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50727 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202Ab2DLVYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 17:24:17 -0400
Date: Thu, 12 Apr 2012 14:24:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Subject: Re: linux-next: Tree for Apr 12
Message-Id: <20120412142415.564710b8.akpm@linux-foundation.org>
In-Reply-To: <20120412145931.9ec6f2b51655071795d60d1d@canb.auug.org.au>
References: <20120412145931.9ec6f2b51655071795d60d1d@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012 14:59:31 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> I have created today's linux-next tree at
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git

This isn't working for me.  Some time between April 3 and April 12
someone merged something into the non-mm part of linux-next which broke
ssh.

I boot the box and everything seems to come up OK, but attemtps to ssh
into the machine fail with

X11 forwarding request failed on channel 0
Last login: Thu Apr 12 13:04:35 2012 from akpm.corp.google.com
Connection to akpm2 closed.

I took a peek in the `strace ssh' output.

Good:

17815 write(5, "Last login: Thu Apr 12 13:27:23 "..., 65) = 65
17815 select(7, [3 4], [], NULL, {120, 0}) = 1 (in [3], left {119, 770798})
17815 read(3, "\21O\200\366Mv\343\222\332\251\2403L\376Y18\2047\336\244\226p-+X\2%\2119\314\255"..., 8192) = 80
17815 select(7, [3 4], [5], NULL, {120, 0}) = 1 (out [5], left {119, 999987})
17815 write(5, "\r\33[m\17\33[27m\33[24m\33[Jakpm2:/home/ak"..., 39) = 39
17815 select(7, [3 4], [], NULL, {120, 0}) = 1 (in [4], left {118, 801111})
17815 read(4, "\4", 16384)              = 1
17815 select(7, [3 4], [3], NULL, {120, 0}) = 1 (out [3], left {119, 999991})
17815 write(3, "\235J\5\340\234\21\266\207\26e\362\327\2\332\1\267\272\200\364\267?/\320L\341\35\350{+M:\222"..., 48) = 48


Bad:

9305  write(5, "Last login: Thu Apr 12 13:02:54 "..., 65) = 65
9305  select(7, [3 4], [], NULL, {120, 0}) = 1 (in [3], left {119, 945541})
9305  read(3, "f\357\250~\260i\2259\320\3258\262)O\364;_\251\360-\314\31\374]\326\300\356\364\370S\3105"..., 8192) = 128
9305  close(5)                          = 0
9305  close(4)                          = 0

That read() is returning a lot more data.

It appears that we've done something which breaks X forwarding.  I
won't be able to look any further into this until Monday.

