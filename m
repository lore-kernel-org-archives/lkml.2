Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab0KFOxO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Nov 2010 10:53:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40918 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754061Ab0KFOxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Nov 2010 10:53:13 -0400
MIME-Version: 1.0
In-Reply-To: <20101106121605.GA6736@redhat.com>
References: <AANLkTimr3rW67HxgOUyReEW8dmmSsd4b7-Ns57mXzS1w@mail.gmail.com>
 <20101103161638.ddc75ace.randy.dunlap@oracle.com> <AANLkTinj2sk==Jw7ZL3RvO_M7iRPW0sQy8dsvabo-V5h@mail.gmail.com>
 <4CD48D5E.10309@oracle.com> <AANLkTi=3f6f5MoZAX4C4ufYkopn8Z_xrR6nd-GzkoDhg@mail.gmail.com>
 <20101106121605.GA6736@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 6 Nov 2010 07:52:15 -0700
Message-ID: <AANLkTinrkpf=aYcB_987_5dfPPLUG2mdEF4UDQ-ZpJCZ@mail.gmail.com>
Subject: Re: Linux 2.6.37-rc1 (floppy module load: no device found)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Jens Axboe <jaxboe@fusionio.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 6, 2010 at 5:16 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>
> While scanning the floopy code, I found one more instance of trying to
> access disk->queue pointer after doing put_disk() on gendisk. For some
> reason, floppy moule still loads/unloads fine. May be object is still
> around with right pointer values.

Yes - the normal use-after-free is fairly silent and only causes
problems if something re-allocates the same memory immediately, which
is quite a small race to hit under normal load.

But if you had had slab poisoning on, you'd have seen the same oops
Randy did (well, not the exact same one since the call trace would be
slightly different due to being from a different point, but _very_
similar).

Anyway, applied.

                        Linus
