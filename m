Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab2DQPCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 11:02:14 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33610 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab2DQPCK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 11:02:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120417052511.GU6589@ZenIV.linux.org.uk>
References: <20120417052511.GU6589@ZenIV.linux.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 17 Apr 2012 08:01:48 -0700
X-Google-Sender-Auth: DhoCHj3XOHv-apVsm2ty-lqeJIY
Message-ID: <CA+55aFw75=Mtq1njQ9vNmNsGuTPbpUhLHnb7YBLmCZs4Q5ByMA@mail.gmail.com>
Subject: Re: [git pull] vfs and fs fixes
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 10:25 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>        A bunch of endianness fixes plus a patch from bfields untangling
> dependencies between vfs and nfsd trees; in principle, we could keep it
> in nfsd tree (along with a bunch of followups that definitely belong there),
> but Miklos' stuff in fs/namei.c steps fairly close to it and overlayfs
> and unionfs series - even closer, so that would create serious PITA for
> both, whichever tree it would sit in.

Why is that double mutex taking in vfs_rename_other() safe from ABBA?

We aren't guaranteed to hold the s_vfs_rename_mutex, since the parent
directories may be the same.

And yes, we hold the i_mutex on that shared parent, but the inodes may
exist (hardlinked) in another directory, so another rename could be
doing the i_mutex in the reverse order.

Maybe there is some reason why that double lock is safe, but I don't
see it, and I want it clearly documented. So I'm not pulling this.

                        Linus
