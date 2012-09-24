Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875Ab2IXFYD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 01:24:03 -0400
Received: from mail.agmk.net ([91.192.224.71]:44921 "EHLO mail.agmk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753314Ab2IXFYA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 01:24:00 -0400
From: =?utf-8?B?UGF3ZcWC?= Sikora <pluto@pld-linux.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        arekm@pld-linux.org, baggins@pld-linux.org, herbert@13thfloor.at
Subject: Re: [2.6.38-3.x] [BUG] soft lockup - CPU#X stuck for 23s! (vfs, autofs, vserver)
Date: Mon, 24 Sep 2012 07:23:55 +0200
Message-ID: <2819949.zde5vZ04eb@localhost>
User-Agent: KMail/4.9.1 (Linux/3.5.4; KDE/4.9.1; x86_64; ; )
In-Reply-To: <CA+55aFymD=QGptAxjSEWffDSA94dtAjPjy-ox76fYWgHn9m+kA@mail.gmail.com>
References: <5092540.GORQ1kUuNX@localhost> <CA+55aFymD=QGptAxjSEWffDSA94dtAjPjy-ox76fYWgHn9m+kA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 of September 2012 18:10:30 Linus Torvalds wrote:
> On Sat, Sep 22, 2012 at 11:09 PM, Paweł Sikora <pluto@pld-linux.org> wrote:
> >
> >         br_read_lock(vfsmount_lock);
> 
> The vfsmount_lock is a "local-global" lock, where a read-lock is
> rather cheap and takes just a per-cpu lock, but the downside is that a
> write-lock is *very* expensive, and can cause serious trouble.
> 
> And the write lock is taken by the [un]mount() paths. Do *not* do
> crazy things. If you do some insane "unmount and remount autofs" on a
> 1s granularity, you're doing insane things.
> 
> Why do you have that 1s timeout? Insane.

1s unmount timeout is *only* for fast bug reproduction (in few seconds after opteron startup)
and testing potential patches. normally with 60s timeout it happens in few minutes..hours
(depends on machine i/o+cpu load) and makes server unusable (permament soft-lockup).
can we redesign vserver's mnt_is_reachable() for better locking to avoid total soft-lockup?

BR,
Paweł.

ps).
i'm adding Herbert to CC.

