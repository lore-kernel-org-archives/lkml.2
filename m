Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab2IXBKx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 21:10:53 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42576 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754716Ab2IXBKw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 21:10:52 -0400
MIME-Version: 1.0
In-Reply-To: <5092540.GORQ1kUuNX@localhost>
References: <5092540.GORQ1kUuNX@localhost>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 23 Sep 2012 18:10:30 -0700
X-Google-Sender-Auth: CodfbdRPHR-aagnVO0p1SmQ_Hpg
Message-ID: <CA+55aFymD=QGptAxjSEWffDSA94dtAjPjy-ox76fYWgHn9m+kA@mail.gmail.com>
Subject: Re: [2.6.38-3.x] [BUG] soft lockup - CPU#X stuck for 23s! (vfs,
 autofs, vserver)
To: =?ISO-8859-2?Q?Pawe=B3_Sikora?= <pluto@pld-linux.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        arekm@pld-linux.org, baggins@pld-linux.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 22, 2012 at 11:09 PM, Paweł Sikora <pluto@pld-linux.org> wrote:
>
>         br_read_lock(vfsmount_lock);

The vfsmount_lock is a "local-global" lock, where a read-lock is
rather cheap and takes just a per-cpu lock, but the downside is that a
write-lock is *very* expensive, and can cause serious trouble.

And the write lock is taken by the [un]mount() paths. Do *not* do
crazy things. If you do some insane "unmount and remount autofs" on a
1s granularity, you're doing insane things.

Why do you have that 1s timeout? Insane.

              Linus
