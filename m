Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab2AWXuM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 18:50:12 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:62676 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab2AWXuB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 18:50:01 -0500
MIME-Version: 1.0
In-Reply-To: <20120123214709.GB17974@thunk.org>
References: <1325774407-28531-1-git-send-email-jack@suse.cz>
 <CA+55aFy0sidnCzPkP6yjnarLZx3a=7QSpgfaf2mUNVy14y3vCw@mail.gmail.com>
 <20120116160136.GC16431@quack.suse.cz> <CA+55aFyUiLq7UZeQD=-MU5ppvEDULiBP8xV0mJqVLL6nFAi7VA@mail.gmail.com>
 <20120117003613.GA28571@dastard> <CA+55aFxZ8dF8WagoyQPYTm92R1ZKd0G_tztqmAc+jrv0LkWGAA@mail.gmail.com>
 <20120123030422.GE15102@dastard> <20120123214709.GB17974@thunk.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 Jan 2012 15:49:39 -0800
X-Google-Sender-Auth: XuUtfO9mtrVU9Hi-1C9c99QiwPk
Message-ID: <CA+55aFxggjW6FKhf7KSCRMD-4YF9ymsxDQ+EMtUTThX16r-8tw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Stop clearing uptodate flag on write IO error
To: "Ted Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Edward Shishkin <edward@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 23, 2012 at 1:47 PM, Ted Ts'o <tytso@mit.edu> wrote:
>
> So how does XFS decide whether a write should fail and shutdown the
> file system, or just "try forever"?

Why would it bother? XFS tends to be a filesystem that you'd only use
for core files in environments where you have a system manager that
knows what he is doing. So there, maybe "try forever" is the right
thing to do.

Things are a bit different with some random unreliable USB stick FAT32
filesystem that just died on you, with a normal user that just removes
the thing or doesn't even notice that the stick is now dead. There the
"try forever" is totally the wrong thing to do.

                            Linus
